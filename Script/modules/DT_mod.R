####MÓDULO DE DATA TABLES#####
library(readxl)
library(tidyverse)
library(formattable)
library(data.table)
library(gridExtra)
library(rsconnect)
library(hrbrthemes)
library(DT)
library(plotly)


setwd("D:/Git Hub-BEST/Populist-metro1/Scripts")
load("D:/Git Hub-BEST/Populist-metro1/Scripts/simul_data.RData")

congresistas <- read_excel("Datos.xlsx")
names(congresistas)[6] <- "Nota"

for (i in 1:nrow(congresistas[6])){
  if (congresistas[i,6]=="Costo Beneficio deficiente"){
    congresistas[i,6]<-"Costo beneficio deficiente"
  }}

#####CREAMOS VARIABLES

#congresistas_group_total<-filter(congresistas, Nota  %in% "Costo beneficio deficiente"| Nota %in% "Hace algún esfuerzo")
congresistas_group_total<-group_by(congresistas,Autor)
congresistas_group_total<-summarise(congresistas_group_total, "Num.Proyectos"=n())

Partidos<-c("Unión por el Perú", "Fuerza Popular", "Somos Perú", "Unión por el Perú",
            "Acción Popular", "Podemos Perú", "Frepap", "Unión por el Perú", 
            "Frente Amplio", "Fuerza Popular", "Alianza para el Progreso", "APRA",
            "Somos Perú", "Alianza para el Progreso", "Somos Perú",
            "Podemos Perú", "Fuerza Popular", "Podemos Perú", "Acción Popular", 
            " Fuerza Popular", "Podemos Perú", "Partido Morado", 
            "	Alianza para el Progreso", "Alianza para el Progreso",
            "Frepap", "Acción Popular", "Acción Popular", "Fuerza Popular",
            "Poder Ejecutivo", "Frepap", "Acción Popular", "Acción Popular",
            "Acción Popular", "Fuerza Popular", "Alianza para el Progreso"
)



congresistas_group_total<-cbind(congresistas_group_total,Partidos)
#View(congresistas_group_total)
#Roel Alva,Luis Andrés
#Omonte Durand De Dyer, Maria Del Carmen
#Montenegro Figueroa, Gloria Edelmira: Alianza para el Progreso (2004-2019) Partido Morado (2020-actualidad)


congresistas_group_def<-filter(congresistas, Nota  %in% "Costo beneficio deficiente")
congresistas_group_def<-group_by(congresistas_group_def, Autor)
congresistas_group_def<-summarise(congresistas_group_def, "numero de proyectos con costo beneficio deficiente"=n())


congresistas_group_esf<-filter(congresistas, Nota %in% "Hace algún esfuerzo")
congresistas_group_esf<-group_by(congresistas_group_esf,Autor)
congresistas_group_esf<-summarise(congresistas_group_esf, "Hace algún esfuerzo"=n())

#library(dplyr)
df_merge<-left_join(congresistas_group_total, congresistas_group_def, by = c("Autor"="Autor"))
df_merge<-left_join(df_merge, congresistas_group_esf, by = c("Autor"="Autor"))

df_merge[is.na(df_merge)] <- 0

###proyectos que cumplen con el manual###
proy_cumplen<-c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,00,0,0,0,
                0,0,0,0,0,0,0,0,0,0,0,0,0)

df_merge<-cbind(df_merge,proy_cumplen)

names(df_merge)[4:6] <- c("Proyectos con costo beneficio deficiente",
                          "Proyectos donde se hace algún esfuerzo en el Costo Beneficio",
  "Proyectos que cumplen cabalmente el manual de costo beneficio del Congreso")

df_merge<-as.datatable(formattable(df_merge, align =c("c","c","c","c","c","c"), list(
  `Proyectos con costo beneficio deficiente`=color_tile("white", "red") ,
  `Proyectos donde se hace algún esfuerzo en el Costo Beneficio` = color_tile("white","red")   #no bar, distorsiona el sort
)))
df_merge
#view(df_merge)

######NÚERO DE PROYECTOS DE LEY DEFICIENTES#######
ley_group_def<-filter(congresistas, Nota  %in% "Costo beneficio deficiente")
#ley_group_def-group_by(ley_group_def, Ley)
num_ley_group_def<-nrow(ley_group_def)
print(num_ley_group_def)

ley_group_esf<-filter(congresistas, Nota %in% "Hace algún esfuerzo")
num_ley_group_esf<-nrow(ley_group_esf)
print(num_ley_group_esf)

ley_group_def<-filter(congresistas, Nota  %in% "Costo beneficio deficiente")


Congresista_autor<-c("Congresista A", "Congresista B", "Congresista C", "Congresista A")
Leyes<-c ( "Ley 001", "Ley 002","Ley 003", "Ley 004")
costo_beneficio<-c ( "Su análisis tiene menos de 100 palabras","No hace el menor esfuerzo", "Hace algún esfuerzo", "No hace el menor esfuerzo")
inconstitucionalidad<-c ("No fue declarada inconstitucional", "Sí fue inconstitucional",
                         "No fue inconstitucional", "No fue declarada inconstitucional")
emitida_menosdeunmes<-c("Sí, en 20 días", "No, en 40 días", "Sí, en 8 días", "Sí, en 7 días")


df<- data.frame(Congresista_autor, Leyes, costo_beneficio, inconstitucionalidad,emitida_menosdeunmes)

df_group<-df %>%
  group_by(Congresista_autor)%>%
  summarise(num_leyes=n())

df_costb<-df %>%
  filter(costo_beneficio %in% "No hace el menor esfuerzo"|costo_beneficio %in% "Su análisis tiene menos de 100 palabras")%>%
  group_by(costo_beneficio)%>%
  summarise(num_leyes=n())


df_time<-c(as.Date('1/15/2016', format='%m/%d/%Y'),as.Date('1/15/2017',format='%m/%d/%Y'))


Entradas<-c("Fecha de creación","Número de iniciativas legislativas", "Cuántas tienen ACB defectuoso","Cuántas fueron inconstitucionales*" )
PartidoA<-c("02/04/2012",5,  2, 1)#, as.Date('1/15/2017', format='%m/%d/%Y'))
PartidoB<-c("03/05/2006",4, 1, 0)#,as.Date('1/15/2018', format='%m/%d/%Y'))
PartidoC<-c("03/05/2001",2, 1, 0)
df_info<- data.frame(Entradas, PartidoA, PartidoB, PartidoC)



# leyes<-c("Ley","Ley","Ley", "Ley", "Ley", "Ley")
# populista<-c("A","A","B","B","A","A")
# df_leyes<-data.frame(leyes,populista)
# df_leyes

leyes<-c("2018","2019")
Populistas<-c(1,5)
No_populistas<-c(2,7)
df_leyes<-data.frame(leyes, No_populistas, Populistas)
#df_leyes


#módulos

df_mergeUI<-function(id) {tagList(DTOutput(NS(id,"df_merge")
))}

df_mergeServer<-function(id){
  moduleServer(id, function(input, output, session) {
    output$df_merge<-renderDT(df_merge)
  })}



