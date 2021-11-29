module ODF.ODT.Template.Substitution

import Data.List.Elem

import public Language.XML

import ODF.ODT.Document
import ODF.ODT.Template.Data

infix 10 ::=

public export
data Substitutions : List String -> Type where
  Nil : Substitutions []
  (::) : (subst : (String, Odd CharData Element)) -> Substitutions vars -> Substitutions (fst subst :: vars)

%name Substitutions substs

public export
(::=) : a -> b -> (a, b)
(::=) = (,)

export
done : ODTTemplate [] -> ODT
done (UnsafeMkTemplate doc) = MkODT doc

export
substitute : (var : String)
          -> (replacement : Odd CharData Element)
          -> {auto 0 elem : Elem var vars}
          -> ODTTemplate vars
          -> ODTTemplate (dropElem vars elem)
substitute var replacement (UnsafeMkTemplate doc) = UnsafeMkTemplate $ mapContent substituteContent doc
  where
    substituteContent : Element -> Element
    substituteContent = mapContent $ \content => Snd.do
        elem@(EmptyElem (MkQName (Just $ MkName "template") (MkName name)) []) <- map substituteContent content
            | elem => pure elem
        if name == var
            then replacement
            else pure elem

export
render : ODTTemplate vars -> Substitutions vars -> ODT
render template [] = done template
render template ((name, replacement) :: substs) = render (substitute name replacement template) substs
