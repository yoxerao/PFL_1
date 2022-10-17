import Data.List
import Data.Function
import Data.Ord
{- type Polynomial = [(Integer,[Char],[Integer])] -}
type Polynomial = [(Int,[(Char, Int)])]

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
addMonomials :: (Int,[(Char, Int)]) -> (Int,[(Char, Int)]) -> (Int,[(Char, Int)])
addMonomials m1 m2 = (fst m1 + fst m2, snd m1)

{- checks if the literal parts are equal and adds the monomials -}
addSameExp:: (Int,[(Char, Int)]) -> Polynomial -> Polynomial
addSameExp m1 [] = [m1]
addSameExp m1 (x:xs)
    | snd m1 == snd x = addMonomials m1 x : xs
    | otherwise = x: addSameExp m1 xs

sortPoly:: Polynomial -> Polynomial
sortPoly [] = []
sortPoly xs = sortOn (snd.last.snd) xs  {- !! SE A LISTA DE VARS ESTIVER VAZIA EM ALGUM MONOMIO DÁ ERRO !! -}

normalizePolynomial :: Polynomial -> Polynomial
--type Polynomial = [(Int,[(Char, Intw)])]
normalizePolynomial a
       | null a = []
       | otherwise = reverse (sortPoly (recursiveHelper (stripPoly a)))
       where
       recursiveHelper xs
            | null xs = []
            | otherwise = addSameExp (head xs) (recursiveHelper (tail xs))
{- testing example
[ (0, [('x', 1)]), (1, [('x', 0)]) , (2, [('y', 2)]), (3, [('y', 2)]), (0, [('x', 1), ('y', 2)]) ] -}
{- normalPolynomial :: Polynomial -> Polynomial
normalPolynomial [] = [] -}
addPolynomials :: Polynomial -> Polynomial -> Polynomial
addPolynomials [] b = b
addPolynomials a [] = a
addPolynomials a b = normalizePolynomial (a ++ b)
