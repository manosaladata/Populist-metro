library(xml2)  #Para leer html.
library(rvest)
library(RSelenium)  #Pra trabajar con páginas dinámicas
library(wdman)    #Navegador fantasma, permite usar rsDriver
library(robotstxt)
library(tidyverse)


#CREAREMOS LA BASE DE DATOS DE LEYES INCONSTITUCIONALES
base_leyes<- data.frame(matrix(ncol = 1, nrow = 0))

base_leyes

for (i in 1:15){
  UrlMadre<-paste0("http://181.177.234.7/buscarRes/public/resolucionjur?filtro=A&search=Inconstitucional%2C+Ley&demandante=&demandado=ley&numexpediente=&anoingreso=&idtipoproceso=3&anopublica=&pg=",i)
  html<-read_html(UrlMadre)
  pag_text<-html%>%
    html_nodes(xpath='//*[@class="date"]')%>% 
    html_text()
  pag_text
  for (i in 1:20) {
    if (i %% 2== 0){    #Condición par (demandado: Leyes)
      demandado<-pag_text[i]
      base_leyes[ nrow(base_leyes) + 1,] <- demandado     #appendeamos
      
    }}
    
}
names(base_leyes)<-"LEYES DEMANDADAS"

#####FRILTRO INSUFICIENTE, TENEMOS QUE LEER LAS SENTENCIAS Y VER CUÁLES FUERON FUNDADAS

library(pdftools)
pdftools::pdf_text(pdf = "http://arxiv.org/pdf/1403.2805.pdf")
library(tesseract)
eng <- tesseract("eng")
text <- tesseract::ocr("https://tc.gob.pe/jurisprudencia/2011/00035-2010-AI.pdf", engine = eng)
cat(text)
text

view(base_leyes)
#####FALTA ANALIZAR SI FUERON FUNDADAS O NO
  
##########################################
#############SEGUNDA ESTRATEGIA: BUSCAR POR CAUSA#############
###################################
UrlMadre2<-paste0("http://181.177.234.7/buscarRes/public/resolucionjur?filtro=A&search=Inconstitucional%2C+Ley&demandante=&demandado=ley&numexpediente=&anoingreso=&idtipoproceso=3&anopublica=&pg=",i)
html2<-read_html(UrlMadre2)
pag_text2<-html2%>%
  html_nodes(xpath='//*[@class="date"]')%>% 
  html_text()
pag_text2
