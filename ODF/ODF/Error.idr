module ODF.Error

import public System.File

public export
data ODFError = ODFFileError FileError | MalformedODFFile

export
Show ODFError where
    showPrec p (ODFFileError fileError) = showCon p "ODFFileError" (showArg fileError)
    showPrec p MalformedODFFile = "MalformedODFFile"
