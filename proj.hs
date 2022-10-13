{- type Polynomial = [(Integer,[Char],[Integer])] -}
type Polynomial = [(Integer,[(Char, Integer)])]

removeNullMonomials :: Polynomial -> Polynomial
removeNullMonomials p = filter (\(n, [(var, exp)]) -> n /= 0) p

{- removeNullExpVars :: Polynomial -> Polynomial
removeNullExpVars p = filter (\(n, [(var, exp)]) -> exp /= 0) p -}

{- normalPolynomial :: Polynomial -> Polynomial
normalPolynomial [] = []
normalPolynomial (x:xs) =  -}

addPolynomial :: Polynomial -> Polynomial -> Polynomial
addPolynomial [] ys = ys
addPolynomial xs [] = xs
addPolynomial xs ys = normalPolynomial xs:ys