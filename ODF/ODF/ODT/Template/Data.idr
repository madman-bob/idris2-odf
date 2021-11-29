module ODF.ODT.Template.Data

import Language.XML

public export
data ODTTemplate : (vars : List String) -> Type where
  UnsafeMkTemplate : XMLDocument -> ODTTemplate vars

%name ODTTemplate template
