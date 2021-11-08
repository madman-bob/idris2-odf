module ODF.ODS.Sheet

import Data.List

import Language.XML

import public ODF.ODS.Cell
import public ODF.ODS.CellRef

public export
data Sheet = MkSheet Element

%name Sheet sheet

export
index : CellRef -> Sheet -> Cell
index (MkCellRef row col) (MkSheet sheet) = do
    let rowName = MkQName (Just $ MkName "table") (MkName "table-row")
    let cellName = MkQName (Just $ MkName "table") (MkName "table-cell")

    MkCell $ maybe (EmptyElem cellName []) id $ do
        r <- getAt row $ filter (\elem => elem.name == rowName) $ evens sheet.content
        getAt col $ filter (\elem => elem.name == cellName) $ evens r.content
