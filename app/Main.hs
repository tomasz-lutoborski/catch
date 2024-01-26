module Main where

import Text.Parsec
import Text.Parsec.String

type TemplateName = String

type FieldName = String

type FieldType = String

type DefaultValue = Maybe String

data Field = Field FieldName FieldType DefaultValue

data Template = Template TemplateName [Field]

instance Show Template where
  show (Template name fields) = name ++ show fields

instance Show Field where
  show (Field name ftype defValue) = name ++ ":" ++ ftype ++ show defValue

fieldParser :: Parser Field
fieldParser = do
  _ <- spaces
  name <- many1 letter
  _ <- char ':'
  spaces
  ftype <- many1 letter
  _ <- spaces
  defValue <- optionMaybe defaultValueParser
  return $ Field name ftype defValue

defaultValueParser :: Parser String
defaultValueParser = do
  _ <- char '['
  defaultValue <- many1 letter
  _ <- char ']'
  return defaultValue

templateParser :: Parser Template
templateParser = do
  name <- many1 letter
  _ <- char ':'
  _ <- newline
  fields <- many1 fieldParser
  return $ Template name fields

main :: IO ()
main = do
  templates <- readFile "dev/config.catch"
  let parsedTemplate = parse templateParser "" templates
  case parsedTemplate of
    Left err -> print err
    Right fields -> print fields