import ODF

main : IO ()
main = do
    let fileName = the String "../../sampleODFs/simpleSheet.ods"

    Right ods <- readODS fileName
        | Left err => printLn err

    let Just sheet = findSheet "Sheet1" ods
        | Nothing => putStrLn "Sheet not found"

    printLn $ map (.value) $ find (\cell => cell.value == 1.0) sheet
    printLn $ map (.value) $ find (\cell => cell.value == 4.0) sheet

    printLn $ map (.value) $ findByValue 1.0 sheet
    printLn $ map (.value) $ findByValue 4.0 sheet

    printLn $ findIndex (\cell => cell.value == 6.0) sheet
    printLn $ findIndex (\cell => cell.value == 4.0) sheet
