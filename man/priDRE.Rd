\name{priDRE}
\alias{priDRE}
\title{Return financial results of the applied treatment.}
          
}
\usage{
x= priDRE(Base,inicio.experimento,final.experimento,inicio.tratamento,grupo.tratamento,grupo.controle, SKUGroup, d_lojas,graphic.path,graphic.name)
}

\arguments{
  \item{Base}{XXX}
  
  \item{inicio.experimento}{XXX}
  
  \item{final.experimento}{XXX}
  
  \item{inicio.tratamento}{XXX}
  
  \item{grupo.tratamento}{XXX}
  
  \item{grupo.controle}{XXX}
  
  \item{SKUGroup}{XXX}
  
  \item{d_lojas}{XXX}
  
  \item{graphic.path}{XXX}
  
  \item{graphic.name}{XXX}
  
}
  
  \values{This function returns a Excel file containing financial results of the treatment:

  \item{cmv}{Returns unit cost (cmv) on pre-treatment period}
  \item{imposto}{Returns unit taxes on pre-treatment period}
  \item{qmed}{Average daily quantities on pre-treatment period}
  \item{pmed}{Average daily quantities on pre-treatment period}
}
             
\examples{
# carregar a Base
  load(file="/RProjetos/Pricing/Dados Atualizados/Painel/Base.RData")

# Datas
  inicio.experimento <- '2016-09-09' # Pré tratamento
  inicio.tratamento <- '2016-09-16'
  final.experimento <- '2016-09-22'
  
# Parâmetros do experimento
  SKUGroup <- '11'
  preco <- 1.49
  delta_p <- 0.3
    
# Caso não queira remover nenhuma loja pelo nível de preço pré tratamento, basta colocar critério de corte = 0.
  criterio_corte <- 1.4
  
# Grupos tratamento e controle
  load("/RProjetos/Pricing/Dados Atualizados/Grupos de lojas da aleatorizacao/lojas.aleatorizacao.RData")
  d_lojas = lojas.aleatorizacao

  grupo.tratamento <- c('A1','A2')
  grupo.controle <- c('B1','B2')
  
  base_aux <- priDataPainel(Base,d_lojas,inicio.experimento,inicio.tratamento,final.experimento,
                          SKUGroup,preco,delta_p,criterio_corte,grupo.controle,grupo.tratamento)

  priOptPar <- priRCTOptParameters(data.painel, SKUGroup)

}

\author{
  Coded by Henrique Helfer Hoeltgebaum and Yuri Fonseca, last updated on 27-10-2016.
  }
