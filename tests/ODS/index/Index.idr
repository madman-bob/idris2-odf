import ODF

main : IO ()
main = do
    let fileName = the String "../../sampleODFs/simpleSheet.ods"

    Right ods <- readODS fileName
        | Left err => printLn err

    let Just sheet = findSheet "Sheet1" ods
        | Nothing => putStrLn "Sheet not found"

    printLn $ map (\ref => (index ref sheet).value) [
        MkCellRef 0 0,
        MkCellRef 0 1,
        MkCellRef 1 0,
        MkCellRef 1 1,
        MkCellRef 2 1,
        MkCellRef 2 2,
        MkCellRef 3 1
      ]
