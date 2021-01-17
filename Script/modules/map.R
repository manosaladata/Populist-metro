library(sf)    #Permite relación geos
library(tidyverse)
library(ggrepel)
library(tmap)
library(readxl)
library(leaflet)
library("leaflet.extras")



departamentos<-st_read("DEPARTAMENTOS.shp")            ###OJO, SE REQUIEREN TODOS LOS ARCHIVOS

ggplot(data = departamentos) +
  geom_sf()

ggplot(data = departamentos %>%
         filter(DEPARTAMEN=="LIMA")) +
  geom_sf()



########COLOCANDO NOMBRES##########
departamentos <- departamentos %>% mutate(centroid = map(geometry, st_centroid), 
                                          coords = map(centroid,st_coordinates), 
                                          coords_x = map_dbl(coords, 1), coords_y = map_dbl(coords,2))

DEPARTAMEN<-departamentos[["DEPARTAMEN"]]
print(DEPARTAMEN)
cantidades<-c(1,2,3,4,5,5,6,7,7,8,8,5,6,7,8,8,4,4,4,5,6,7,8,9,1)
zonas<-data.frame(DEPARTAMEN,cantidades)

departamentos<- departamentos%>% 
  left_join(zonas)




mapa<-tm_shape(departamentos) +
  tmap_options(bg.color = "green",inner.margins = c(0.1,0.1, 0.02,0.01)) +   #ubicamos a la leyenda
  tm_text('DEPARTAMEN',
          size = 0.5,
          fontface = 2,
          fontfamily = 'Tw Cen MT Condensed')+
  #tm_polygons("MONTO",palette = "viridis")+ #Greens
  tm_polygons("cantidades", title = "Cantidad de Congresistas por Departamento", style = "fixed",
              breaks = c(0, 3, 5, 15, 30),
              #textNA = "Lima", 
              #colorNA = "green",   # <-------- color for NA values
              palette = "viridis")+
  tm_compass(type = "4star", size = 2.5, fontsize = 0.5,
             color.dark = "gray60", text.color = "gray60",
             position = c("left", "top"))  +
  #tm_borders(col = "black")+
  tm_layout(frame=FALSE,      #Sacamos el recuadro        
            main.title = 'Congresistas por Departamento',
            main.title.size = 0.8,
            fontface = 2,
            fontfamily = 'Tw Cen MT Condensed',
            main.title.position = c(0.12,0.5)) +
  tm_scale_bar(size = 0.4,
               width = 0.21,
               color.dark = 'White',
               color.light = 'black',
               position = c(0.5,0.03))

mapa<-tmap_leaflet(mapa)

mapa<-addProviderTiles(mapa,providers$Stamen.Watercolor, group = "Stamen Watercolor", options = providerTileOptions(noWrap = TRUE)) %>%#, minZoom = 4)) %>%
  addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Open Street Map", options = providerTileOptions(noWrap = TRUE))


observeEvent(input$mapa_marker_click, { 
  pin <- input$mapa_marker_click
  #print(Sys.time()) #uncomment to log coords
  #print(pin) #uncomment to log coords
  selectedPoint <- reactive(parks[departamentos$Latitude == pin$lat & departamentos$Longitude == pin$lng,])
  leafletProxy("mapa", data = selectedPoint()) %>% clearPopups() %>% 
    addPopups(~Longitude,
              ~Latitude,
              #popup = ~park_card(selectedPoint()$ParkName, selectedPoint()$ParkCode, selectedPoint()$State, selectedPoint()$Acres, selectedPoint()$Latitude, selectedPoint()$Longitude)
    )
})

