# PFL_TP1_G08_01

## Representação interna de polinómios
Neste trabalho, decidimos utilizar uma lista de tuplos para representar os polinómios. Cada tuplo representa um monómio e é constituído por 2 elementos: o primeiro corresponde ao coeficiente (negativo ou positivo) do monómio e o segundo, à parte literal do mesmo. É ainda de referir que, o 2º elemento de cada tuplo é novamente uma lista de tuplos. Estes tuplos correspondem a cada variável que integre o monómio, associada ao seu expoente.

- Polynomial = [Monomial]
- Monomial = (Int, Vars)
- Vars = [(Char, Int)]

### Justificação

## Funcionalidades

### Normalização
Uma vez que esta funcionalidade pode implicar diversos pormenores e modificações (dependendo do polinómio introduzido), decidimos criar uma função para cada uma delas e chamá-las na função principal que aplica todas as alterações, `normalizePolynomial :: String -> String`.

1. A função recebe um polinómio ainda no formato de string, tal como o utilizador o inserir e, de seguida, transforma a string no tipo `Polynomial` que criámos
2. Se a variável do tipo `Polynomial` estiver vazia,é retornada a mesma variável
3. Se não estiver vazia, em primeiro lugar chama-se a função que soma os coeficientes associados a partes literais iguais (ex: `2*x^2 + 3*x^2 = 5*x^2`)
4. De seguida, é chamada uma função, que recursivamente, para cada monómio, verifica se alguma das variáveis pode ser junta com outra, somando os seus expoentes (ex: `2*x^2x^3 = 2*x^5`)
5. Por fim, o polinómio é ordenado e convertido de novo numa String

### Adição
Para esta funcionalidade aproveitámos a função que criámos para a funcionalidade anterior, apenas concatenando os 2 polinómios a somar previamente a chamar a função de normalização, uma vez que ao fazê-lo, obtem-se um polinómio que pode ser normalizado.

1. A função recebe um polinómio ainda no formato de string, tal como o utilizador o inserir
2.
3.
4.
5.

### Multiplicação

### Derivação

## Exemplos para testes
