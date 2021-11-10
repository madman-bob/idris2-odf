module ODF.ODS.Sheet

import Data.List
import Data.Stream
import Data.Stream.Extra
import public Data.Vect

import Language.XML

import public ODF.ODS.Cell
import public ODF.ODS.CellRange
import public ODF.ODS.CellRef

data Row = MkRow Element

%name Row row

public export
data Sheet = MkSheet Element

%name Sheet sheet

(.rows) : Sheet -> Stream Row
(MkSheet sheet).rows =
    let rowName = MkQName (Just $ MkName "table") (MkName "table-row") in
    startWith
        (map MkRow $ filter (\elem => elem.name == rowName) $ evens sheet.content)
        (repeat $ MkRow $ EmptyElem rowName [])

(.cells) : Row -> Stream Cell
(MkRow row).cells =
    let cellName = MkQName (Just $ MkName "table") (MkName "table-cell") in
    startWith
        (map MkCell $ filter (\elem => elem.name == cellName) $ evens row.content)
        (repeat $ MkCell $ EmptyElem cellName [])

export
index : CellRef -> Sheet -> Cell
index (MkCellRef row col) sheet = Stream.index col (Stream.index row sheet.rows).cells

export
slice : (r : CellRange) -> Sheet -> Vect r.height (Vect r.width Cell)
slice r sheet =
  let rows = take r.height $ drop r.top sheet.rows in
  map (\row => take r.width $ drop r.left row.cells) rows
