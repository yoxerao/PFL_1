type Polynomial = [(String,Int,Int)] 

addPolynomial :: Polynomial -> Polynomial -> Polynomial
addPolynomial [] ys = ys
addPolynomial xs [] = xs
addPolynomial xs ys = normalPolynomial xs:ys

