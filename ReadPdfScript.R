#Paquetes necesarios
library(tidyverse)
library(pdftools)
library(tesseract)
#library(textreadr)

#Cargar la data
DataLey <- readRDS(file = "DataLeyes/DataNetaTotal.rds")
#Filtramos para el último año
DataLey <- DataLey%>%
  filter(Publicación>="2020-01-01")
#creamos un ID para identificar
DataLey <- DataLey%>%
  mutate(ID=c(1:472))

#Extraemos las Urls de los PDFs
LinkPdf <- DataLey$UrlPdfs

#---- Leer PDF #----
KeyWords <- c("Ley Que","Ley De","Ley Por","Los Congresistas","Congresista","Miembro",
              "Parlamentario","Costo Beneficio","Presente Iniciativa","Presupuesto",
              "Recursos Del Estado","Gasto","Gastos","Beneficios","Costos",
              "Presupuestarios","Recursos")
KeyMatch<-str_c(KeyWords,collapse = "|")

ReadPDF<-pdf_ocr_text(LinkPdf[1],language = "spa",dpi = 600) #pages = c(1:2)
InfoPDF <- ReadPDF%>%
  str_to_title(locale = "sp")%>% #converte en forma de título en español
  str_split(pattern = "\n")%>%
  unlist()%>%
  str_replace_all("[^[:alnum:]]"," ")%>% # reemplaza a todo distinto a alfanumerico por un espacio blanco
  str_replace_all("  "," ")%>%
  str_trim()%>%
  str_subset(pattern =KeyMatch,negate = F) #Extrae solo las que contiene el keyword

#Convierte en data estructurada
InfoPDF<-InfoPDF%>%
  matrix(ncol = length(InfoPDF),byrow = T)%>%
  as.data.frame()
#Agregamos los identificadores 
InfoPDF$ID <- DataLey[1,10] #Columna fija
InfoPDF$Numero <- DataLey[1,1]

#Hacemos el For para 5 pdfs
for (j in 2:5) {
  print(j)
  ReadPDF<-pdf_ocr_text(LinkPdf[j],language = "spa",dpi = 600) 
   InfoPdfs <- ReadPDF%>%
    str_to_title(locale = "sp")%>% #converte en forma de título en español
    str_split(pattern = "\n")%>%
    unlist()%>%
    str_replace_all("[^[:alnum:]]"," ")%>% # reemplaza a todo distinto a alfanumerico por un espacio blanco
    str_replace_all("  "," ")%>%
    str_trim()%>%
    str_subset(pattern =KeyMatch,negate = F) #Extrae solo las que contiene el keyword
  
  #Convierte en data frame
   InfoPdfs<-InfoPdfs%>%
    matrix(ncol = length(InfoPdfs),byrow = T)%>%
    as.data.frame()
  #Agregamos los identificadores 
   InfoPdfs$ID <- DataLey[j,10]    #Columna fija
   InfoPdfs$Numero <- DataLey[j,1] #Columna fija
   #Juntamos la data 
   InfoPDF <- bind_rows(InfoPDF,InfoPdfs)
   #Descansar un rato
   Sys.sleep(1)
}

#Guadar la data y hacer merge
