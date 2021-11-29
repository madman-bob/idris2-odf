import ODF

main : IO ()
main = do
    Right (["fromName", "toName"] ** template) <- readODTTemplate "spam.odt"
        | Right (vars ** template) => putStrLn "Unexpected template vars: \{show vars}"
        | Left err => printLn err

    let spam = render template [
        "fromName" ::= ["Mr. Jerry Smith"],
        "toName" ::= ["Sir/Madam"]
      ]

    Right () <- updateODT "spam.odt" spam
        | Left err => printLn err

    pure ()
