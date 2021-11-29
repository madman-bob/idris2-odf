module ODF.IO

import System
import System.File

import Data.String.Parser

import public Language.XML

import public ODF.Error

export
readContent : HasIO io => (fileName : String) -> io (Either ODFError XMLDocument)
readContent fileName = do
    (xmlStr, 0) <- run ["unzip", "-p", fileName, "content.xml"]
        | (_, 9) => pure $ Left $ ODFFileError FileNotFound
        | (_, _) => pure $ Left MalformedODFFile

    let Right (xml, _) = parse (xmlDocument <* spaces <* eos) xmlStr
        | Left _ => pure $ Left MalformedODFFile

    pure $ Right xml

export
updateContent : HasIO io => (fileName : String) -> XMLDocument -> io (Either ODFError ())
updateContent fileName doc = do
    (_, 0) <- run ["zip", "-d", fileName, "content.xml"]
        | (_, 13) => pure $ Left $ ODFFileError FileNotFound
        | (_, 14) => pure $ Left $ ODFFileError FileWriteError
        | (_, 15) => pure $ Left $ ODFFileError FileWriteError
        | _ => pure $ Left MalformedODFFile

    let fName = escapeArg fileName

    Right f <- popen #"zip -u \#{fName} - > /dev/null && printf "@ -\n@=content.xml\n" | zipnote -w \#{fName}"# WriteTruncate
        | Left err => pure $ Left $ ODFFileError err

    Right () <- fPutStr f $ show doc
        | Left err => pure $ Left $ ODFFileError err

    0 <- pclose f
        | 13 => pure $ Left $ ODFFileError FileNotFound
        | 14 => pure $ Left $ ODFFileError FileWriteError
        | 15 => pure $ Left $ ODFFileError FileWriteError
        | _ => pure $ Left MalformedODFFile

    pure $ Right ()
