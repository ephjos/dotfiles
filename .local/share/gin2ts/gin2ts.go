package main

import (
	"bufio"
	"bytes"
	"fmt"
	"io"
	"log"
	"os"
	"strings"
)

type Endpoint struct {
	Method   string
	Name     string
	UrlParts []string
}

type RouterGroup struct {
	Root      string
	Endpoints []Endpoint
}

type Token int

const (
	// Specials
	ILLEGAL Token = iota
	IGNORE
	EOF
	WS
	NL

	ATTACH
	GROUP
	METHOD

	// Url tokens
	LITERAL
	HANDLER

	// Misc
	PAREN
	BRACE
	PERIOD
	SLASH
	COLON
	QUOTE
)

func isWhitespace(ch rune) bool {
	return ch == ' ' || ch == '\t'
}

func isLetter(ch rune) bool {
	return (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z')
}

func isDigit(ch rune) bool {
	return (ch >= '0' && ch <= '9')
}

var eof = rune(0)

type Scanner struct {
	r *bufio.Reader
}

func NewScanner(r io.Reader) *Scanner {
	return &Scanner{r: bufio.NewReader(r)}
}

func (s *Scanner) read() rune {
	ch, _, err := s.r.ReadRune()
	if err != nil {
		return eof
	}
	return ch
}

func (s *Scanner) unread() { _ = s.r.UnreadRune() }

func (s *Scanner) Scan() (tok Token, lit string) {
	ch := s.read()

	if isWhitespace(ch) {
		s.unread()
		return s.scanWhitespace()
	} else if isLetter(ch) {
		s.unread()
		return s.scanIdent()
	}

	switch ch {
	case eof:
		return EOF, ""
	case '\n':
		return NL, string(ch)
	case '/':
		return SLASH, string(ch)
	case ':':
		return COLON, string(ch)
	case '(', ')':
		return PAREN, string(ch)
	case '{', '}':
		return BRACE, string(ch)
	case '.':
		return PERIOD, string(ch)
	case '"':
		return QUOTE, string(ch)
	}

	return IGNORE, string(ch)
}

func (s *Scanner) scanWhitespace() (tok Token, lit string) {
	var buf bytes.Buffer

	buf.WriteRune(s.read())

	for {
		ch := s.read()
		if ch := s.read(); ch == eof {
			break
		}
		if !isWhitespace(ch) {
			s.unread()
			break
		}
		buf.WriteRune(ch)
	}

	return WS, buf.String()
}

func (s *Scanner) scanIdent() (tok Token, lit string) {
	var buf bytes.Buffer
	buf.WriteRune(s.read())

	for {
		if ch := s.read(); ch == eof {
			break
		} else if !isLetter(ch) && !isDigit(ch) && ch != '_' {
			s.unread()
			break
		} else {
			_, _ = buf.WriteRune(ch)
		}
	}

	switch strings.ToUpper(buf.String()) {
	case "GET", "PUT", "POST", "DELETE":
		return METHOD, buf.String()
	case "HANDLER":
		return HANDLER, buf.String()
	case "GROUP":
		return GROUP, buf.String()
	case "ATTACH":
		return ATTACH, buf.String()
	}

	return LITERAL, buf.String()
}

type Parser struct {
	s   *Scanner
	buf struct {
		tok Token
		lit string
		n   int
	}
}

func NewParser(r io.Reader) *Parser {
	return &Parser{s: NewScanner(r)}
}

func (p *Parser) scan() (tok Token, lit string) {
	if p.buf.n != 0 {
		p.buf.n = 0
		return p.buf.tok, p.buf.lit
	}

	tok, lit = p.s.Scan()

	p.buf.tok, p.buf.lit = tok, lit
	return
}

func (p *Parser) unscan() { p.buf.n = 1 }

func (p *Parser) scanIgnoreWhitespace() (tok Token, lit string) {
	tok, lit = p.scan()
	if tok == WS {
		tok, lit = p.scan()
	}
	return tok, lit
}

func (p *Parser) parseEndpoint() (*Endpoint, error) {
	ep := &Endpoint{}

	// Read method
	for {
		tok, lit := p.scanIgnoreWhitespace()
		if tok == METHOD {
			log.Printf("  Method: %s\n", lit)
			ep.Method = lit
			break
		}
	}

	// Read ("
	if tok, lit := p.scanIgnoreWhitespace(); tok != PAREN {
		return nil, fmt.Errorf("found %q, expected PAREN", lit)
	}

	if tok, lit := p.scanIgnoreWhitespace(); tok != QUOTE {
		return nil, fmt.Errorf("found %q, expected QUOTE", lit)
	}

	// Parse URL Parts
	for {
		tok, lit := p.scanIgnoreWhitespace()
		if tok == QUOTE {
			break
		}
		if tok == SLASH {
			continue
		}
		if tok == COLON {
			if ntok, nlit := p.scanIgnoreWhitespace(); ntok == LITERAL {
				log.Printf("  URL param: %s", nlit)
				ep.UrlParts = append(ep.UrlParts, "${"+nlit+"}")
			} else {
				p.unscan()
				break
			}
		}
		if tok == LITERAL {
			log.Printf("  URL part: %s", lit)
			ep.UrlParts = append(ep.UrlParts, lit)
		}
	}

	for {
		tok, _ := p.scanIgnoreWhitespace()
		if tok == HANDLER {
			tok, _ := p.scanIgnoreWhitespace()
			if tok == PERIOD {
				tok, lit := p.scanIgnoreWhitespace()
				if tok == LITERAL {
					ep.Name = lit
				}
			}
		}
		if tok == NL {
			break
		}
	}

	return ep, nil
}

func (p *Parser) Parse() (*RouterGroup, error) {
	rg := &RouterGroup{}

	log.Println("Parsing...")

	// Read method
	for {
		tok, _ := p.scanIgnoreWhitespace()
		if tok == ATTACH {
			log.Println("ATTACH")
			break
		}
	}

outer:
	for {
		tok, _ := p.scanIgnoreWhitespace()
		if tok == GROUP {
			log.Println("GROUP")
			for {
				tok, lit := p.scanIgnoreWhitespace()
				if tok == LITERAL {
					log.Printf("Root: %s\n", lit)
					rg.Root = lit
					break outer
				}
			}
		}
	}

	for {
		tok, _ := p.scanIgnoreWhitespace()
		if tok == BRACE {
			break
		}
		if ep, err := p.parseEndpoint(); err == nil {
			log.Printf("Endpoint: %s\n", ep.Name)
			rg.Endpoints = append(rg.Endpoints, *ep)
		} else {
			return nil, err
		}
	}

	log.Println("Parsing done!")
	return rg, nil
}

func main() {
	if len(os.Args) == 1 {
		log.Fatal("Must provide a path to a file to parse")
		os.Exit(1)
	}

	filename := os.Args[1]

	fmt.Println(filename)

	file, err := os.Open(filename)
	if err != nil {
		log.Fatal(err)
		os.Exit(2)
	}
	defer file.Close()

	p := NewParser(file)
	rg, err := p.Parse()
	if err != nil {
		log.Fatal(err)
		os.Exit(3)
	}

	fmt.Println(rg)
	// TODO: Added template for RequestGroup
}
