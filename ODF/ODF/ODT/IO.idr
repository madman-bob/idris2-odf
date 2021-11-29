module ODF.ODT.IO

import public ODF.IO
import public ODF.ODT.Document
import public ODF.ODT.Template
import ODF.ODT.Template.Parser

export
readODT : HasIO io => (fileName : String) -> io (Either ODFError ODT)
readODT fileName = map (map MkODT) $ readContent fileName

export
updateODT : HasIO io => (fileName : String) -> ODT -> io (Either ODFError ())
updateODT fileName (MkODT doc) = updateContent fileName doc

export
readODTTemplate : HasIO io => (fileName : String) -> io (Either ODFError (vars : List String ** ODTTemplate vars))
readODTTemplate fileName = map (map parse) $ readODT fileName
