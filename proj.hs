
import Data.List
import Data.String
import Data.Function
import Data.Ord
import Data.Char
{- type Polynomial = [(Integer,[Char],[Integer])] -}
type Polynomial = [Monomial]
type Monomial = (Int, Vars)
type Vars = [(Char, Int)]

{-sorts monomial by descending value of exponent-}
sortMonomial :: Monomial -> Monomial
sortMonomial (c, xs) = (c, sortBy (flip compare `on` snd) xs) 

{-sorts polynomial by char-}
sortPoly::Polynomial->Polynomial
sortPoly = sortBy (compare `on` snd)

{-combines sortPoly with sortMonomial-}
sortTotal::Polynomial->Polynomial
sortTotal [] = []
sortTotal (x:xs) = sortPoly (sortMonomial x : sortTotal xs)


{- removes all variables with a 0 exponent from a single monomial -}
removeNullExp :: Vars -> [(Char,Int)]
removeNullExp [] = []
removeNullExp ((a,b):xs)
    | b == 0 = removeNullExp xs
    | otherwise = (a,b): removeNullExp xs

{- removes all monomials whose coeficient is 0 and calls 'removeNullExp' on all monomials -}
stripPoly :: Polynomial -> Polynomial
stripPoly [] = []
stripPoly ((0,x:xs):xss) = stripPoly xss
stripPoly ((a,[]):xs) = (a,[]):stripPoly xs
stripPoly ((a,(b, c):xs):xss) = (a, removeNullExp ((b,c):xs) ): stripPoly xss

{- adds monomials -}
addMonomials :: Monomial -> Monomial -> Monomial
addMonomials m1 m2 = (fst m1 + fst m2, snd m1)

{- checks if the literal parts are equal and adds the monomials -}
addSameExp:: Monomial -> Polynomial -> Polynomial
addSameExp m1 [] = [m1]
addSameExp m1 (x:xs)
    | snd m1 == snd x = addMonomials m1 x : xs
    | otherwise = x: addSameExp m1 xs

{- checks if a var is repeated in the same monomial and joins it by adding the exponents -}
joinSameVar :: (Char, Int) -> Vars -> Vars
joinSameVar v [] = [v]
joinSameVar v (x:xs)
    | fst v == fst x = joinSameVar (fst v, snd v + snd x) xs
    | otherwise = x : joinSameVar v xs

{- iterates the monomial vars list and joins all the same exponents -}
iterJoinSameVar :: Vars -> Vars
iterJoinSameVar [] = []
iterJoinSameVar (x:xs) = let varList = joinSameVar x xs
                            in iterJoinSameVar (init varList) ++ [last varList]


applyJoinSameVarToPoly :: Polynomial -> Polynomial
applyJoinSameVarToPoly = map (\ x -> (fst x, iterJoinSameVar (snd x)))
{- applyJoinSameVarToPoly (x:xs) = let monList = iterJoinSameVar (snd x)
                                    in applyJoinSameVarToPoly (fst x, init monList) ++ [last monList] -}

varToString :: (Char, Int) -> String
varToString (var, exp) = "*" ++ var : "^" ++ show exp

varsToString :: Vars -> String
varsToString [] = ""
varsToString [x] = varToString x
varsToString (x:xs) = varToString x ++ varsToString xs

monomialToString :: (Int, Vars) -> String
monomialToString m = show (fst m) ++ varsToString (snd m)

polynomialToString :: Polynomial -> String
polynomialToString [] = ""
polynomialToString [x] = monomialToString x
polynomialToString (x:xs)
    | fst (head xs) > 0 = monomialToString x ++ "+" ++ polynomialToString xs
    | fst (head xs) < 0 = monomialToString x ++ polynomialToString xs

{- applies stripPoly and applyJoinSameVarToPoly to a polynomial, then recursively calls addSameExp to normalize a polynomial -}
normalizePolynomial :: Polynomial -> String
--type Polynomial = [(Int,Vars)]
normalizePolynomial a
       | null a = []
       | otherwise = polynomialToString (sortTotal (recursiveHelper (applyJoinSameVarToPoly (stripPoly a))))
       where
       recursiveHelper xs
            | null xs = []
            | otherwise = addSameExp (head xs) (recursiveHelper (tail xs))

{- concatenates two polynomials, then calls normalizePolynomial resulting in the sum and normalization of the input -}
addPolynomials :: Polynomial -> Polynomial -> String
addPolynomials [] b = polynomialToString b
addPolynomials a [] = polynomialToString a
addPolynomials a b = normalizePolynomial (a ++ b)

{-  recursively multiplies coefficient and variables for every monomial in input polynomial -}
distributeMono :: Monomial -> Polynomial -> Polynomial
distributeMono _ [] = []
distributeMono x (y:ys) = (fst x * fst y, iterJoinSameVar (snd x ++ snd y)) : distributeMono x ys

{- multiplies 2 polynomials by recursively calling distributeMono for every monomial on the first polynomial -}
roughMultPoly :: Polynomial -> Polynomial -> String
roughMultPoly [] [] = []
roughMultPoly a [] = []
roughMultPoly [] b = []
roughMultPoly (x:xs) y = "(" ++ polynomialToString(distributeMono x y) ++ ")"++ "+" ++ roughMultPoly xs y

{- calls roughMultPoly on input and cleans up the resulting string -}
multPoly::Polynomial->Polynomial->String
multPoly [] [] = []
multPoly a [] = []
multPoly [] b = []
multPoly x y = init(roughMultPoly x y)

{- reduces exponent value by 1 if variable == given input char -}
subExponents :: [(Char,Int)] -> Char -> [(Char,Int)]
subExponents [] _ = []
subExponents (x:xs) b
    | fst x == b = (b, snd x -1) : subExponents xs b
    | otherwise = x: subExponents xs b

{- multiplies coefficient by exponent value of every var == to given char, then calls subExponents on the list of variables-}
derivMono :: Monomial -> Char -> Monomial
derivMono (x,y) b = (x * snd(head (filter(\(m,n)-> m == b) y)), subExponents y b)

{-checks if the monomial has any variabe == to input char-}
checkDerivMono :: Monomial -> Char -> Bool
checkDerivMono (x,y) b
    |not (any (\(m,n) -> m == b) y) = False
    |otherwise = True

{-recursively calls checkDerivMono on every monomial in input polynomial, then derivates it if the result is True, otherwise ignores it-}
roughDerivPoly :: Polynomial -> Char -> Polynomial
roughDerivPoly [] _ = []
roughDerivPoly (x:xs) b = if checkDerivMono x b then derivMono x b : roughDerivPoly xs b else roughDerivPoly xs b

{- normalizes the roughDerivPoly result -}
derivPoly :: Polynomial -> Char -> String
derivPoly [] _ = []
derivPoly a b = normalizePolynomial(roughDerivPoly a b)

{- removes all spaces from string -}
filterSpaces:: String -> String
filterSpaces = filter (/= ' ')

parserVars :: String -> Vars
parserVars [] = []
parserVars (x:[]) = [(x,1)]
parserVars (x:xs)
    | x == ' ' = parserVars xs
    | x == '*' = parserVars xs
    | (head xs == '^') && (head(tail xs)=='-') = (x, read ('-' : takeWhile isDigit (tail(tail xs))) :: Int) : parserVars (dropWhile (not . isAlpha) xs)
    | (head xs == '^') && (x /= '*') = (x, read (takeWhile isDigit (tail xs)) :: Int) : parserVars (dropWhile (not . isAlpha) xs)
    | otherwise = (x, 1) : parserVars xs

parserMono :: String -> Monomial
parserMono [] = (0,[])
parserMono (x:xs)
    | isDigit x = (read (x : takeWhile isDigit xs) :: Int, parserVars (takeWhile (\n-> (n/= '+') && (n/= '-'))  (dropWhile isDigit xs)))
    | x == '-' && isDigit (head xs) =  (read(x:takeWhile isDigit xs)::Int, parserVars(takeWhile (\n->(n /= '+') && (n /= '-')) (dropWhile isDigit xs)))
    | x == '-' && (not . isDigit) (head xs) = (-1, parserVars (takeWhile (\ n -> (n /= '+') && (n/= '-')) (dropWhile isDigit xs)))
    | otherwise = (1,parserVars(takeWhile (\n-> (n /= '+') && (n /= '-'))(dropWhile isDigit (x:xs))))
 

{- parserMono :: String -> Monomial
parserMono [] = (0,[])
parserMono (x:xs)
    | isDigit x = (read (x : takeWhile isDigit xs) :: Int, parserVars xs)
    | x == '-' && isDigit (head xs) = (read('-' : takeWhile isDigit xs) ::Int, parserVars (dropWhile isDigit xs))
    | x == '-' && (not . isDigit) (head xs) = (-1, parserVars xs)
    | otherwise = (1, parserVars xs)
 -}
dropMono:: String -> String
dropMono [] = []
dropMono a = dropWhile (\x -> x /= '+' && x /= '-') a

roughParserPoly :: String -> Polynomial
roughParserPoly [] = []
roughParserPoly (x:xs)
    | x == '-' = parserMono (x:takeWhile (\x -> (x /= '+') && (x /= '-')) xs) : roughParserPoly (dropMono  xs)
    | x == '+' = parserMono (takeWhile (\x -> (x /= '+') && (x /= '-')) xs) : roughParserPoly (dropMono  xs)
    | otherwise = parserMono (x:takeWhile (\x -> (x /= '+') && (x /= '-')) xs) : roughParserPoly (dropMono  (x:xs)) 

{-roughParserPoly :: String -> Polynomial
roughParserPoly [] = []
roughParserPoly (x:xs)
    | x == '-' = parserMono (x:takeWhile (\x -> (x /= '+')) xs) : roughParserPoly (dropWhile (\x -> (x /= '+')) xs)
    | x == '+' = parserMono (takeWhile (\x -> (x /= '+')) xs) : roughParserPoly (dropWhile (\x -> (x /= '+')) xs)
    | otherwise = parserMono (x:takeWhile (\x -> (x /= '+')) xs) : roughParserPoly (dropWhile (\x -> (x /= '+')) (x:xs))
-}
parserPoly :: String -> Polynomial
parserPoly [] = []
parserPoly a =  roughParserPoly (filterSpaces a)
