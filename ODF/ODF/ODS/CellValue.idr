module ODF.ODS.CellValue

public export
data CellValue = TextCell String | FloatCell Double

public export
fromString : String -> CellValue
fromString = TextCell

public export
fromDouble : Double -> CellValue
fromDouble = FloatCell

public export
Show CellValue where
    show (TextCell val) = show val
    show (FloatCell val) = show val
