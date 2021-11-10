module ODF.ODS.CellRange

import public ODF.ODS.CellRef

public export
record CellRange where
    constructor MkCellRange
    topLeft : CellRef
    width : Nat
    height : Nat

%name CellRange range

public export
(.top) : CellRange -> Nat
(MkCellRange (MkCellRef top _) _ _).top = top

public export
(.left) : CellRange -> Nat
(MkCellRange (MkCellRef _ left) _ _).left = left
