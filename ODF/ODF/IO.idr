module ODF.IO

import System

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
