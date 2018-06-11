# TRATAMIENTO DIGITAL DE IMÁGENES POR ZONAS:
Estos scripts automatizan el tratamiento por zonas de imágenes digitales con Gimp. No obstante, 
a continuación os explico paso por paso, cuales son los pasos que se siguen habitualmente para 
trabajar una imagen por zonas, esto lo hago para que se comprenda qué es lo que hace el script
y sirva para comprender el proceso de forma general. Los pasos que se detallan en los puntos:
4, 5, 6, 7 y 8 son los que el script automatiza para aligerar nuestro flujo de trabajo de revelado 
creativo de fotografías NO RAW con Gimp (para no confundir he puesto un asterisco a los puntos
que se realizarán de forma automática al ejecutar el script):

1. Abrir un archivo de imagen (NO RAW) con Gimp.
2. Hacer los ajustes generales de contraste y puntos blanco y negro con las herramientas Niveles o Curvas.
3. Con la herramienta "selección libre" (F). 
   * Selecciono la zona que quiero ajustar con ayuda de tableta gráfica o ratón:
        1. Si necesitas rectificar la selección. Máscara rápida Sift+Q y pintas en negro o blanco para
              añadir o quitar selección.
        1. Quitar Máscara rápida. Sift+Q

EJECUTA AHORA EL SCRIPT PARA AUTOMATIZAR TODOS ESTOS PASOS QUE VIENEN A CONTINUACIÓN:
4. (*) Se copia como capa la imagen de base, pero esta vez lo que ajustaré será la zona que tenía seleccionada, 
con las herramientas Niveles o Curvas.

5. (*) Añadir máscara de capa a partir de la selección.

6. (*) Cambiar el modo de fusión de la capa dependiendo del ajuste que queremos hacer:

        1. Modo de fusión NORMAL si es una foto en escala de grises.
        1. Modo de fusión VALOR si se trata de una foto RGB.

7. (*) Cambiamos la opacidad de la capa al 50%. Esto nos permite un ajuste a "posteriori" del efecto que buscamos.

8. (*) Para suavizar la transición entre la zona ajustada y la imagen puedes desenfocar la máscara con
     Desenfoque gaussiano, hasta que dejes de notar la transición. Depende de la zona y de la resolución 
     de la imagen, pero generalmente no suelo bajar de 300 y no es raro usar 1000 o más en los cielos, por ejemplo.

9. Volvemos al paso 3 del tratamiento digital para la siguiente zona

Este Plugin está hecho para Gimp a partir de su versión 2.0
 
Log de cambios:
- 1.00 - Script inicial
- 1.01 - Script para desenfocar la máscara después de creada (Al gusto de Tat)
- 1.10 - Script que pregunta el radio de desenfoque que aplicará a la máscara
- 1.11 - Script que abre el diálogo de desenfoque gausiano después de ejecutarse
- 1.12 - Se completa la información adjunta en el script. Posibilidad de aplanar la imagen en cada ciclo.
- 1.13 - Corrección de la sintaxis del comando "plug-in-gauss-iir" para que funcione en Gimp 2.10
