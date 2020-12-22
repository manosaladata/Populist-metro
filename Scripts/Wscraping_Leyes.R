library(xml2)  #Para leer html.
library(rvest)
library(RSelenium)  #Pra trabajar con páginas dinámicas
library(wdman)    #Navegador fantasma, permite usar rsDriver
library(robotstxt)
library(tidyverse)

#server<-phantomjs(port=5015L)

UrlMadre<-"https://leyes.congreso.gob.pe/LeyNume_1p.aspx?xEstado=2&xTipoNorma=0&xTipoBusqueda=2&xFechaI=01%2f01%2f2000&xFechaF=01%2f12%2f2020&xTexto=&xOrden=0&xNormaI=&xNormaF="
#paths_allowed(paths = c(UrlMadre))
#options(encoding = "utf-8")
#Browser <- rsDriver(browserName = "phantomjs", port=5015L)

#En caso de error borrar directorio en: C:\Users\abner\AppData\Local\binman
binman::list_versions("chromedriver")
driver <- rsDriver(browser = c("chrome"),chromever = "87.0.4280.88")

remote_driver <- driver[["client"]]
remote_driver$open()
remote_driver$navigate("https://leyes.congreso.gob.pe/LeyNume_1p.aspx?xEstado=2&xTipoNorma=0&xTipoBusqueda=2&xFechaI=01%2f01%2f2000&xFechaF=01%2f12%2f2020&xTexto=&xOrden=0&xNormaI=&xNormaF=")
nuevo<-remote_driver$findElement("xpath", "//a[@id='ctl00_ContentPlaceHolder1_GwDetalle_ctl02_LinkNumero']")
nuevo$clickElement()
nueva_pag<-remote_driver$getPageSource()
leerexp<-read_html(nueva_pag[[1]])
nueva_pag<-remote_driver$getPageSource()
#url2<-remote_driver$findElement(css="#DvDetalle_LinkExpediente")  #clase=punto, hashtag:id


url2<-remote_driver$findElement(using = "css",
                                      value = "#DvDetalle_LinkExpediente") 
url2$clickElement()

# url2<-leerexp %>%
#   html_node("xpath","//a[@id='DvDetalle_LinkExpediente']")

# url2<-nuevo$getWindowHandles()
# url2$navigate(url2[[1]])
# 
# 
# nuevo2<-remote_driver$findElement("xpath","//a[@id='DvDetalle_LinkExpediente']")
# nuevo2$clickElement()
