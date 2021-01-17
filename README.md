
<div style="text-align:justify">

# POPULISTÓMETRO: CONOCIENDO LA CALIDAD NORMATIVA DE NUESTROS CONGRESISTAS<img src="https://image.flaticon.com/icons/svg/323/323273.svg" width="30"/> 

## ¿De qué trata el proyecto?

Proyecto que busca transparentar la eficiencia de las personas que han sido Congresistas de la República, fomentando un ambiente de mejora de la calidad normativa para la posteridad. Esto se logrará a través del "Populistómetro", un dashboard que presentará, entre otros aspectos, un ranking(o índice) que tomará diversas variables (ponderadas) para calificar si un proyecto de ley fue populista o de baja calidad normativa y saber el autor así como la bancada a la que perteneció. También se buscará implementar qué congresistas votaron a favor o en contra de dicha medida. Entre dichas variables tenemos: 

-Leyes que no tienen análisis costo beneficio. <br>
-Leyes emitidas de forma apresutada (en menos de una semana). <br>
-Leyes que luego fueron declaradas inconstitucionales a pesar de que el ejecutivo las observó. <br>

El"Populistómetro" se implementará a través de un Dashboard.  

## ¿Por qué es importante? 
Muchas de las personas que en la actualidad buscan ejercer un cargo político, antes han sido congresistas. Si bien, la importancia allá de la coyuntura electoral, sirve para poder identificar cómo han actuado antes determinados candidatos. Ahora bien, en general, es complicado evaluar el desenvolvimiento de la labor de un congresista. Hacer más leyes no necesariamente indica una buena labor, tampoco hacer pocas. Lo importante es evaluar la calidad de estas normas, si están bien sustentadas, responden a parámetros constitucionales o han tenido la deliberación adecuada. Lamentablemente, éste último no se suele cumplir en nuestra realidad, donde es bastante difundida la idea de la baja calidad normativa de nuestra legislación. Una inicial forma para remediar este problema fue el uso del análisis costo beneficio(ACB). Más allá de las deficiencias o críticas metodológicas que pueda recibir este el ACB, en la práctica muy pocas veces se ha cumplido. 

En muchos casos los parlamentarios han omitido generar cualquier tipo de argumento sobre los costos de sus propuestas o su impacto con la frase "Esta Ley no Irrogará Gastos al Erario Público" o similares, lo cual muestra su poca voluntad por emitir una norma con buen estándar. Esto acompañado de procesos apresurados o proyectos de ley con un mal análisis jurídico que son luego declaradas inconstitucionales nos dan indicios razonables para calificar a una norma de baja calidad. 

## ¿Cómo lo haremos?
Actualmente la página del congreso cuelga sus proyectos de ley, un análisis de estas nos permiten encontrar algunos indicios de poca argumentación del proyecto:

1. MAL ANÁLISIS DEL COSTO- BENEFICIO
Un primer indicio de populismo es la falta de análisis costo beneficio, muy común en las normas peruanas. Se suele apelar simplemente a que la Ley no generará o irrogará costos. Lo que usaremos aquí es básicamente web scraping y algunos paquetes que nos servirán para leer los pdfs de los proyectos escaneados y filtrar frases claves como "no se generará gastos al erario" o "no se irrogará gastos al estado", entre otras que suelen ser comunes en este tipo de proyectos de ley. 

2. LEYES QUE SON HECHAS DE FORMA APRESURADA
Otro indicador son las Leyes que son hechas en pocos días. Esto demuestra la falta de voluntad para discutir las normas de forma idónea en las Comisiones del Congreso. La forma en cómo se accede a esto será a través del expediente donde se indica las fechas de discusión del proyecto. Por ejemplo, el reciente caso de <a href="http://www2.congreso.gob.pe/sicr/tradocestproc/Expvirt_2011.nsf/visbusqptramdoc1621/04951?opendocument">peajes</a>. Es importante notar que el expediente señalado cuenta con el número final de la Ley, lo cual nos ayudará en el siguiente punto.

3. PROPUESTAS QUE VAN CONTRA  LA CONSTITUCIÓN
Finalmente, tenemos a los Congresistas que han propuesto medidas que simplemente eran inviables por ser contrarias a la Constitución, incluso pese a la oposición del Ejecutivo. Un caso reciente es el de Peajes. Esto implica derrochar recursos públicos pese a la inviabilidad advertida del proyecto. Actualmente el TC permite encontrar todas las resoluciones sobre inconstitucionalidad, por ejemplo el caso del
<a href= "http://181.177.234.7/buscarRes/public/resolucionjur?filtro=A&search=Inconstitucional%2C+Ley+Peaje%2C+Ejecutivo&demandante=&demandado=&numexpediente=&anoingreso=&idtipoproceso=0&anopublica=&pg=1"> "proyecto sobre peaje denunciado por el Ejecutivo"</a>


Un filtro de las denuncias presentadas por el ejecutivo o algún ministerio se puede obtener fácilmente con los filtros: ejecutivo y proyectos de Ley. <a href="http://181.177.234.7/buscarRes/public/resolucionjur?filtro=A&search=Inconstitucional%2C+Ejecutivo&demandante=&demandado=&numexpediente=&anoingreso=&idtipoproceso=0&anopublica=&pg=1">"Por ejemplo"</a>


A través de web scraping se puede extraer el contenido. 




## EQUIPO:

* Líder del proyecto: [Abner Casallo](https://www.linkedin.com/in/abner-francisco-casallo-trauco-b331b983/)

* Miembros:
-[Jose Laura](https://www.linkedin.com/in/jose-luis-laura-pumaleque/)
-[Jhon Figueroa](https://www.linkedin.com/in/jhon-vidal-figueroa-c%C3%A9spedes-166837124/)

