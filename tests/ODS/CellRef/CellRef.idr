import ODF

main : IO ()
main = do
    printLn $ MkCellRef 0 0
    printLn $ MkCellRef 2 1

    printLn $ MkCellRef 9 12
    printLn $ MkCellRef 37 13

    printLn $ MkCellRef 0 25
    printLn $ MkCellRef 0 26

    printLn $ MkCellRef 0 701
    printLn $ MkCellRef 0 702
