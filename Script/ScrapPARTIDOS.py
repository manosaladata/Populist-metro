# -*- coding: utf-8 -*-
"""
Created on Sun Jan 17 01:03:15 2021

@author: abner
"""

from bs4 import BeautifulSoup
from selenium import webdriver
import pandas as pd
import requests



URL = 'http://www.congreso.gob.pe/pleno/congresistas/'
DRIVER_PATH = 'C:/chromedriver.exe'
driver = webdriver.Chrome(executable_path=DRIVER_PATH)
driver.get(URL)

#driver.find_element_by_xpath("//img[@src='/Observatorio/Imagenes/iconos/map_sisfor.png']").click()
texto=driver.find_element_by_xpath('//table[@class="congresistas"]').text
texto= texto.split("\n")
print(texto)


x="'Acate Coronel Eduardo Geovanni ALIANZA PARA EL PROGRESO eacate@congreso.gob.pe"
''.join([c for c in x if c.isupper()])

texto_final=[]
for i in texto:
    j=''.join([c for c in i if c.isupper()])
    texto_final.append(j)

print(texto_final)

columna = pd.DataFrame(texto_final)
print(columna)

columna.to_excel(r'D:\Git Hub-BEST\Populist-metro1\partidos.xlsx', index = False)
