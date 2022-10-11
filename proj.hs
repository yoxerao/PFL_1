type Polynomial = [(Integer,[Char],[Integer])] 

addPolynomial :: Polynomial -> Polynomial -> Polynomial
addPolynomial [] ys = ys
addPolynomial xs [] = xs
addPolynomial xs ys = normalPolynomial xs:ys

