module ODF.ODS.IO

import public ODF.Error
import ODF.IO
import public ODF.ODS.Document

export
readODS : HasIO io => (fileName : String) -> io (Either ODFError ODS)
readODS fileName = map (map MkODS) $ readContent fileName
