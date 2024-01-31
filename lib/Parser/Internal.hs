module Parser.Internal where

import Text.Parsec
import Text.Parsec.String
import Types
import Prelude hiding (max, min)

defaultValueParser :: Parser String
defaultValueParser = do
  _ <- char '['
  spaces
  val <- many1 $ noneOf "] "
  spaces
  _ <- char ']'
  return val

stringFieldParser :: Parser FieldType
stringFieldParser = do
  _ <- string "string"
  return StringField

enumItemParser :: Parser String
enumItemParser = do
  many1 $ noneOf "|\n[" <* spaces -- Stop at '|' or newline, throw out ' '

-- parses input like "item1 | item2 | item3"
-- enumFieldParser :: Parser FieldType
-- enumFieldParser = do
--   _ <- notFollowedBy $ choice (map string ["string", "bool"]) *> spaces
--   vals <- enumItemParser `sepBy` try (char '|' >> spaces)
--   return $ EnumField vals

enumFieldParser :: Parser FieldType
enumFieldParser = do
  vals <- enumItemParser `sepBy` (char '|' >> spaces)
  return $ EnumField vals

-- parses input like "1..10" or "1.."
rangeFieldParser :: Parser FieldType
rangeFieldParser = do
  min <- many1 digit
  _ <- char '.'
  _ <- char '.'
  max <- many1 digit <|> return ""
  return $ RangeField (read min) (read max)

boolFieldParser :: Parser FieldType
boolFieldParser = do
  _ <- string "bool"
  return BoolField

-- configFieldContentParser :: Parser FieldContent
-- configFieldContentParser = do
--   fieldType <- enumFieldParser <|> stringFieldParser <|> rangeFieldParser <|> boolFieldParser
--   spaces
--   FieldContent fieldType <$> defaultValueParser

configFieldContentParser :: Parser FieldContent
configFieldContentParser = do
  fieldType <- try stringFieldParser <|> try enumFieldParser <|> try rangeFieldParser <|> boolFieldParser
  spaces
  defValue <- optionMaybe defaultValueParser
  return $ FieldContent fieldType defValue

configFieldParser :: Parser Field
configFieldParser = do
  name <- many1 letter
  spaces
  _ <- char ':'
  spaces
  Field name <$> configFieldContentParser

templateParser :: Parser Template
templateParser = do
  -- Parse the template name
  name <- many1 letter
  spaces
  _ <- char ':'
  spaces
  -- Parse the fields within the template
  fields <- many1 configFieldParser `sepEndBy` newline
  return $ Template name (concat fields)

parseConfigFile :: String -> Either ParseError [Template]
parseConfigFile = parse (many templateParser) ""
