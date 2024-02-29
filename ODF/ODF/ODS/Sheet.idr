module ODF.ODS.Sheet

import Data.Either
import Data.List
import Data.Stream
import Data.Stream.Extra
import public Data.Vect

import Language.XML

import public ODF.ODS.Cell
import public ODF.ODS.CellRange
import public ODF.ODS.CellRef
import public ODF.ODS.CellValue

data Row = MkRow Element

%name Row row

public export
data Sheet = MkSheet Element

%name Sheet sheet

namespace Row
    rowName : QName
    rowName = MkQName (Just $ MkName "table") (MkName "table-row")

    namespace List
        export
        rows : Sheet -> List Row
        rows (MkSheet sheet) = map MkRow $ filter (\elem => elem.name == rowName) $ rights $ evens sheet.content

    export
    emptyRow : Row
    emptyRow = MkRow $ EmptyElem rowName []

    namespace Stream
        export
        rows : Sheet -> Stream Row
        rows sheet = startWith (List.rows sheet) $ repeat emptyRow

namespace Cell
    cellName : QName
    cellName = MkQName (Just $ MkName "table") (MkName "table-cell")

    namespace List
        filterCells : Row -> List Cell
        filterCells (MkRow row) = map MkCell
                                $ filter (\elem => elem.name == cellName)
                                $ rights $ evens row.content
        expandCells : List Cell -> List Cell
        expandCells cells = do
          cell@(MkCell elem) <- cells
          case List.filter
                 (\attr => attr.name == (MkQName (Just $ MkName "table")
                                                       $ MkName "number-columns-repeated"))
                 elem.attrs
               of
            [] => pure cell
            -- Silent failure??
            (val :: _) => replicate
                            (cast val.value)
                            -- Also should probs return a modified cell,
                            -- without the columns-repeated attribute
                            cell

        export
        cells : Row -> List Cell
        cells mrow@(MkRow row) = expandCells $ filterCells mrow

    export
    emptyCell : Cell
    emptyCell = MkCell $ EmptyElem cellName []

    namespace Stream
        export
        cells : Row -> Stream Cell
        cells row = startWith (List.cells row) $ repeat emptyCell

export
index : CellRef -> Sheet -> Cell
index (MkCellRef row col) sheet = Stream.index col $ cells (Stream.index row $ rows sheet)

export
slice : (r : CellRange) -> Sheet -> Vect r.height (Vect r.width Cell)
slice r sheet =
  let rows = take r.height $ drop r.top $ rows sheet in
  map (\row => take r.width $ drop r.left $ cells row) rows

export
find : (Cell -> Bool) -> Sheet -> Maybe Cell
find f sheet = flip choiceMap (List.rows sheet) $
    \row => flip choiceMap (List.cells row) $
    \cell => toMaybe (f cell) cell

export
findByValue : CellValue -> Sheet -> Maybe Cell
findByValue x = find ((== x) . (.value))

enumNat : List a -> List (Nat, a)
enumNat = enumNat' 0 where
    enumNat' : Nat -> List a -> List (Nat, a)
    enumNat' _ [] = []
    enumNat' acc (x :: xs) = (acc, x) :: enumNat' (S acc) xs

export
findIndex : (Cell -> Bool) -> Sheet -> Maybe CellRef
findIndex f sheet = flip choiceMap (enumNat $ List.rows sheet) $
    \(rowIndex, row) => flip choiceMap (enumNat $ List.cells row) $
    \(colIndex, cell) => toMaybe (f cell) $ MkCellRef rowIndex colIndex
