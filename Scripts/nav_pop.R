library(shiny)
library(shinydashboard)
library(tidyverse)
library(formattable)
library(data.table)
library(gridExtra)
library(rsconnect)
library(shinythemes)
library(shiny)
library(DT)

ui <-navbarPage("POPULISTÓMETRO", #theme = shinytheme("cerulean"),
                      tabPanel("ETF's",
                                    dropdownMenu(type="message",   
                                                 messageItem(from="Abner", message="Bienvenido"),
                                                 messageItem(from="Abner", message="Proyecto Open Source", icon=icon("bar-chart"), time = "21:00"),
                                                 messageItem(from="Abner", message="Trabajo parte del Proyecto Manos a la Data", icon=icon("vcard"), time = "10-10-2020")),
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
                                                   value=60,
                                                   color="green",
                                                   "Avance de Gráficos y Tablas"
                                                 ),
                                                 taskItem(
                                                   value=10,
                                                   color="red",
                                                   "Automatización"
                                                 ))),
                    
                    dashboardSidebar(
                      sidebarMenu(                                 #Para crear un menú y se pueda abrir una nueva ventana por cada item.
                        sidebarSearchForm("searchText","buttonSearch","Search"),
                        menuItem("Información General"), #el tab Name=dep, permite relacionar el grÃ¡fico de dashboardBody
                        menuItem("Top 500 de proveedores",badgeLabel = "Importante",badgeColor ="red",icon = icon("arrow-alt-circle-right")),
                        menuItem("Rubros",icon = icon("arrow-alt-circle-right")),
                        menuSubItem("Por Montos"),    #Más icons:https://fontawesome.com/icons?d=gallery
                        menuSubItem("Por Número de Contratos"),
                        menuItem("Por entidad",icon = icon("arrow-alt-circle-right")), #el tab Name=contract, permite relacionar el histograma
                        menuSubItem("Por número de contratos"),
                        menuSubItem("Orden por monto contratado"),
                        textInput("text_input","Contáctenos", value="abner.casallo@unmsm.edu.pe"),
                        textInput("text_input","Repositorio Git-Hub")
                      )),
                
                tabPanel("LEYES SIN ANÁLISIS COSTO BENEFICIO"),
                tabPanel("LEYES INCONSTITUCIONALES"),
                tabPanel("LEYES QUE SE EMITIERON RÁPIDO"),
                    
                    dashboardBody(                        #Podría ir arriba, pero sale desordenado.
                      tags$style(
                        type = 'text/css', 
                        '.bg-aqua {background-color: #005CB9!important; }'
                      ),
                      
                    )
)

server <- function(input
                   , output) {
  
  
  
}

names(df)
shinyApp(ui = ui, server = server, options = list(height = 1080))
