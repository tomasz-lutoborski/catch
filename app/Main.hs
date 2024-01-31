module Main where

import Parser

main :: IO ()
main = do
  print $ parseConfigFile "todo:\n  foo: string [bar]\n  baz: 1..4 [4]\n  qux: bool [true]\n  quux: item1 | item2 | item3 [item2]"
