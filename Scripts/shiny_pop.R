library(shinydashboard)
library(readxl)
library(tidyverse)
library(formattable)
library(data.table)
library(gridExtra)
library(rsconnect)
#rsconnect::deployApp('path/to/your/app')
#library(tableHTML)


customGreen0 = "#DeF7E9"
customGreen = "#71CA97"
customRed = "#ff7f7f"


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
                      sidebarMenu(                                 #Para crear un menú y se pueda abrir una nueva ventana por cada item.
                        sidebarSearchForm("searchText","buttonSearch","Search"),
                        menuItem("Información General", tabName="map_mon", icon = icon("arrow-alt-circle-right")), #el tab Name=dep, permite relacionar el grÃ¡fico de dashboardBody
                        menuItem("Ranking de Congresistas",badgeLabel = "Importante",badgeColor ="red",icon = icon("arrow-alt-circle-right"),tabName="raros"),
                        menuItem("Leyes sin costo beneficio",icon = icon("arrow-alt-circle-right")),
                        menuItem("Leyes emitidas rápido",tabName = "entidad_mn",icon = icon("arrow-alt-circle-right")), #el tab Name=contract, permite relacionar el histograma
                        menuItem("Leyes inconstitucionales ",tabName = "entidad_mn",icon = icon("arrow-alt-circle-right")),
                        textInput("text_input","Contáctenos", value="abner.casallo@unmsm.edu.pe"),
                        textInput("text_input","Repositorio Git-Hub", value="https://github.com/abnercasallo/Populist-metro")
                      )),
                    
                    dashboardBody(                        #Podría ir arriba, pero sale desordenado.
                      tags$style(
                        type = 'text/css', 
                        '.bg-aqua {background-color: #005CB9!important; }'
                      ),
                      tabItems(tabItem(tabName = "PRUEBA"
                                       

                      )
                      
                      ),
                      
                    )
)

server <- function(input
                   , output) {
  
  
  
}

shinyApp(ui = ui, server = server, options = list(height = 1080))



