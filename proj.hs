{- type Polynomial = [(Integer,[Char],[Integer])] -}
type Polynomial = [(Int,[(Char, Integer)])]

{- removes all variables with a 0 exponent from a single monomial -}
removeNullExp :: [(Char, Integer)] -> [(Char,Integer)]
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

{- normalPolynomial :: Polynomial -> Polynomial
normalPolynomial [] = []
normalPolynomial (x:xs) =  -}

{-addPolynomial :: Polynomial -> Polynomial -> Polynomial
addPolynomial [] ys = ys
addPolynomial xs [] = xs
addPolynomial xs ys = normalPolynomial xs:ys -}