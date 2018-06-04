FILE = ""

make:
	@pandoc $(FILE).md -o $(FILE).pdf --from markdown --template eisvogel --listings
	@mupdf $(FILE).pdf &

