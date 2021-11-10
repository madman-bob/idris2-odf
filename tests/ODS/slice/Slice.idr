import ODF

main : IO ()
main = do
    let fileName = the String "../../sampleODFs/simpleSheet.ods"

    Right ods <- readODS fileName
        | Left err => printLn err

    let Just sheet = findSheet "Sheet1" ods
        | Nothing => putStrLn "Sheet not found"

    printLn $ map (map (.value)) $ slice (MkCellRange (MkCellRef 0 1) 2 3) sheet
    printLn $ map (map (.value)) $ slice (MkCellRange (MkCellRef 1 0) 2 3) sheet
