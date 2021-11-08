module ODF.ODS.CellValue

public export
data CellValue = TextCell String | FloatCell Double

public export
Show CellValue where
    show (TextCell val) = show val
    show (FloatCell val) = show val
