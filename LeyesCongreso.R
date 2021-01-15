
#---- Scraping al congreso #----
library(tidyverse)
library(xml2)
library(rvest)
library(RSelenium)
library(wdman)
library(robotstxt)
library(lubridate)

#---- Parte I: Raspar la pagina #----

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
#Pagina 1
Pagina<-read_html(Pagina_actual[[1]])
HojasTabla<-Pagina%>%
  html_node(css = "#ctl00_ContentPlaceHolder1_GwDetalle")%>%
  html_table(header = T)
#Agregamos una variable
HojasTabla <- HojasTabla%>%
  mutate(Hoja=1)

#Hacemos un for de 2 a 177
for (j in 2:177) {
  print(j)
  # Hacer clic en sigiuente hasta 177
  SiguienteHoja<-Browser$findElement(using = "css",
                                     value = "#ctl00_ContentPlaceHolder1_GwDetalle_ctl23_ImgBtnSiguiente") #Es Id
  SiguienteHoja$clickElement()
  #Actuar sobre la pagina
  Pagina_actual<-Browser$getPageSource() # Actuar sobre la página
  Pagina<-read_html(Pagina_actual[[1]])
  Hojas<-Pagina%>%
    html_node(css = "#ctl00_ContentPlaceHolder1_GwDetalle")%>%
    html_table(header = T)
  
<<<<<<< HEAD
  Hojas <- Hojas%>%
    mutate(Hoja=j)
  #Juntamos la data con rbind
  HojasTabla <- rbind(HojasTabla,Hojas)
   #Que descance un rato
=======
  # Hacer clic en sigiuente hasta 176
  SiguienteHoja<-Browser$findElement(using = "css",
                                     value = "#ctl00_ContentPlaceHolder1_GwDetalle_ctl23_ImgBtnSiguiente") #Es Id
  SiguienteHoja$clickElement()
  #Que descance un rato
>>>>>>> 649dd686e4eb97f8e7a0fc17c147a225b664198a
  Sys.sleep(4)  
}

#Eliminar los patrones:"[1 de 177]", etc.
Fucionar <- paste0("[1"," ","de"," ","177]")

for (h in 2:177) {
  Fucionar0 <- paste0("[",h," ","de"," ","177]") 
  Fucionar <- rbind(Fucionar,Fucionar0)
}

Fucionar <- as.list(Fucionar)
Fucionar <- unlist(Fucionar)

#Filtramos
HojasTabla <- HojasTabla%>%
  filter(!Norma%in%c(Fucionar))

sapply(HojasTabla, class)
HojasTabla$Publicación <- as.Date(HojasTabla$Publicación,format="%d/%m/%Y")

#guardado
saveRDS(HojasTabla,file = "Leyes/TodasLeyesBruta.rds")

#---- Actualizar leyes #----
#Vamos actualizar, pero agregando lo ultimo. pagina 177
#Hacer clic en el último
HojaUltima <- Browser$findElement(using = "css",
                                  value = "#ctl00_ContentPlaceHolder1_GwDetalle_ctl23_ImgBtnUltimo") #Es Id
HojaUltima$clickElement()
Browser$screenshot(display=TRUE)
#Raspar de la hoja actual
Pagina_actual<-Browser$getPageSource() # Actuar sobre la página
Pagina<-read_html(Pagina_actual[[1]])
HojaLast<-Pagina%>%
  html_node(css = "#ctl00_ContentPlaceHolder1_GwDetalle")%>%
  html_table(header = T)

for (j in 1:1) {
  print(j)
  # Hacer clic en Anterior hasta 176
  AnteriorHoja<-Browser$findElement(using = "css",
                                    value = "#ctl00_ContentPlaceHolder1_GwDetalle_ctl07_ImgBtnAnterior") #Es Id
  AnteriorHoja$clickElement()
  #Raspar la hoja anterior y adjuntar con rbind
  Pagina_actual<-Browser$getPageSource() # Actuar sobre la página
  Pagina<-read_html(Pagina_actual[[1]])
  Hojas<-Pagina%>%
    html_node(css = "#ctl00_ContentPlaceHolder1_GwDetalle")%>%
    html_table(header = T)
  #Ajunta con rbind
  HojaLast <- rbind(HojaLast,Hojas) #Luego ordenar con arrange
  #Que descance un rato
  Sys.sleep(4)  
} #Va salir error al ultimo, es normal

#Ordenar según fecha o publicación
HojaLast <- HojaLast%>%
  arrange(Publicacion)
#Eliminar los patrones:"[176 de 177]"
Fucionar1 <- paste0("[176"," ","de"," ","177]")
Fucionar2 <- paste0("[177"," ","de"," ","177]")
Fucionar <- rbind(Fucionar1,Fucionar2)
Fucionar <- as.list(Fucionar)
Fucionar <- unlist(Fucionar)
#Filtramos
HojaLast <- HojaLast%>%
  filter(!Norma%in%c(Fucionar))

sapply(HojaLast, class)
#Filtrar segun numero de ley para agregarlo
HojaLast[,2] <- sapply(HojaLast[,2], function(x) as.numeric(x))
HojaLast <- HojaLast%>%
  filter(Número>31070)

HojaLast$Publicación <- as.Date(HojaLast$Publicación,format="%d/%m/%Y")
#Cargar lo antiguo para agregarlo
TodasLeyes <- readRDS("TodasLeyesBruta.rds")
TodasLeyes <- rbind(TodasLeyes,HojaLast) #Agregamos lo nuevo

#Guardar la data Bruta total
saveRDS(TodasLeyes,"Leyes/TodasLeyesBruta.rds")

#---- Acceder al expediente #----
#Esta forma es sólo hasta 2010
TodasLeyes <- readRDS("Leyes/TodasLeyesBruta.rds")
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

#----Parte II: Extraer Urls #----

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
#escrapeamos la información de la 1ra hoja
Pagina_actual<-Browser$getPageSource()
Pagina<-read_html(Pagina_actual[[1]]) # en el elemento 1 de la lista está la url de la página actual
Hoja1<-Pagina%>%
  html_node(css = "#ctl00_ContentPlaceHolder1_GwDetalle")%>%
  html_nodes("a")%>%
  html_attr("href")

DataUrlNorma <- as.data.frame(Hoja1)
DataUrlNorma <- DataUrlNorma%>%
  mutate(Hoja = 1)
names(DataUrlNorma)[1] <- "UrlNorma"
#Hacemos un for de 2 a 177
for (j in 2:177) {
  print(j)
  # Hacer clic en sigiuente hasta 177
  SiguienteHoja<-Browser$findElement(using = "css",
                                     value = "#ctl00_ContentPlaceHolder1_GwDetalle_ctl23_ImgBtnSiguiente") #Es Id
  SiguienteHoja$clickElement()
  #Bajar las URls
  Pagina_actual<-Browser$getPageSource() # Actuar sobre la página
  Pagina<-read_html(Pagina_actual[[1]]) # en el elemento 1 de la lista está la url de la página actual
  Hoja1<-Pagina%>%
    html_node(css = "#ctl00_ContentPlaceHolder1_GwDetalle")%>%
    html_nodes("a")%>%
    html_attr("href")
  
  Hoja1 <- as.data.frame(Hoja1)
  Hoja1 <- Hoja1%>%
    mutate(Hoja = j)
  names(Hoja1)[1] <- "UrlNorma"
  #Juntar con rbin
  DataUrlNorma <- rbind(DataUrlNorma,Hoja1)
  #Que descance un rato
  Sys.sleep(4)  
}

<<<<<<< HEAD
#Guardamos la data sucia
saveRDS(DataUrlNorma,"Leyes/DataUrlNormaBruta.rds")

#---- 2015 en adelante #----
#Unimos las bases brutas
UnionDataBruta <- cbind(readRDS("Leyes/TodasLeyesBruta.rds"),
                        readRDS("Leyes/DataUrlNormaBruta.rds"))

UnionDataBruta <- UnionDataBruta%>%
  select(c(1:7))
#Trabajaremos con las leyes de 2015 para adelante
#Filtramos para el año 2015 en adelante
UnionDataBruta <- UnionDataBruta%>%
  filter(Publicación>="2015-01-01")
unique(UnionDataBruta$Norma)
UnionDataBruta <- UnionDataBruta%>%
  filter(Norma!="RESOLUCION LEGISLATIVA")
UnionDataBruta <- UnionDataBruta%>%
  filter(!Número%in%c("30479","30569","30831","30833")) #No tienen Url

#Hacer limpieza
UnionDataBruta[1,7]
UnionDataBruta[,7] <- sapply(UnionDataBruta[,7], function(x) str_remove_all(x,pattern = "^javascript:OpenWindowLotus\\('"))
UnionDataBruta[,7] <- sapply(UnionDataBruta[,7], function(x) str_remove_all(x,pattern = "\\'\\);$"))

#Macheamos con las leyes que tiene acceso al PDF 2015 en adelante
#Extraer las Urls de los pdfs
UrlsExp <- UnionDataBruta[,7] #Para el for de 637
#Unir con:
PdfUrlTodoUno <- readRDS("Leyes/DataPdfBruta.rds") #Data genereda con un for de 637 para un solo pdf (importantísimo)
UnionDataBruta <- cbind(UnionDataBruta,readRDS("Leyes/DataPdfBruta.rds"))
#Eliminar los NAs
colSums(is.na(UnionDataBruta))
UnionDataNeta1 <- UnionDataBruta%>% #na.omit() No es elegante
  filter(UrlPdf!=is.na(UrlPdf))
#Eliminamos las dos utimas columnas, ya no aportan
UnionDataNeta1 <- UnionDataNeta1[,c(1:7)]
#Volver al for de arribar para extraer los proyectos de ley con:
ProyectosLeyUrl <- UnionDataNeta1[,7]
#Con estos link, procedemos a extraer las Urls de los pdfs

#Correr el browser
options(encoding = "utf-8") # Le asignamos el encoding
=======
ReadPDF<-pdf_ocr_text(PdfUrl,
                      pages = c(1:2),language = "spa",dpi = 600) #
>>>>>>> 649dd686e4eb97f8e7a0fc17c147a225b664198a

#Abrimos una sesion en la web
# Ejecutamos el servidor phantomjs -creamos un navegador fantasma

server<-phantomjs(port=5012L)
#Abrimos el navegador
Browser <- remoteDriver(browserName = "phantomjs", port=5012L)
Browser$open()

#Navegamos
Browser$navigate(ProyectosLeyUrl[1]) # UrlsExp[1]
Browser$screenshot(display=TRUE)
#Hacer clic en Expediente del proyecto
Expediente <- Browser$findElement(using = "xpath",
                                  value = "//*[@id='box_right_int']/div/ul/li[6]/a")
Expediente$clickElement()
Browser$screenshot(display=TRUE)

#Ubicamos el frame donde están el cuadro
frame0<-Browser$findElement(value='//*[@id="windowO2"]')
#Activamos el Frame
Browser$switchToFrame(frame0)

#Decirle que actúe sobre la página actual para rasparlo
Pagina_actual<-Browser$getPageSource()
Pagina<-read_html(Pagina_actual[[1]]) # en el elemento 1 de la lista está la url de la página actual
HojaPdf<-Pagina%>%
  html_node(xpath = '/html/body/form/table[2]/tbody/tr[2]/td[1]/table/tbody/tr/td/div/table[2]')%>% #Extraer las urls de la tabla
  html_nodes("a")%>% #html_nodes("a") antes para solo un pdf
  html_attr("href")

DataPdf <- as.data.frame(HojaPdf)
names(DataPdf)[1] <- "UrlPdf"
DataPdf <- DataPdf%>%
  mutate(NumeroLey=UnionDataBruta[1,2]) #Correr abajo lo de UnionDataBruta,fijo columna 2

#For para bajar las url de los pdfs
for (k in 2:314) {
  print(k)
  Browser$navigate(ProyectosLeyUrl[k]) # 
  #Hacer clic en Expediente del proyecto
  Expediente <- Browser$findElement(using = "xpath",
                                    value = "//*[@id='box_right_int']/div/ul/li[6]/a")
  Expediente$clickElement()
  #Ubicamos el frame donde están el cuadro
  frame0<-Browser$findElement(value='//*[@id="windowO2"]')
  #Activamos el Frame
  Browser$switchToFrame(frame0)
  #Decirle que actúe sobre la página actual para rasparlo
  Pagina_actual<-Browser$getPageSource()
  Pagina<-read_html(Pagina_actual[[1]]) # en el elemento 1 de la lista está la url de la página actual
  HojaPdf<-Pagina%>%
    html_node(xpath = '/html/body/form/table[2]/tbody/tr[2]/td[1]/table/tbody/tr/td/div/table[2]')%>%
    html_nodes("a")%>%
    html_attr("href")
  HojaPdf <- as.data.frame(HojaPdf)
  names(HojaPdf)[1] <- "UrlPdf"
  HojaPdf <- HojaPdf%>%
    mutate(NumeroLey=UnionDataBruta[k,2])
  #Juntar con rbind
  DataPdf <- rbind(DataPdf,HojaPdf)
  #Descanse un rato
  Sys.sleep(2) 
}
#Guardar
saveRDS(DataPdf,"Leyes/DataPdfBruta2015.rds") #DataPdfBruta 
#---- Leer Pdfs #----

#Nueva data para unir
DataUrlPdfs <- readRDS("Leyes/DataPdfBruta2015.rds")
table(DataUrlPdfs$NumeroLey)
#Group by
DataUrlPdfCuenta <- DataUrlPdfs%>%
  group_by(NumeroLey)%>%
  summarise(Cuenta=n())
names(DataUrlPdfCuenta)[1] <- "Número"
#unimos UnionDataNeta1 con DataUrlPdfCuenta
UnionDataNeta1 <- merge.data.frame(UnionDataNeta1,DataUrlPdfCuenta,
                                   by = c("Número"),all.x = T,
                                   sort = F)
names(UnionDataNeta1)[8] <- "NumeroDeProyectos"
#Filtrar
UnionDataNeta1 <- UnionDataNeta1%>%
  filter(NumeroDeProyectos<=5)

LeyesFiltrar <- UnionDataNeta1[,1]
# filtrar las leyes que nos interese
DataUrlPdfs <- DataUrlPdfs%>%
  filter(NumeroLey%in%c(LeyesFiltrar))

names(DataUrlPdfs)[c(1:2)] <- c("UrlPdfs","Número")
unique(DataUrlPdfs$Número)

#Merge final
DataNeta1 <- merge.data.frame(UnionDataNeta1,DataUrlPdfs,by = c("Número"),
                             all.y = T,sort = F)

#Guardar
saveRDS(DataNeta1,file = "Leyes/DataNeta1.rds")
#
#rm(DataUrlPdfCuenta,DataUrlPdfs,PdfUrlTodoUno,LeyesFiltrar,ProyectosLeyUrl)
#Obtener las urls de los pdfs que eran NAs

UnionDataNeta2 <- UnionDataBruta%>%
  filter(is.na(UrlPdf))

UnionDataNeta2 <- UnionDataNeta2[,c(1:8)]
#Guardamos 
saveRDS(UnionDataNeta2,file = "Leyes/UnionDataBruta2.rds")

#---- extraemos las leyes desde google #----

DataBruta2 <- readRDS(file = "Leyes/UnionDataBruta2.rds")

NumeroLey <- DataBruta2$Número

#Correr el browser de arriba para ingresar a google

UrlGoogle <- "https://www.google.com/"

#Navegamos
Browser$navigate(UrlGoogle) # 
Browser$screenshot(display=TRUE)

#Identificamos el imput y # Introducimos la ley que buscamos

#books <- remDr$findElement(using = "css", "[name = 'q']")
Buscador <- Browser$findElement(using='xpath','//input[@name="q"]')
Buscador$clickElement()
Buscador$sendKeysToElement(list(paste0("ley"," ",NumeroLey[1], " ","Expedientes"))) # Primer ley
Browser$screenshot(display = TRUE)

#Hacer clic para que busque en: Me siento con suerte :
SientoSuerte <- Browser$findElement(using='xpath','//input[@name="btnI"]')
SientoSuerte$clickElement()
Browser$screenshot(display = TRUE)

#Extraemos los pdfs
#Decirle que actúe sobre la página actual para rasparlo
Pagina_actual<-Browser$getPageSource()
Pagina<-read_html(Pagina_actual[[1]]) # en el elemento 1 de la lista está la url de la página actual
DataPdf<-Pagina%>%
  html_node(xpath = '/html/body/form/table[2]/tbody/tr[2]/td[1]/table/tbody/tr/td/div/table[2]')%>%
  html_nodes("a")%>%
  html_attr("href")

DataPdf <- as.data.frame(DataPdf)
names(DataPdf)[1] <- "UrlPdf"
DataPdf <- DataPdf%>%
  mutate(NumeroLey=DataBruta2[1,2])

#For
for (k in 2:323) {
  print(k)
  Browser$navigate(UrlGoogle) # 
  #Hacer clic en Expediente del proyecto
  Buscador <- Browser$findElement(using='xpath','//input[@name="q"]')
  Buscador$clickElement()
  Buscador$sendKeysToElement(list(paste0("ley"," ",NumeroLey[k], " ","Expedientes"))) # Busca por número de leyes
  #Hacer clic para que busque en: Me siento con suerte :
  SientoSuerte <- Browser$findElement(using='xpath','//input[@name="btnI"]')
  SientoSuerte$clickElement()
  #Decirle que actúe sobre la página actual para rasparlo
  Pagina_actual<-Browser$getPageSource()
  Pagina<-read_html(Pagina_actual[[1]]) # en el elemento 1 de la lista está la url de la página actual
  HojaPdf<-Pagina%>%
    html_node(xpath = '/html/body/form/table[2]/tbody/tr[2]/td[1]/table/tbody/tr/td/div/table[2]')%>%
    html_nodes("a")%>%
    html_attr("href")
  
  HojaPdf <- as.data.frame(HojaPdf)
  names(HojaPdf)[1] <- "UrlPdf"
  HojaPdf <- HojaPdf%>%
    mutate(NumeroLey=DataBruta2[k,2])
  
  #Juntar con rbind
  DataPdf <- rbind(DataPdf,HojaPdf)
  #Descanse un rato
  Sys.sleep(3) 
}

names(DataPdf)[c(1:2)] <- c("UrlPdfs","Número")
#Aplicamos group by para saber cuántos proyectos hay
DataPdf2<- DataPdf%>%
  group_by(Número)%>%
  summarise(Cuenta=n())
names(DataPdf2)[c(1:2)] <- c("Número","NumeroDeProyectos")
unique(DataPdf$Número)
#Juntarlo a DataBruta2
DataUnionBruta2 <- merge.data.frame(DataBruta2,DataPdf2,by = c("Número"),
                                    all.x = T,sort = F)
#filtramos por la data completa
DataUnionB2Full <- DataUnionBruta2%>%
  filter(NumeroDeProyectos!=is.na(NumeroDeProyectos))
#Hacer merge con la data full y DataPdf
DataUnionB2Full <- merge.data.frame(DataUnionB2Full,DataPdf,by = c("Número"),
                                    all.y = T,sort = F)
#Guardamos la data
saveRDS(DataUnionB2Full,file = "Leyes/DataNeta2.rds")

#Filtramos para los que faltan
DataUnionB2Falta <- DataUnionBruta2%>%
  filter(is.na(NumeroDeProyectos))
LeyFaltante <- DataUnionB2Falta$Número

#nuevamente raspamos
UrlGoogle <- "https://www.google.com/"

#Navegamos
Browser$navigate(UrlGoogle) # 
Browser$screenshot(display=TRUE)

#Identificamos el imput y # Introducimos la ley que buscamos

#books <- remDr$findElement(using = "css", "[name = 'q']")
Buscador <- Browser$findElement(using='xpath','//input[@name="q"]')
Buscador$clickElement()
Buscador$sendKeysToElement(list(paste0("ley"," ",LeyFaltante[1], " ","Expedientes"),key = "enter")) # Primer ley
Browser$screenshot(display = TRUE)
#No es necesario hacer clic en tiengo suerte:
# como ya no se puede hacer clic, extraer la url de para acceder a los proyecto
#Extraemos los Urls que nos interesa
#Decirle que actúe sobre la página actual para rasparlo
####No correeeeee
Pagina_actual<-Browser$getPageSource()
Pagina <- read_html(Pagina_actual[[1]]) # en el elemento 1 de la lista está la url de la página actual
UrlAcceso <- Pagina%>%
  html_node(css = "#res")%>%
  html_nodes("a")%>%
  html_attr("href")
#Jalar los urls de acceso manualmente
UrlAcceso <- c("http://www2.congreso.gob.pe/sicr/tradocestproc/Expvirt_2011.nsf/visbusqptramdoc1621/02096?opendocument",
               "http://www2.congreso.gob.pe/sicr/tradocestproc/Expvirt_2011.nsf/visbusqptramdoc1621/01936?opendocument",
               "http://www2.congreso.gob.pe/sicr/tradocestproc/Expvirt_2011.nsf/visbusqptramdoc1621/05764?opendocument",
               "http://www2.congreso.gob.pe/Sicr/TraDocEstProc/expvirt_2011.nsf/vf07web/E864DCA4F7487D46052582CD00562680?opendocument",
               "NoEncontrado","NoEncontrado",
               "http://www2.congreso.gob.pe/sicr/tradocestproc/Expvirt_2011.nsf/visbusqptramdoc1621/00497?opendocument",
               "http://www2.congreso.gob.pe/Sicr/TraDocEstProc/EXPVIRT_2011.nsf/vf07web/79B28ADF3E950105052580820080E130?opendocument",
               "http://www2.congreso.gob.pe/Sicr/TraDocEstProc/Expvirt_2011.nsf/vf07web/9F0AAD6F6D0A0882052580AE00522986?opendocument",
               "http://www2.congreso.gob.pe/sicr/tradocestproc/Expvirt_2011.nsf/visbusqptramdoc1621/03375?opendocument",
               "http://www2.congreso.gob.pe/sicr/tradocestproc/Expvirt_2011.nsf/visbusqptramdoc1621/03011?opendocument",
               "http://www2.congreso.gob.pe/Sicr/TraDocEstProc/expvirt_2011.nsf/vf07web/EB81E56CB48B86C0052580D50069F924?opendocument",
               "http://www2.congreso.gob.pe/Sicr/TraDocEstProc/Expvirt_2011.nsf/vf07web/919ECB422699C15B0525803B00684F0F?opendocument",
               "http://www2.congreso.gob.pe/sicr/tradocestproc/Expvirt_2011.nsf/visbusqptramdoc1621/03776?opendocument",
               "http://www2.congreso.gob.pe/sicr/tradocestproc/expvirt_2011.nsf/vf07web/FC9B2EAC5042577D052582F90010ABFC?opendocument",
               "http://www2.congreso.gob.pe/sicr/tradocestproc/Expvirt_2011.nsf/visbusqptramdoc1621/06584?opendocument",  #/html/body/form/table[2]/tbody/tr[2]/td[1]/table/tbody/tr/td/div/table/tbody/tr[2]/td[3]/a
               "http://www2.congreso.gob.pe/sicr/tradocestproc/Expvirt_2011.nsf/visbusqptramdoc1621/00064?opendocument",
               "http://www2.congreso.gob.pe/sicr/tradocestproc/Expvirt_2011.nsf/visbusqptramdoc1621/05028?opendocument",
               "http://www2.congreso.gob.pe/Sicr/TraDocEstProc/Expvirt_2011.nsf/vf07web/1FEA423B14B87DD305257B67007070B2?opendocument",
               "http://www2.congreso.gob.pe/sicr/tradocestproc/Expvirt_2011.nsf/visbusqptramdoc1621/02791?opendocument",
               "http://www2.congreso.gob.pe/sicr/tradocestproc/Expvirt_2011.nsf/visbusqptramdoc1621/01063?opendocument",
               "http://www2.congreso.gob.pe/Sicr/TraDocEstProc/Expvirt_2011.nsf/vf07web/D8632A2B1B5A6CB00525805F00571E8D?opendocument",
               "http://www2.congreso.gob.pe/sicr/tradocestproc/Expvirt_2011.nsf/visbusqptramdoc1621/03391?opendocument",
               "http://www2.congreso.gob.pe/Sicr/TraDocEstProc/expvirt_2011.nsf/vf07web/D9C6E8261C121D51052582F9000FF31F?opendocument",
               "http://www2.congreso.gob.pe/Sicr/TraDocEstProc/Expvirt_2011.nsf/vf07web/59A5D605F32C5839052581D1007C1E71?opendocument",
               "http://www2.congreso.gob.pe/sicr/tradocestproc/Expvirt_2011.nsf/visbusqptramdoc1621/03527?opendocument")

#Ahora navergar dichas urls
DataUnionB2Falta$UrlAcceso <- UrlAcceso
DataUnionB2Falta <- DataUnionB2Falta%>%
  select(c(1:7,10))
DataUnionB2Falta <- DataUnionB2Falta%>%
  filter(UrlAcceso!="NoEncontrado")
#Vamos navegar
AccesoUrl <- DataUnionB2Falta$UrlAcceso
Browser$navigate(AccesoUrl[1]) # 
Browser$screenshot(display=TRUE)
#Raspar las Urles de los proyectos de ley PDF
Pagina_actual<-Browser$getPageSource()
Pagina<-read_html(Pagina_actual[[1]]) # en el elemento 1 de la lista está la url de la página actual
DataPdf<-Pagina%>%
  html_node(xpath = '/html/body/form/table[2]/tbody/tr[2]/td[1]/table/tbody/tr/td/div/table[2]')%>%
  html_nodes("a")%>%
  html_attr("href")

DataPdf <- as.data.frame(DataPdf)
names(DataPdf)[1] <- "UrlPdfs"
DataPdf <- DataPdf%>%
  mutate(Número=DataUnionB2Falta[1,1])

DataPdf <- DataPdf[c(1:2),] #La ultima se repetia
#For
for (k in 2:24) {
  print(k)
  Browser$navigate(AccesoUrl[k]) # 
  #Browser$screenshot(display=TRUE)
  #Raspar las Urles de los proyectos de ley PDF
  Pagina_actual<-Browser$getPageSource()
  Pagina<-read_html(Pagina_actual[[1]]) # en el elemento 1 de la lista está la url de la página actual
  DataPdfs<-Pagina%>%
    html_node(xpath = '/html/body/form/table[2]/tbody/tr[2]/td[1]/table/tbody/tr/td/div/table[2]')%>%
    html_nodes("a")%>%
    html_attr("href")
  
  DataPdfs <- as.data.frame(DataPdfs)
  names(DataPdfs)[1] <- "UrlPdfs"
  DataPdfs <- DataPdfs%>%
    mutate(Número=DataUnionB2Falta[k,1])
  
  #Juntar con rbind
  DataPdf <- rbind(DataPdf,DataPdfs)
  #Descanse un rato
  Sys.sleep(3) 
}
#Falta leer una Url
Browser$navigate("http://www2.congreso.gob.pe/sicr/tradocestproc/Expvirt_2011.nsf/visbusqptramdoc1621/06584?opendocument") # 
Browser$screenshot(display=TRUE)
#Raspar las Urles de los proyectos de ley PDF
Pagina_actual<-Browser$getPageSource()
Pagina<-read_html(Pagina_actual[[1]]) # en el elemento 1 de la lista está la url de la página actual
DataPdfUno<-Pagina%>%
  html_node(xpath = '/html/body/form/table[2]/tbody/tr[2]/td[1]/table/tbody/tr/td/div/table')%>%
  html_nodes("a")%>%
  html_attr("href")

DataPdfUno <- as.data.frame(DataPdfUno)
names(DataPdfUno)[1] <- "UrlPdfs"
DataPdfUno <- DataPdfUno%>%
  mutate(Número="30864")
#Juntamos
DataPdf <- rbind(DataPdf,DataPdfUno)
#Contamos
DataPdf2 <- DataPdf%>%
  group_by(Número)%>%
  summarise(NumeroDeProyectos=n())
#Juntamos
DataUnionB2Falta <- merge.data.frame(DataUnionB2Falta,DataPdf2,
                                     by = c("Número"),
                                     all.x = T,sort = F)
#Juntamos Nuevamnete con DataPdf
DataUnionB2Falta <- merge.data.frame(DataUnionB2Falta,DataPdf,by = c("Número"),
                                    all.y = T,sort = F)
#Guardamos
saveRDS(DataUnionB2Falta,file = "Leyes/DataNeta3.rds")

#Juntar los tres DataNetas y quedará lista para leer los PDFS
#Llamar y juntar las bases de datos
DataNeta <- readRDS("Leyes/DataNeta1.rds") #Descarga con link
Data2 <- readRDS("Leyes/DataNeta2.rds")    #Descarga con google
Data3 <- readRDS("Leyes/DataNeta3.rds")    #Descarga manual
#
names(DataNeta)
names(Data2)
names(Data3)
#Limpieza
Data2 <- Data2%>%
  select(c(1:7,9:10))

Data3 <- Data3%>%
  select(c(1:7,9:10))

#Juntar
DataNeta <- rbind(DataNeta,Data2,Data3)

DataNeta <- DataNeta%>%
  arrange(Publicación)
#Guardamos
saveRDS(DataNeta,file = "Leyes/DataNetaTotal.rds") #2015 en adelante

#---- Prueba #----

#Hacer clic en Anterior: Prueba
AnteriorHoja <- Browser$findElement(using = "css",
                                    value = "#ctl00_ContentPlaceHolder1_GwDetalle_ctl23_ImgBtnAnterior")
AnteriorHoja$clickElement()
Browser$screenshot(display=TRUE)

# Hacer clic en sigiuente hasta 176
SiguienteHoja<-Browser$findElement(using = "css",
                                   value = "#ctl00_ContentPlaceHolder1_GwDetalle_ctl23_ImgBtnSiguiente") #Es Id

SiguienteHoja$clickElement()
Browser$screenshot(display=TRUE) # si salío



#---- cerrar la sesión #----
Browser$close()
server$stop()