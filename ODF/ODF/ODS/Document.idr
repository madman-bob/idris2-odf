module ODF.ODS.Document

import Language.XML

import public ODF.ODS.Sheet

public export
data ODS = MkODS XMLDocument

%name ODS doc

export
findSheet : String -> ODS -> Maybe Sheet
findSheet sheetName (MkODS doc) = do
    let bodyName = MkQName (Just $ MkName "office") (MkName "body")
    let spreadsheetName = MkQName (Just $ MkName "office") (MkName "spreadsheet")
    let tableName = MkQName (Just $ MkName "table") (MkName "table")
    let sheetNameName = MkQName (Just $ MkName "table") (MkName "name")

    body <- find (\elem => elem.name == bodyName) doc.root
    spreadsheet <- find (\elem => elem.name == spreadsheetName) body
    table <- find (\elem =>
        elem.name == tableName &&
        maybe False (== sheetName) (lookup sheetNameName elem.attrs)
      ) spreadsheet
    pure $ MkSheet table
