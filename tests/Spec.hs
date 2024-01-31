module Main where

import Parser (parseConfigFile)
import Test.Hspec
import Text.Parsec (parse)
import Types
import Types (Template (Template))

main :: IO ()
main = hspec $ do
  describe "intToString" $ do
    it "behaves correctly" $
      do
        parseConfigFile "todo:\n  title: string [hello ]\n  importance: 1..4 [ 1 ]\n  status: doing | todo | done [done]"
        `shouldBe` Right ([Template "todo" [Field "title" (FieldContent StringField "hello "), Field "importance" (FieldContent (RangeField 1 4) " 1 "), Field "status" (FieldContent (EnumField ["doing", "todo", "done"]) "done")]])
