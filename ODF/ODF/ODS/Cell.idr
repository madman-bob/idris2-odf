module ODF.ODS.Cell

import Data.String

import Language.XML

import public ODF.ODS.CellValue

public export
data Cell = MkCell Element

%name Cell cell

export
(.value) : Cell -> CellValue
(MkCell cell).value = do
    let valueTypeName = MkQName (Just $ MkName "office") (MkName "value-type")
    let valueName = MkQName (Just $ MkName "office") (MkName "value")
    let stringValueName = MkQName (Just $ MkName "office") (MkName "string-value")
    let displayValueName = MkQName (Just $ MkName "text") (MkName "p")

    case lookup valueTypeName cell.attrs of
         Just "float" => FloatCell $ maybe (0/0) id (lookup valueName cell.attrs >>= parseDouble)
         _ => TextCell $ maybe "" textContent (find (\elem => elem.name == displayValueName) cell)
