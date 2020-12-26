
#---- Scraping al congreso #----
library(tidyverse)
library(xml2)
library(rvest)
library(RSelenium)
library(wdman)
library(robotstxt)
library(lubridate)

setwd("D:/Git Hub-BEST/Populist-metro/Leyes")

UrlLeyes <- "https://leyes.congreso.gob.pe/LeyNume_1p.aspx?xEstado=2&xTipoNorma=0&xTipoBusqueda=2&xFechaI=01%2f01%2f2000&xFechaF=01%2f12%2f2020&xTexto=&xOrden=0&xNormaI=&xNormaF="

options(encoding = "utf-8") # Le asignamos el encoding



server<-phantomjs(port=5012L)

Browser <- remoteDriver(browserName = "phantomjs", port=5012L)
Browser$open()

#Navegamos
Browser$navigate(UrlLeyes) #
Browser$screenshot(display=TRUE)

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
  #Sys.sleep(4)
}

# Hoja1 <- readRDS("Leyes/Hojas_1.rds")
# #Juntar toda la data
Archivos <- list.files("Leyes/",pattern = "rds")
TodasLeyes <- read_rds("Leyes/Hojas_1.rds")#  Archivos[1]

for (i in 2:176) {
  
  TodasLeyes <- rbind(TodasLeyes,readRDS(paste0("Leyes/",Archivos[i])))
}
#Eliminar los patrones:"[1 de 176]"
Fucionar <- paste0("[1"," ","de"," ","176]")
Fucionar <- as.list(Fucionar)
Fucionar <- unlist(Fucionar)

#Filtramos
TodasLeyes <- TodasLeyes%>%
  filter(!Norma%in%c(Fucionar))

#Seguir filtrando

TodasLeyes <- TodasLeyes%>%
  filter(Norma!="RESOLUCION LEGISLATIVA")

TodasLeyes$Publicación <- as.Date(TodasLeyes$Publicación,format="%d/%m/%Y")
#Ordenamos según fecha
TodasLeyes <- TodasLeyes%>%
  arrange(Publicación)
#Guardar la data Limpia
saveRDS(TodasLeyes,"Leyes/TodasLeyes.rds")

