library(shinydashboard)
library(readxl)
library(tidyverse)
library(formattable)
library(data.table)
library(gridExtra)
library(rsconnect)
library(hrbrthemes)
library(plotly)
library("leaflet.extras")
#source("modules/DT_mod.R")
source("modules/map.R")


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

ley_group_cabal<-0

####TRABAJANDO CON LEYES Y PARTIDOS POLÍTICOS#####
view(congresistas)
####LEYES





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

fig <- plot_ly(df_leyes, x = ~leyes, y = ~Populistas, type = 'bar', name = 'Potencialmente populistas',
               marker = list(color = 'red',
                             line = list(color = 'black',
                                         width = 2)))
fig <- fig %>% add_trace(y = ~No_populistas, name = 'No populistas', 
                         marker = list(color = 'white',
                                       line = list(color = 'black',
                                                   width = 2)))
fig <- fig %>% layout(yaxis = list(title = 'Count'), barmode = 'stack')

fig2<-fig

#
# +geom_text(aes(label = populista, y=leyes), position = position_dodge(3),
#             vjust = 1.5, family = "Georgia")


ui <- dashboardPage(title="POPULISTÓMETRO", skin="blue",  #Color del encabezado y nombre a la página (cuando abres con el explordor se nota)
                    #numericInput("ENTIDAD_DEPARTAMENTO",ENTIDAD_DEPARTAMENTO),
                    dashboardHeader(title="EXPLORADOR",
                                    dropdownMenu(type="message",   
                                                 messageItem(from="Abner", message="Bienvenido"),
                                                 messageItem(from="Abner", message="Proyecto Open Source", icon=icon("bar-chart"), time = "21:00")),
                                    dropdownMenu(type="notifications",        
                                                 notificationItem(
                                                   text="Esperamos que les sirva",
                                                   icon=icon("dashboard"),
                                                   status="success"),
                                                 notificationItem(
                                                   text="Base de Datos",
                                                   icon=icon("warning"),
                                                   status="warning")),
                                    dropdownMenu(type="task",
                                                 taskItem(
                                                   value=50,
                                                   color="aqua",
                                                   "Avance de ideas del proyecto"
                                                 ),
                                                 taskItem(
                                                   value=0,
                                                   color="green",
                                                   "Avance de Gráficos y Tablas"
                                                 ),
                                                 taskItem(
                                                   value=0,
                                                   color="red",
                                                   "Automatización"
                                                 ))),
                    
                    dashboardSidebar(
                      #sliderInput(inputId = "n",                   #En el dashboardsiderbar no van box, queda feo si lo pones.                        
                      # "Number of contracts",
                      # 1,100,50),
                      sidebarMenu( id="sidebarID",                                #Para crear un menú y se pueda abrir una nueva ventana por cada item.
                        sidebarSearchForm("searchText","buttonSearch","Search"),
                        menuItem("Información General", tabName="num", icon = icon("arrow-alt-circle-right")), #el tab Name=dep, permite relacionar el grÃ¡fico de dashboardBody
                        menuItem("Análisis de partidos políticos", tabName= "plot", icon = icon("arrow-alt-circle-right")),
                        menuItem("Análisis de Congresistas",id = "chartsID",icon = icon("arrow-alt-circle-right"),tabName="raros",
                                 menuSubItem("Leyes sin costo beneficio", tabName= "df_merge",icon = icon("arrow-alt-circle-right")),
                                 menuSubItem("Leyes emitidas rápido",tabName = "entidad_mn",icon = icon("arrow-alt-circle-right")),
                                 menuSubItem("Leyes inconstitucionales ",tabName = "entidad_mn",icon = icon("arrow-alt-circle-right"))
                        ),
                        menuItem("Cómo usar el Populistómetro"),
                        menuItem("¿Quiénes somos?"),
                        textInput("text_input","Contáctenos", value="populistometro@gmail.com"),
                        textInput("text_input","Repositorio Git-Hub", value="https://github.com/abnercasallo/Populist-metro")
                      )),
                    
                    dashboardBody(                        #Podría ir arriba, pero sale desordenado.
                      tags$style(
                        type = 'text/css', 
                        '.bg-aqua {background-color: #005CB9!important; }'
                      ),
                      tabItems(tabItem(tabName = "num", 
                                       fluidRow(
                                         column(width=6,
                                       valueBoxOutput("num_ley"),
                                       valueBoxOutput("num_con"),
                                       valueBoxOutput("num_costb"),
                                       valueBox(2,"Leyes emitidas en menos de dos semanas
                                                    ",  #df group agrupa a los congresistas
                                                icon=icon("dashboard"),color="yellow"))),
                                       # fluidRow(column(width=8,
                                       #                 infoBox("Transparencia","100%",icon=icon("thumbs-up")),
                                       #                 infoBox("Dato abiertos", "100%")
                                       # )),
                                       
                                       fluidRow(column(width=12,
                                                       box(leafletOutput(("mapa"))),
                                                       column(width=6,
                                                       box(plotlyOutput("pop")))
                                                
                                                )
                                       )
      
                      ), tabItem(tabName = "plot",
                                 fluidPage(sidebarLayout(
                                   sidebarPanel(
                                 selectInput("ngear", "¿Qué partido político le interesa?",
                                                       c("PartidoA"="PartidoA",
                                                         "PartidoB"="PartidoB",
                                                         "PartidoC"="PartidoC"))),
                                   
                                   mainPanel(
                                   
                                   tabsetPanel(type="tab", 
                                               tabPanel("Data", DT::dataTableOutput("df")),
                                               tabPanel("Evolución de sus Leyes", 
                                                        box(plotOutput("plot")),
                                                        )
                                     
                                   ))),
                                   sidebarLayout(
                                     sidebarPanel(
                                       selectInput("ngear2", "¿Qué partido político le interesa?",
                                                   c("PartidoA"="PartidoA",
                                                     "PartidoB"="PartidoB",
                                                     "PartidoC"="PartidoC"))),
                                     
                                     mainPanel(
                                       
                                       tabsetPanel(type="tab", 
                                                   tabPanel("Data", DT::dataTableOutput("df2")),
                                                   tabPanel("Evolución de sus Leyes", 
                                                            box(plotOutput("plot2")),
                                                   )
                                                   
                                       )
                                   # tabsetPanel(type="tab",
                                   #             tabPanel("Leyes por Partidos Políticos",valueBox(45,"días en promedio se discute una propuesta
                                   #                  ",  #df group agrupa a los congresistas
                                   #                               icon=icon("dashboard"),color="yellow")
                                   #                      )
                                   #             )
                                 )
                                 ))
                      ),
                      
                      tabItem(tabName = "df_merge",
                              DT::dataTableOutput("df_merge"))
                 
                      
                      
                      ))
                      
                    
)

server <- function(input
                   , output) {
  
  output$num_ley<-renderInfoBox({valueBox(count((df)[1]),"Leyes analizadas", 
                                      icon=icon("eye"),color="red")})
  output$num_con<-renderInfoBox({valueBox(count(df_group[1]),"Congresistas",  #df group agrupa a los congresistas
                                        icon=icon("dashboard"),color="green")}) 
  output$num_costb<-renderInfoBox({valueBox(sum(df_costb$num_leyes),"Leyes con costo Beneficio defectuoso",  #df group agrupa a los congresistas
                                          icon=icon("dashboard"),color="blue")}) 
 
  
react<-reactive(ggplot(proyectos, aes(x=fechas_proyectos, y=.data[[input$ngear]], group = 1)) +
                  geom_line( color="grey") +
                  geom_point(shape=21, color="black", fill="#69b3a2", size=6) +
                  theme_ipsum() +
                  ggtitle("Evolución legislativa")
)

react2<-reactive(ggplot(proyectos, aes(x=fechas_proyectos, y=.data[[input$ngear2]], group = 1)) +
                  geom_line( color="grey") +
                  geom_point(shape=21, color="black", fill="#69b3a2", size=6) +
                  theme_ipsum() +
                  ggtitle("Evolución legislativa")
)

  output$df <- DT::renderDataTable({
    
    df_info[,c("Entradas",input$ngear)]  }
    )
  output$df2 <- DT::renderDataTable({
    
    df_info[,c("Entradas",input$ngear2)]  }
  )
  output$df_merge <- DT::renderDataTable(df_merge)
  
  output$plot <-renderPlot(react()) 
  output$plot2 <-renderPlot(react2())
  output$pop<- renderPlotly(fig)
  output$mapa <- renderLeaflet(mapa) 


  
}

shinyApp(ui = ui, server = server, options = list(height = 1080))



