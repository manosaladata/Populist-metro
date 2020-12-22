
# POPULISTÓMETRO: CONOCIENDO LA CALIDAD NORMATIVA DE NUESTROS CONGRESISTAS<img src="https://image.flaticon.com/icons/svg/323/323273.svg" width="30"/> 

## ¿De qué trata el proyecto?

Proyecto que busca transparentar la eficiencia de las personas que han sido Congresistas de la República y muchas de las cuales vuelven a postular. Asimismo, fomenta un ambiente de mejora de la calidad normativa para la posteridad. Esto se logrará a través del "Populistómetro", un ranking(o índice) que tomará diversas variables (ponderadas) para calificar si un proyecto de ley fue populista o de baja calidad normativa y saber el autor así como la bancada a la que perteneció. Entre dichas variables tenemos: 

-Leyes que no tienen análisis costo beneficio.
-Leyes emitidas de forma apresutada (en menos de una semana).
-Leyes que luego fueron declaradas inconstitucionales a pesar de que el ejecutivo las observó.

El"Populistómetro" se implementará a través de un Dashboard. Actualmente el proyecto se desarrolla en R (Shiny Dashboard). 

## ¿Por qué es importante? 
Muchas de las personas que en la actualidad buscan ejercer un cargo político, antes han sido congresistas.Si bien, la importancia allá de la coyuntura electoral, sirve para poder identificar cómo han actuado antes determinados candidatos. Ahora bie, en general, es complicado evaluar el desenvolvimiento de la labor de un congresista.Hacer más leyes no necesariamente indica una buena labor, tampoco hacer pocas. Lo importante es evaluar la calidad de estas normas, si están bien sustentadas, responden a parámetros constitucionales o han tenido la deliberación adecuada. Lamentablemente, esto último no se suele cumplir en nuestra realidad, donde es bastante difundida la idea de la bala calidad normativa de nuestra legislación. Una inicial forma para remediar este problema fue el uso del análisis costo beneficio(ACB). Más allá de las deficiencias o críticas metodológicas que pueda recibir este el ACB, en la práctica muy pocas veces se ha cumplido. 

En muchos casos los parlamentarios han omitido generar cualquier tipo de argumento sobre los costos de sus propuestas o su impacto con la frase "Esta Ley no Irrogará Gastos al Erario Público" o similares, lo cual muestra su poca voluntad por emitir una norma con buen estándard. Esto acompañado de procesos apresurados o proyectos de ley con un mal análisis jurídico que son luego declaradas inconstitucionales nos dan indicios razonables para calificar a una norma de baja calidad. 

##¿Cómo lo haremos?
Actualmente la página del congreso cuelga sus proyectos de ley, un análisis de estas nos permiten encontrar algunos indicios de poca argumentación del proyecto:

1. MAL ANÁLISIS DEL COSTO- BENEFICIO
Un primer indicio de populismo es la falta de análisis costo beneficio, muy común en las normas peruanas. Se suele apelar simplemente a que la Ley no generará o irrogará costos o beneficios. Lo que usaremos aquí es básicamente web scraping y algunos paquetes que nos servirán para leer los pdfs de los proyectos escaneados y filtrar frases claves como "no se generará gastos al erario" o "no se irrogará gastos al estado", entre otras que suelen ser comunes en este tipo de proyectos de ley. 

2. LEYES QUE SON HECHAS DE FORMA APRESURADA
Otro indicador son las Leyes que son hechas en pocos días. Esto demuestra la falta de voluntad para discutir las normas de forma idónea en las Comisiones del Congreso.La forma en cómo se accede a esto será a través del expediente donde se indica las fechas de discusión del proyecto. Por ejemplo, el reciente caso de Peajes:
http://www2.congreso.gob.pe/sicr/tradocestproc/Expvirt_2011.nsf/visbusqptramdoc1621/04951?opendocument

Es importante notar que el expediente señalado cuenta con el número final de la Ley, lo cual nos ayduará en el siguiente punto.

3. PROPUESTAS QUE VAN CONTRA  LA CONSTITUCIÓN
-Asimismo, tenemos a los Congresistas que han propuesto medidas que simplemente eran inviables por ser contrarias a la Constitución, pese a la aclaración del Ejecutivo. Un caso reciente es el de Peajes. Esto implica derrochar recursos públicos pese a la inviabilidad advertida del proyecto. Actualmente el TC permite encontrar todas las resoluciones sobre inconstitucionalidad, por ejemplo para el caso de pajes denunciada por el Ejecutivo:

http://181.177.234.7/buscarRes/public/resolucionjur?filtro=A&search=Inconstitucional%2C+Ley+Peaje%2C+Ejecutivo&demandante=&demandado=&numexpediente=&anoingreso=&idtipoproceso=0&anopublica=&pg=1

Un filtro de las denuncias presentadas por el ejecutivo o algún ministerio se puede obtener fácilmente con los filtros: ejecutivo y proyectos de Ley, por ej:
http://181.177.234.7/buscarRes/public/resolucionjur?filtro=A&search=Inconstitucional%2C+Ejecutivo&demandante=&demandado=&numexpediente=&anoingreso=&idtipoproceso=0&anopublica=&pg=1

A través de web scraping se puede extraer el contenido. 




## EQUIPO:

* Líder del proyecto: [Abner Casallo](https://www.linkedin.com/in/abner-francisco-casallo-trauco-b331b983/)

