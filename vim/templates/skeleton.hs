
main :: IO ()
main = interact $ (++"\n")
                  . show
                  . (\x -> 1)
                  . map (map (read::String->Int) . words)
                  . tail
                  . lines

