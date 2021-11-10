import ODF

main : IO ()
main = do
    printLn $ the (List CellValue) ["Lorem ipsum", "Hello world", 1.0, 2.0, 3.0]
