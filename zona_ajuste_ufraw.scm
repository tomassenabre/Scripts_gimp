; zona_ajuste_ufraw.scm    version 1.14    11 Junio de 2018
;
;##############################################################################
; INSTALACIÓN
; 1.- Copia el archivo en:
;       Si es GIM 2.4 y linux en la carpeta /home/tunombreusuario/.gimp-2.4/scripts
;       Si es GIM 2.6 y linux en la carpeta /home/tunombreusuario/.gimp-2.6/scripts
;       Si es GIM 2.8 y linux en la carpeta /home/tunombreusuario/.gimp-2.6/scripts
;       Si es GIM 2.10 y linux en la carpeta /home/tunombreusuario/.config/.gimp-2.10/scripts
;
; 2.- Reinicia Gimp
;
;##############################################################################
; CONFIGURACIÓN EN GIMP
;
; 1.- El script aparece en el menú Script-Fu de Gimp. Yo le he añadido una combinación de 
;     teclas para ejecutarlo (ALT+Z). Para hacerlo tienes que ir a:
;         Archivo -> Preferencias -> Interfaz -> Configurar las combinaciones de teclas...
;
; 2.- Despliegas la lista de "Complementos" y al final del todo te aparecerá el script 
; "Zona de Ajuste con UFRAW". Lo seleccionas con el ratón y pulsas la combinación de teclas 
; que te gusta (en mi caso ALT+Z)
;
;##############################################################################
; TRATAMIENTO DIGITAL DE IMÁGENES POR ZONAS CON UFRAW:
; Este script automatiza el tratamiento por zonas de imágenes digitales con Gimp. No obstante, 
; a continuación os explico paso por paso, cuales son los pasos que se siguen habitualmente para 
; trabajar una imagen por zonas, esto lo hago para que se comprenda qué es lo que hace el script
; y sirva para comprender el proceso de forma general. Los pasos que se detallan en los puntos:
; 4, 5, 6 y 7 son los que el script automatiza para aligerar nuestro flujo de trabajo de revelado 
; creativo de fotografías RAW con Gimp y UFRaw (para no confundir he puesto un asterisco a los puntos
; que se realizarán de forma automática al ejecutar el script):
;
; 1.- Abrir un archivo RAW con Gimp, se iniciará el plugin de UFRAW.
; 2.- Revelar normalmente el archivo RAW para obtener a partir de ufraw la imagen que me servirá como base.
; 3.- Con la herramienta "selección libre" (F). Selecciono la zona que quiero ajustar con ayuda de tableta 
;     gráfica o ratón.
;         3.1.- Si necesitas rectificar la selección. Máscara rápida Sift+Q y pintas en negro o blanco para
;               añadir o quitar selección.
;         3.2.- Quitar Máscara rápida. Sift+Q
;
; EJECUTA AHORA EL SCRIPT PARA AUTOMATIZAR TODOS ESTOS PASOS QUE VIENEN A CONTINUACIÓN:
;
; 4*.- Abrir como capa la misma imágen (u otra con bracketing) (Ctrl+Alt+O). Se abre nuevamente el plugin 
;     de UFRAW para Gimp, pero esta vez lo que ajustaré será la zona que tenía seleccionada. ¿Cómo?:
;         4.1.- Si lo que quiero es levantar las sombras o bajar las luces tocaré sólo el ajuste de exposición.
;         4.2.- Si lo que quiero es incrementar el contraste tocaré sólo el punto blanco y negro de la curva de 
;               ajuste (pestaña 5 en UFRAW 0.15); si no llego a obtener el contraste que quiero, puedo además 
;               dar forma de S a la curva.
;         4.3.- La pregunta del millón ¿Como sabes qué estás ajustando la zona que seleccionaste?. 
;               Porque tengo activado los avisos de pérdidas en las luces y en las sombras y no dejo que 
;               aparezcan estos indicadores en la zona que tenía seleccionada, aproximadamente. Estos 
;               indicadores me sirven para fijar el punto negro y el blanco, dentro de la zona que me 
;               interesa, aunque achicharre el resto de imagen.
;
; 5*.- Añadir máscara de capa a partir de la selección.
;
; 6*.- Cambiamos la opacidad de la capa al 75%. Esto nos permite un ajuste a "posteriori" del efecto que buscamos.
;
; 7*.- Para suavizar la transición entre la zona ajustada y la imagen puedes desenfocar la máscara con
;     Desenfoque gaussiano, hasta que dejes de notar la transición. Depende de la zona y de la resolución 
;     de la imagen, pero generalmente no suelo bajar de 300 y no es raro usar 1000 o más en los cielos, por ejemplo.
;
; 8.- Volvemos al paso 3 del tratamiento digital para la siguiente zona
;
;
;
; Este Plugin está hecho para Gimp a partir de su versión 2.0
;
; Log de cambios:
; 1.00 - Script inicial
; 1.01 - Script para desenfocar la máscara después de creada (Al gusto de Tat)
; 1.10 - Script que pregunta el radio de desenfoque que aplicará a la máscara
; 1.11 - Script que abre el diálogo de desenfoque gausiano después de ejecutarse
; 1.12 - Se completa la información adjunta en el script. Posibilidad de aplanar la imagen en cada ciclo.
; 1.13 - Se rectifica la ayuda adjunta en el script y Sertinell aporta una modificación para poder guardar el
;        el trabajo como XCF y continuar con el proceso en otra sesión
; 1.14 - Corrección de la sintaxis del comando "plug-in-gauss-iir" para que funcione en Gimp 2.10
;
;##############################################################################
;
; LICENCIA
;
;  CC 2009 www.tomassenabre.es
;
;  Zona de ajuste con UFRaw es software libre; puedes copiarlo, distribuirlo y/o
;  modificarlo dentro de los términos considerados en la Licencia Pública General
;  de GNU publicada por la Fundación de Software Libre.
;
;  Zona de Ajuste con UFRaw se distribuye con la esperanza de de que será de
;  utilidad, pero SIN NINGUNA GARANTÍA; tampoco tiene garantías de
;  MERCHANDISE o APTITUD PARA UN PROPÓSITO PARTICULAR.
;
;##############################################################################
;
; LICENSE
;
;  CC 2009 www.tomassenabre.es
;
;  Adjust Zone with UFRaw is free software; you can redistribute it and/or
;  modify it under the terms of the GNU General Public License as
;  published by the Free Software Foundation.
;
;  Adjust Zone with UFRaw is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;  General Public License for more details.
;
;##############################################################################


; ------------------------------------------------------------------------------------------------
; Definición de las variables
(define (script-fu-zona-ajuste-ufraw aimg drawable)

; ------------------------------------------------------------------------------------------------
; Si tu ordenador no es muy potente, es conveniente que acoples cada una de las zonas que vas revelando
; por que Gimp se vuelve pesado con forme se incrementa el número de capas. Para ello suprime el ";"
; de la siguiente línea:

; (gimp-image-flatten aimg)

; ------------------------------------------------------------------------------------------------
; Comienza a guardar las acciones para poder usar la acción "deshacer" 
(gimp-undo-push-group-start aimg)

; ------------------------------------------------------------------------------------------------
; Crear nuevas imágenes y capas necesarias a partir del archivo RAW
  (let* (
    (filename (car (gimp-image-get-filename aimg)))
    (img-ufraw (car (gimp-file-load RUN-INTERACTIVE filename filename)))
    (layer  (aref (cadr (gimp-image-get-layers aimg)) 0))
    (layer-ufraw (car (gimp-layer-new-from-drawable
            (aref
             (cadr (gimp-image-get-layers img-ufraw)) 0)
            aimg)))
    (image-type (car (gimp-image-base-type aimg)))
    (layer-mask (car (gimp-layer-create-mask layer-ufraw ADD-SELECTION-MASK)))
    )

; ------------------------------------------------------------------------------------------------
; ** Modificación aportada por Sertinell ** Permite continuar el trabajo con una imagen RAW, después
; de haber guardado un XCF de Gimp. Por defecto esta aportación viene desactivada debido a que por 
; el momento, sólo puede usarse con los archivos de una única extensión y puede darse el caso de un
; usuario que tenga cámaras con archivos RAW de diferentes extensiones. Si este no es tu caso debes 
; de comentar el apartado anterior y descomentar el que sigue ahora:
 
;  (let* (
;    (filename (string-append 
;	(substring 
;		(car(gimp-image-get-filename aimg)) 
;		0 
;		(-  (string-length (car(gimp-image-get-filename aimg))) 4)
;	) 
;	".raw" ) ; Donde pone la extensión raw debemos sustituirla por la extensión raw de
;	)        ; nuestra cámara (ej. orf, cr2, nef,...) debe coincidir
;		 ; mayúsculas y minúsculas.
;    (img-ufraw (car (gimp-file-load RUN-INTERACTIVE filename filename)))
;    (layer  (aref (cadr (gimp-image-get-layers aimg)) 0))
;    (layer-ufraw (car (gimp-layer-new-from-drawable
;            (aref
;             (cadr (gimp-image-get-layers img-ufraw)) 0)
;            aimg)))
;    (image-type (car (gimp-image-base-type aimg)))
;    (layer-mask (car (gimp-layer-create-mask layer-ufraw ADD-SELECTION-MASK)))
;    )
; ------------------------------------------------------------------------------------------------

; Realizamos las siguientes acciones descritas en el flujo de trabajo:

; ------------------------------------------------------------------------------------------------
; Creamos la nueva capa con la imagen que obtiene de UFRaw
     (gimp-image-add-layer aimg layer-ufraw -1) 

; ------------------------------------------------------------------------------------------------
; Crea una máscara de capa a partir de nuestra selección
     (gimp-layer-create-mask layer-ufraw ADD-SELECTION-MASK)
     (gimp-layer-add-mask layer-ufraw layer-mask)

; ------------------------------------------------------------------------------------------------
; Quita la selección para que el desenfoque afecte a toda la máscara
     (gimp-selection-none aimg)

; ------------------------------------------------------------------------------------------------
; Inicia la herramienta de desenfoque gaussiano. El método de desenfoque es IIR que es preferible 
; cuando se usan radios grandes. El radio de desenfoque por defecto es 800 pero podemos cambiarlo 
; en la siguiente línea: 
     (plug-in-gauss-iir RUN-NONINTERACTIVE aimg layer-mask  250 TRUE TRUE)


; ------------------------------------------------------------------------------------------------
; Le da nombre a la capa generada
     (gimp-layer-set-name layer-ufraw "Zona ufraw ")

; ------------------------------------------------------------------------------------------------
; Determina el modo de fusión de la capa VALOR para imágenes RGB y NORMAL para imágenes en Escala de grises
     (if (= image-type 0) (gimp-layer-set-mode layer-ufraw VALUE))

; ------------------------------------------------------------------------------------------------
; Fija la opacidad de la nueva capa. Por defecto está en 75%, pero se puede cambiar a vuestras necesidades
     (gimp-layer-set-opacity layer-ufraw 75)

; ------------------------------------------------------------------------------------------------
; Cambia la selección de edición de la máscara a la imagen para que no tengamos que hacerlo nosotros
     (gimp-layer-set-edit-mask layer-ufraw FALSE)

; ------------------------------------------------------------------------------------------------
; Borra la imagen intermedia que había creado
     (gimp-image-delete img-ufraw)
   )

; ------------------------------------------------------------------------------------------------
; Cierra el grupo de la acción "deshacer"
  (gimp-undo-push-group-end aimg)

; ------------------------------------------------------------------------------------------------
; Vacia todos los procesos internos del script
  (gimp-displays-flush))

; ------------------------------------------------------------------------------------------------
; Registro del script-fu en los menús de Gimp
(script-fu-register "script-fu-zona-ajuste-ufraw"
          "<Image>/Script-Fu/_Zona de ajuste con ufraw"
          "Crea una capa con máscara a partir de una zona seleccionada ajustando con UFRaw y después abre la herramienta de desenfoque gaussiano."
          "Tomas Senabre <tomassenabre.es arroba gmail.com>"
          "www.tomassenabre.es"
          "Jun 11, 2018"
          "RGB*, GRAY*"
          SF-IMAGE "Input Image" 1
          SF-DRAWABLE "Input Drawable" 0)

; CC 2009 Tomás Senabre www.tomassenabre.es <tomassenabre.es@gmail.com>
