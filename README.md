# Idris2-ODF

An OpenDocument Format (ODF) library for Idris 2.

The OpenDocument Format is used by the LibreOffice suite of products.

## Install

Run:

```bash
make install
```

## Usage

Build your code with the `contrib`, `xml`, and `odf` packages, and import the `ODF` library.

### Example

To read the value of a particular cell in an `.ods` spreadsheet:

```idris
import ODF

main : IO ()
main = do
    Right ods <- readODS "mySheet.ods"
        | Left err => printLn err

    let Just sheet = findSheet "Sheet1" ods
        | Nothing => putStrLn "Sheet not found"

    let a1 = MkCellRef 0 0
    printLn (index a1 sheet).value
```
