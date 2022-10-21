# PFL_TP1_G08_01

## Representação interna de polinómios
Neste trabalho, decidimos utilizar uma lista de tuplos para representar os polinómios. Cada tuplo representa um monómio e é constituído por 2 elementos: o primeiro corresponde ao coeficiente (negativo ou positivo) do monómio e o segundo, à parte literal do mesmo. É ainda de referir que, o 2º elemento de cada tuplo é novamente uma lista de tuplos. Estes tuplos correspondem a cada variável que integre o monómio, associada ao seu expoente.

<ul>
	<li>Polynomial = [Monomial]</li>
	<li>Monomial = (Int, Vars)</li>
	<li>Vars = [(Char, Int)]</li>
</ul>

## Funcionalidades

### Normalização

### Adição

### Multiplicação

### Derivação

## Exemplos para testes