# PFL_TP1_G08_01

## Representação interna de polinómios
Neste trabalho, decidimos utilizar uma lista de tuplos para representar os polinómios. Cada tuplo representa um monómio e é constituído por 2 elementos: o primeiro corresponde ao coeficiente (negativo ou positivo) do monómio e o segundo, à parte literal do mesmo. É ainda de referir que, o 2º elemento de cada tuplo é novamente uma lista de tuplos. Estes tuplos correspondem a cada variável que integre o monómio, associada ao seu expoente.

<ul>
	<li>Polynomial = [Monomial]</li>
	<li>Monomial = (Int, Vars)</li>
	<li>Vars = [(Char, Int)]</li>
</ul>

### Justificação

## Funcionalidades

### Normalização
Uma vez que esta funcionalidade pode implicar diversos pormenores e modificações (dependendo do polinómio introduzido), decidimos criar uma função para cada uma delas e chamá-las na função principal que aplica todas as alterações, `normalizePolynomial :: String -> String`.

<ol>
	<li>A função recebe um polinómio ainda no formato de string, tal como o utilizador o inserir e, de seguida, transforma a string no tipo `Polynomial` que criámos</li>
	<li>Se a variável do tipo `Polynomial` estiver vazia,é retornada a mesma variável</li>
	<li></li>
	<li></li>
	<li></li>
	<li></li>
</ol>

### Adição
Para esta funcionalidade aproveitámos a função que criámos para a funcionalidade anterior, apenas concatenando os 2 polinómios a somar previamente a chamar a função de normalização, uma vez que ao fazê-lo, obtem-se um polinómio que pode ser normalizado.

<ol>
	<li>A função recebe um polinómio ainda no formato de string, tal como o utilizador o inserir</li>
	<li></li>
	<li></li>
	<li></li>
	<li></li>
	<li></li>
</ol>

### Multiplicação

### Derivação

## Exemplos para testes
