module Types where

data Template = Template
  { templateName :: String,
    templateFields :: [Field]
  }
  deriving (Show, Eq)

data FieldType
  = StringField
  | EnumField [String]
  | RangeField Int Int
  | BoolField
  deriving (Show, Eq)

data FieldContent = FieldContent
  { fieldContentType :: FieldType,
    fieldContentDefault :: Maybe String
  }
  deriving (Show, Eq)

data Field = Field
  { fieldName :: String,
    fieldContent :: FieldContent
  }
  deriving (Show, Eq)