module ODF.ODS.CellRef

import Data.Nat

public export
data CellRef = MkCellRef Nat Nat

%name CellRef ref

colName : Nat -> String
colName colIndex = pack $ colName' [] (S colIndex)
  where
    colName' : List Char -> Nat -> List Char
    colName' acc 0 = acc
    colName' acc n = case n `mod` 26 of
        0 => colName' ('Z' :: acc) (pred $ n `div` 26)
        rem => let c = chr $ 64 + cast rem in
               colName' (c :: acc) (n `div` 26)

export
Show CellRef where
    show (MkCellRef row col) = colName col ++ show (S row)
