\name{wide.to.panel}
\alias{wide.to.panel}
\title{Transforma varias matrizes ou cubos do formato wide para um painel.}
\usage{
wide.to.panel(varlist,type=c("cube","matrix"),sku.column=TRUE)
}


\arguments{
  \item{varlist}{Lista de matrizes ou cubos, onde cada matriz/cubo representa uma variável.}

  \item{type}{matrix ou cube.}
  
  \item{sku.column} Considerar apenas se type="cube" e se o imput for um cubo da função data.download com type = "skus". Se TRUE então os skus não aparecerão em uma coluna de índice. Cada variável terá uma coluna para cada SKU. Os índices serão apenas para data e loja. 
}

\value{
Esta função retorna um painel de dados da seguinte forma:
  - Cada dimensão da matriz/cubo se tornará uma coluna indexadora do painel.
  - Cada matriz/cubo da lista varlist se tornará uma variável do painel.
}

\examples{

#####exemplo com dados gerados#######
set.seed(123)
matriz1=matrix(rnorm(10),5,2)
matriz2=matrix(runif(10),5,2)
colnames(matriz1)=colnames(matriz2)=c("x","y")
rownames(matriz1)=rownames(matriz2)=c("a","b","c","d","e")

matriz1
matriz2

varlist=list("v1"=matriz1,"v2"=matriz2)

teste=wide.to.panel(varlist,type="matrix")
teste
}

