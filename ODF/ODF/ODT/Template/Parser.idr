module ODF.ODT.Template.Parser

import Control.Monad.State
import Data.SortedSet
import Data.String.Parser

import Language.XML

import public ODF.ODT.Document
import public ODF.ODT.Template.Data

export
parse : ODT -> (vars : List String ** ODTTemplate vars)
parse (MkODT doc) = do
    let (vars, root) = runState empty $ parseElem doc.root
    (SortedSet.toList vars ** UnsafeMkTemplate $ { root := root } doc)
  where
    varPlaceholder : Parser (String, Element)
    varPlaceholder = do
        ignore $ string "$"
        varName <- takeWhile isAlpha
        pure (varName, EmptyElem (MkQName (Just $ MkName "template") (MkName varName)) [])

    templateCharData : Parser (SortedSet String, Odd CharData Element)
    templateCharData = do
        let Right (init, _) = parse (charData <* eos) !(takeWhile (/= '$'))
            | Left err => fail err
        Just (name, placeholder) <- optional varPlaceholder
            | Nothing => pure (empty, [init])
        (names, rest) <- templateCharData
        pure $ (insert name names, init :: placeholder :: rest)

    parseCharData : CharData -> State (SortedSet String) (Odd CharData (Either Misc Element))
    parseCharData c = case parse (templateCharData <* eos) $ show c of
        Left err => assert_total $ idris_crash "Failed to parse char data as template - should be impossible"
        Right ((names, template), _) => do
            modify $ union names
            pure $ bimap id Right $ template

    mutual
        parseElem : Element -> State (SortedSet String) Element
        parseElem = mapContentM parseContent

        parseContent : Odd CharData (Either Misc Element) ->
                       State (SortedSet String) (Odd CharData (Either Misc Element))
        parseContent [charData] = parseCharData charData
        parseContent (charData :: Left  misc :: rest) = do
          pre <- parseCharData charData
          post <- parseContent rest
          pure (pre ++ (Left misc :: post))
        parseContent (charData :: Right elem :: rest) = do
            pre <- parseCharData charData
            mid <- parseElem elem
            post <- parseContent rest
            pure (pre ++ (Right mid :: post))
