# -*- coding: utf-8 -*-
"""
Created on Wed Dec  9 14:43:13 2020

@author: abner
"""

from selenium import webdriver

DRIVER_PATH = 'C:/chromedriver.exe'
driver = webdriver.Chrome(executable_path=DRIVER_PATH)
driver.get("https://leyes.congreso.gob.pe/LeyNume_1p.aspx?xEstado=2&xTipoNorma=0&xTipoBusqueda=2&xFechaI=01%2f01%2f2000&xFechaF=01%2f12%2f2020&xTexto=&xOrden=0&xNormaI=&xNormaF=")
driver.find_element_by_xpath("//a[@id='ctl00_ContentPlaceHolder1_GwDetalle_ctl02_LinkNumero']").click()


window_after = driver.window_handles[1]
driver.switch_to.window(window_after)
driver.find_element_by_xpath("//img[@title='Descargar expediente de la Ley']").click()
######REUBICAMOS EL WEB DRIVER A LA NUEVA VENTANA
#window_after = driver.window_handles[1] 


#id=ctl00_ContentPlaceHolder1_GwDetalle_ctl02_LinkNumero