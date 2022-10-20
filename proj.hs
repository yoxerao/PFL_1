{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
import Data.List
import Data.Function
import Data.Ord
{- type Polynomial = [(Integer,[Char],[Integer])] -}
type Polynomial = [(Int,[(Char, Int)])]
type Monomial = (Int,[(Char, Int)])



{- removes all variables with a 0 exponent from a single monomial -}
removeNullExp :: [(Char, Int)] -> [(Char,Int)]
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
joinSameVar :: (Char, Int) -> [(Char, Int)] -> [(Char, Int)]
joinSameVar v [] = [v]
joinSameVar v (x:xs)
    | fst v == fst x = joinSameVar (fst v, snd v + snd x) xs
    | otherwise = x : joinSameVar v xs

{- iterates the monomial vars list and joins all the same exponents -}
iterJoinSameVar :: [(Char, Int)] -> [(Char, Int)]
iterJoinSameVar [] = []
iterJoinSameVar (x:xs) = let varList = joinSameVar x xs
                            in iterJoinSameVar (init varList) ++ [last varList]

applyJoinSameVarToPoly :: Polynomial -> Polynomial
applyJoinSameVarToPoly [] = []
applyJoinSameVarToPoly (x:xs) = (fst x, iterJoinSameVar (snd x)) : applyJoinSameVarToPoly xs
{- applyJoinSameVarToPoly (x:xs) = let monList = iterJoinSameVar (snd x)
                                    in applyJoinSameVarToPoly (fst x, init monList) ++ [last monList] -}

sortPoly :: Polynomial -> Polynomial
sortPoly [] = []
sortPoly xs = sortOn (snd.last.snd) xs  {- !! NAO USAR AINDA !! -}

varToString :: (Char, Int) -> String
varToString (var, exp) = var : "^" ++ show exp

varsToString :: [(Char, Int)] -> String
varsToString [x] = varToString x
varsToString (x:xs) = varToString x ++ varsToString xs

monomialToString :: (Int, [(Char, Int)]) -> String
monomialToString m = show (fst m) ++ varsToString (snd m)

polynomialToString :: Polynomial -> String
polynomialToString [] = ""
polynomialToString [x] = monomialToString x
polynomialToString (x:xs)
    | fst (head xs) > 0 = monomialToString x ++ "+" ++ polynomialToString xs
    | fst (head xs) < 0 = monomialToString x ++ polynomialToString xs

normalizePolynomial :: Polynomial -> String
--type Polynomial = [(Int,[(Char, Int)])]
normalizePolynomial a
       | null a = []
       | otherwise = polynomialToString (recursiveHelper (applyJoinSameVarToPoly (stripPoly a)))
       where
       recursiveHelper xs
            | null xs = []
            | otherwise = addSameExp (head xs) (recursiveHelper (tail xs))

{- testing example
[ (0, [('x', 1)]), (1, [('x', 0)]) , (2, [('y', 2)]), (3, [('y', 2)]), (0, [('x', 1), ('y', 2)]) ] -}
{- normalPolynomial :: Polynomial -> Polynomial
normalPolynomial [] = [] -}
addPolynomials :: Polynomial -> Polynomial -> String
addPolynomials [] b = polynomialToString b
addPolynomials a [] = polynomialToString a
addPolynomials a b = normalizePolynomial (a ++ b)

distributeMono :: Monomial -> Polynomial -> Polynomial
distributeMono _ [] = []
distributeMono x (y:ys) = ((fst(x) * fst(y)), iterJoinSameVar ((snd x) ++ (snd y))) : distributeMono x ys

multPoly :: Polynomial -> Polynomial -> String
multPoly [] [] = []
multPoly a [] = []
multPoly [] b = []
multPoly (x:xs) y = polynomialToString(distributeMono x y) ++ multPoly xs y

{-  -}
subExponents :: [(Char,Int)] -> Char -> [(Char,Int)]
subExponents [] _ = []
subExponents (x:xs) b
    | fst x == b = (b, (snd x) -1) : subExponents xs b
    | otherwise = x: subExponents xs b

derivMono :: Monomial -> Char -> Monomial
derivMono (x,y) b = (x * (snd(head (filter(\(m,n)-> m == b) y))), subExponents y b)

checkDerivMono :: Monomial -> Char -> Bool
checkDerivMono (x,y) b
    |not (any (\(m,n) -> m == b) y) = False
    |otherwise = True


roughDerivPoly :: Polynomial -> Char -> Polynomial
roughDerivPoly [] _ = []
roughDerivPoly (x:xs) b = (if (checkDerivMono x b) then (derivMono x b : roughDerivPoly xs b) else (roughDerivPoly xs b))

derivPoly :: Polynomial -> Char -> String
derivPoly [] _ = []
derivPoly a b = normalizePolynomial(roughDerivPoly a b)


{- multiplyPolynomials :: Polynomial -> Polynomial -> Polynomial
multiplyPolynomials [] _ = []
multiplyPolynomials _ [] = []
multiplyPolynomials a b =  -}