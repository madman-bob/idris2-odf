module ODFTests

import Test.Golden

odsTests : TestPool
odsTests = MkTestPool "ODS" [] Nothing [
    "CellRef", "CellValue", "find", "index", "slice"
  ]

odtTests : TestPool
odtTests = MkTestPool "ODT" [] Nothing [
    "Template"
  ]

main : IO ()
main = runner [
    testPaths "ODS" odsTests,
    testPaths "ODT" odtTests
  ]
  where
    testPaths : String -> TestPool -> TestPool
    testPaths dir = record { testCases $= map ((dir ++ "/") ++) }
