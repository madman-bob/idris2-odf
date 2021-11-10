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
Eq CellValue where
    TextCell x == TextCell y = x == y
    FloatCell x == FloatCell y = x == y
    _ == _ = False

public export
Show CellValue where
    show (TextCell val) = show val
    show (FloatCell val) = show val
