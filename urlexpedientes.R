library(tidyverse)
library(xml2)
library(rvest)
library(RSelenium)
library(wdman)
library(robotstxt)
library(lubridate)
setwd("D:/Git Hub-BEST/Populist-metro/Leyes")

TodasLeyes <- readRDS("Leyes/TodasLeyes.rds")
NumeroLey <- TodasLeyes$Número
NumeroLey <-as.data.frame(NumeroLey)
NumeroLey[1,1]

server<-phantomjs(port=5012L)
#nrow(NumeroLey)

data<-vector()
for (i in 1:nrow(NumeroLey)){
  UrlExpe <- "https://leyes.congreso.gob.pe/DetLeyNume_1p.aspx?xNorma=6&xNumero="
  UrlExpe <- paste0(UrlExpe,NumeroLey[i,1],"&xTipoNorma=0") #1829
  options(encoding = "utf-8") # Le asignamos el encoding
  Browser <- remoteDriver(browserName = "phantomjs", port=5012L)
  Browser$open()

  Browser$navigate(UrlExpe) # 
  Browser$screenshot(display=TRUE)
  Pagina_actual<-Browser$getPageSource()
  ExpedienteUrl <- read_html(Pagina_actual[[1]])%>%
    html_node(css = "#DvDetalle_LinkExpediente")%>%
    html_attr("href")
  
data=append(data, ExpedienteUrl)

}
View(data)
saveRDS(data,"exp_url_1171.rds")
