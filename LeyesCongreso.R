
#---- Scraping al congreso #----
library(tidyverse)
library(xml2)
library(rvest)
library(RSelenium)
library(wdman)
library(robotstxt)
library(lubridate)

#---- Parte I #----

UrlLeyes <- "https://leyes.congreso.gob.pe/LeyNume_1p.aspx?xEstado=2&xTipoNorma=0&xTipoBusqueda=2&xFechaI=01%2f01%2f2000&xFechaF=01%2f12%2f2020&xTexto=&xOrden=0&xNormaI=&xNormaF="

options(encoding = "utf-8") # Le asignamos el encoding

#Abrimos una sesion en la web
# Ejecutamos el servidor phantomjs -creamos un navegador fantasma

server<-phantomjs(port=5012L)
#Abrimos el navegador
Browser <- remoteDriver(browserName = "phantomjs", port=5012L)
Browser$open()

#Navegamos
Browser$navigate(UrlLeyes) # 
Browser$screenshot(display=TRUE)

#Decirle que actúe sobre la página actual para rasparlo
Pagina_actual<-Browser$getPageSource()

#Hacemos un for de 1 a 176
for (j in 1:176) {
  print(j)
  Pagina_actual<-Browser$getPageSource() # Actuar sobre la página
  Pagina<-read_html(Pagina_actual[[1]])
  Hojas<-Pagina%>%
    html_node(css = "#ctl00_ContentPlaceHolder1_GwDetalle")%>%
    html_table(header = T)
  #Guardarlo en formato R para luego unirlo con rbind
  saveRDS(Hojas,file = paste0("Leyes/Hojas_",j,".rds"))
  
  # Hacer clic en sigiuente hasta 176
    SiguienteHoja<-Browser$findElement(using = "css",
                                     value = "#ctl00_ContentPlaceHolder1_GwDetalle_ctl23_ImgBtnSiguiente") #Es Id
    SiguienteHoja$clickElement()
     #Que descance un rato
  Sys.sleep(4)  
}

Hoja1 <- readRDS("Leyes/Hojas_1.rds")
#Juntar toda la data
Archivos <- list.files("Leyes/",pattern = "rds")
TodasLeyes <- read_rds("Leyes/Hojas_1.rds")#  Archivos[1]

for (i in 2:176) {
  
  TodasLeyes <- rbind(TodasLeyes,readRDS(paste0("Leyes/",Archivos[i])))
}
#Eliminar los patrones:"[1 de 176]"
Fucionar <- paste0("[1"," ","de"," ","176]")

for (h in 2:176) {
  Fucionar0 <- paste0("[",Concatenar[h]," ","de"," ","176]") 
  Fucionar <- rbind(Fucionar,Fucionar0)
}

Fucionar <- as.list(Fucionar)
Fucionar <- unlist(Fucionar)

#Filtramos
TodasLeyes <- TodasLeyes%>%
  filter(!Norma%in%c(Fucionar))

#Seguir filtrando

TodasLeyes <- TodasLeyes%>%
  filter(Norma!="RESOLUCION LEGISLATIVA")

sapply(TodasLeyes, class)

TodasLeyes$Publicación <- as.Date(TodasLeyes$Publicación,format="%d/%m/%Y")
#Ordenamos según fecha
TodasLeyes <- TodasLeyes%>%
  arrange(Publicación)
#Guardar la data Limpia
saveRDS(TodasLeyes,"Leyes/TodasLeyes.rds")

#---- Acceder al expediente #----
TodasLeyes <- readRDS("Leyes/TodasLeyes.rds")
NumeroLey <- TodasLeyes$Número
#"https://leyes.congreso.gob.pe/DetLeyNume_1p.aspx?xNorma=6&xNumero=27250&xTipoNorma=0"
UrlExpe <- "https://leyes.congreso.gob.pe/DetLeyNume_1p.aspx?xNorma=6&xNumero="
UrlExpe <- paste0(UrlExpe,NumeroLey[1],"&xTipoNorma=0") #1829

options(encoding = "utf-8") # Le asignamos el encoding
#Abrimos una sesion en la web
# Ejecutamos el servidor phantomjs -creamos un navegador fantasma

server<-phantomjs(port=5012L)
#Abrimos el navegador
Browser <- remoteDriver(browserName = "phantomjs", port=5012L)
Browser$open()
#Navegamos
Browser$navigate(UrlExpe) # 
Browser$screenshot(display=TRUE)

#Hacer clic en expediente
Pagina_actual<-Browser$getPageSource()
#De la siguiente forma no hace efecto
Expediente <- Browser$findElement(using = "css",
                                  value = "#DvDetalle_LinkExpediente")
Expediente$clickElement()
Browser$screenshot(display=TRUE)
#Aqui si funciona
ExpedienteUrl <- read_html(Pagina_actual[[1]])%>%
  html_node(css = "#DvDetalle_LinkExpediente")%>%
  html_attr("href")

Browser$navigate(ExpedienteUrl) # 
Browser$screenshot(display=TRUE)

#Obtener la Url de la tabla que contiene el proyecto de ley
Nodo1 <- "body > form > table > tbody > tr > td > table > tbody > tr > td > div > table:nth-child("
Nodo2 <- ") > tbody > tr:nth-child(2) > td:nth-child(3) > a"

Pagina_actual<-Browser$getPageSource()
PdfUrl <- read_html(Pagina_actual[[1]])%>%
  html_node("body > form > table > tbody > tr > td > table > tbody > tr > td > div > table:nth-child(7) > tbody > tr:nth-child(2) > td:nth-child(3) > a")%>%
  html_attr("href")

/html/body/form/table/tbody/tr/td/table/tbody/tr/td/div/table[2]/tbody/tr[2]/td[3]/a
/html/body/form/table/tbody/tr/td/table/tbody/tr/td/div/table[2]/tbody/tr[2]/td[3]/a
/html/body/form/table/tbody/tr/td/table/tbody/tr/td/div/table[2]/tbody/tr[2]/td[3]/a
/html/body/form/table/tbody/tr/td/table/tbody/tr/td/div/table[2]/tbody/tr[2]/td[3]/a
/html/body/form/table/tbody/tr/td/table/tbody/tr/td/div/table[2]/tbody/tr[2]/td[3]/a
/html/body/form/table/tbody/tr/td/table/tbody/tr/td/div/table[2]/tbody/tr[2]/td[3]/a
/html/body/form/table/tbody/tr/td/table/tbody/tr/td/div/table[2]/tbody/tr[2]/td[3]/a
/html/body/form/table/tbody/tr/td/table/tbody/tr/td/div/table[2]/tbody/tr[2]/td[3]/a
/html/body/form/table/tbody/tr/td/table/tbody/tr/td/div/table[2]/tbody/tr[2]/td[3]/a
/html/body/form/table/tbody/tr/td/table/tbody/tr/td/div/table[2]/tbody/tr[2]/td[3]/a


body > form > table > tbody > tr > td > table > tbody > tr > td > div > table:nth-child(7) > tbody > tr:nth-child(2) > td:nth-child(3) > a
body > form > table > tbody > tr > td > table > tbody > tr > td > div > table:nth-child(6) > tbody > tr:nth-child(2) > td:nth-child(3) > a
body > form > table > tbody > tr > td > table > tbody > tr > td > div > table:nth-child(7) > tbody > tr:nth-child(2) > td:nth-child(3) > a
body > form > table > tbody > tr > td > table > tbody > tr > td > div > table:nth-child(7) > tbody > tr:nth-child(2) > td:nth-child(3) > a
body > form > table > tbody > tr > td > table > tbody > tr > td > div > table:nth-child(6) > tbody > tr:nth-child(2) > td:nth-child(3) > a
body > form > table > tbody > tr > td > table > tbody > tr > td > div > table:nth-child(6) > tbody > tr:nth-child(2) > td:nth-child(3) > a
body > form > table > tbody > tr > td > table > tbody > tr > td > div > table:nth-child(6) > tbody > tr:nth-child(2) > td:nth-child(3) > a #hoja 10
body > form > table > tbody > tr > td > table > tbody > tr > td > div > table:nth-child(6) > tbody > tr:nth-child(3) > td:nth-child(3) > a

#Todos los link de pdfs
PdfUrl2 <- read_html(Pagina_actual[[1]])%>%
  html_nodes("a")%>%
  html_attr("href")

#Leer el pdf
library(pdftools)
library(tesseract)

ReadPDF<-pdf_ocr_text(PdfUrl,
                            pages = c(1:2),language = "spa",dpi = 600) #




#---- Prueba #----

#Hacer clic en Anterior: Prueba
AnteriorHoja <- Browser$findElement(using = "css",
                                    value = "#ctl00_ContentPlaceHolder1_GwDetalle_ctl23_ImgBtnAnterior")
AnteriorHoja$clickElement()
Browser$screenshot(display=TRUE)

#escrapeamos la información de la 1ra hoja
Pagina<-read_html(Pagina_actual[[1]]) # en el elemento 1 de la lista está la url de la página actual
Hoja1<-Pagina%>%
  html_node(css = "#ctl00_ContentPlaceHolder1_GwDetalle")%>%
  html_table(header = T)

Hoja1 <- Hoja1%>%
  filter(Norma!="[1 de 176]")

# Hacer clic en sigiuente hasta 176
SiguienteHoja<-Browser$findElement(using = "css",
                                   value = "#ctl00_ContentPlaceHolder1_GwDetalle_ctl23_ImgBtnSiguiente") #Es Id

SiguienteHoja$clickElement()
Browser$screenshot(display=TRUE) # si salío

#ctl00_ContentPlaceHolder1_GwDetalle
Pagina_actual<-Browser$getPageSource()
Pagina<-read_html(Pagina_actual[[1]])
Hoja2<-Pagina%>%
  html_node(css = "#ctl00_ContentPlaceHolder1_GwDetalle")%>%
  html_table(header = T)
Hoja2 <- Hoja2[c(1:20),]

#---- cerrar la sesión #----
Browser$close()
server$stop()

