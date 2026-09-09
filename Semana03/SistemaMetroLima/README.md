# Sistema de consulta del Metro de Lima

Desarrollado por: Jason Gomez

Aplicación académica en Swift para consultar las seis líneas de la Red Básica del Metro de Lima, sus estaciones disponibles, accesibilidad, conexiones y rutas. El proyecto incluye una aplicación de consola y un Playground que utilizan la misma lógica.

## Objetivo

Aplicar arrays, diccionarios, estructuras, condicionales, funciones y ciclos para organizar información de transporte y responder consultas realizadas por el usuario.

## Requerimientos funcionales

### RF01 Buscar estaciones

El sistema debe permitir buscar una estación por su nombre sin diferenciar entre mayúsculas, minúsculas o tildes.

### RF02 Listar estaciones por línea

El sistema debe mostrar en orden las estaciones registradas para las líneas 1, 2, 3 y 4. Para las líneas 5 y 6 debe explicar que todavía no existe un catálogo oficial definitivo.

### RF03 Mostrar información de una estación

El sistema debe indicar el nombre, las líneas, la ubicación, el distrito y el estado de servicio de una estación encontrada.

### RF04 Consultar accesibilidad

El sistema debe informar si una estación cuenta con ascensor o con otro medio de acceso asistido.

### RF05 Consultar conexiones

El sistema debe mostrar las conexiones de una estación con otras líneas del Metro o con el Metropolitano. También debe diferenciar las conexiones operativas de las planificadas.

### RF06 Calcular rutas

El sistema debe recibir una estación de origen y otra de destino para mostrar las estaciones del recorrido en el orden correcto dentro de la red registrada de las líneas 1 a 4.

### RF07 Mostrar transbordos

Cuando el origen y el destino pertenezcan a líneas diferentes, el sistema debe indicar cada estación donde se realiza un transbordo.

### RF08 Recomendar rutas por lugar de interés

El sistema debe recomendar cómo llegar al Estadio Nacional, Gamarra, Museo de la Nación, Mercado Mayorista de Santa Anita y Plaza de Armas de Ate.

### RF09 Advertir servicios no operativos

El sistema debe advertir cuando una estación, conexión o tramo de la ruta todavía se encuentre en construcción o esté planificado.

### RF10 Validar entradas

El sistema debe controlar opciones de menú incorrectas, textos vacíos y estaciones que no estén registradas, sin finalizar inesperadamente.

### RF11 Consultar el estado de las seis líneas

El sistema debe mostrar el estado, corredor, distritos de referencia, horizonte y observaciones de las líneas 1 a 6.

### RF12 Representar la Línea 3 planificada

El sistema debe registrar las 28 estaciones referenciales de la Línea 3 como planificadas y mostrar sus intercambios proyectados sin presentarlos como disponibles.

### RF13 Diferenciar los componentes de la Línea 4

El sistema debe identificar las ocho estaciones del ramal al aeropuerto como infraestructura en construcción y las veinte estaciones referenciales del corredor principal como planificadas.

### RF14 Representar responsablemente las Líneas 5 y 6

El sistema debe permitir consultar los corredores, distritos y horizonte de las líneas 5 y 6 sin inventar nombres de estaciones que todavía no han sido publicados oficialmente.

### RF15 Combinar estaciones de intercambio

Cuando una estación pertenezca a varias líneas, el sistema debe conservar una sola entrada en el diccionario y mostrar el estado que tiene en cada línea.

### RF16 Calcular rutas con varios transbordos

El sistema debe calcular recorridos que utilicen las líneas 1 a 4 y mostrar más de un transbordo cuando sea necesario.

### RF17 Distinguir información operativa y referencial

El sistema debe advertir que una ruta calculada sobre estaciones en construcción o planificadas representa una propuesta académica y no un viaje disponible actualmente.

## Reglas de los datos

- La Línea 1 contiene sus 26 estaciones operativas.
- La futura estación 28 de Julio se registra como conexión planificada entre las líneas 1 y 2.
- La Línea 2 contiene sus 27 estaciones y conserva el estado de servicio de cada una.
- La Línea 3 contiene 28 estaciones referenciales, todas con estado planificado.
- La Línea 4 contiene 8 estaciones del ramal en construcción y 20 estaciones referenciales del corredor principal planificado.
- Las líneas 5 y 6 contienen información de corredor, distritos y horizonte, pero no estaciones inventadas.
- La estación Miguel Grau no se registra como conexión con la Línea 2.
- La Estación Central conserva su conexión planificada con el Metropolitano.
- Cabitos, Estación Central, Rivera Navarrete, Carmen de la Legua, La Cultura y Mercado Santa Anita combinan los estados de sus líneas correspondientes.
- En las estaciones en construcción, la accesibilidad corresponde a la infraestructura prevista y no a un servicio actualmente disponible.

## Estructura del proyecto

- `SistemaMetroCLI`: contiene la entrada y el menú de la aplicación de consola.
- `SistemaMetro.playground`: contiene los casos de prueba para ejecutar en Xcode.
- `SistemaMetro.playground/Sources`: contiene los modelos, datos y funciones compartidos.
- `DatosLinea1.swift` a `DatosLinea4.swift`: contienen los arrays ordenados de estaciones.
- `DatosLineas.swift`: contiene el diccionario con la información general de las seis líneas.

## Ubicación local en la Mac

La carpeta preparada para abrir y presentar el proyecto es:

```text
/Users/jason/Dev/MovilesAvanzado_JasonGomez/Semana03/SistemaMetroLima
```

Esta carpeta está conectada con la rama `sistema-metro`. El Laboratorio 3 permanece separado en `Semana03/Lab03-Colecciones`, por lo que los commits de ambos trabajos no se mezclan.

## Ejecutar la aplicación en Xcode

1. Abrir Xcode desde Terminal con el siguiente comando:

```bash
open -a Xcode "/Users/jason/Dev/MovilesAvanzado_JasonGomez/Semana03/SistemaMetroLima"
```

2. También se puede seleccionar `File`, `Open` y elegir la carpeta `SistemaMetroLima`.
3. Esperar que Xcode cargue el archivo `Package.swift`.
4. Seleccionar el esquema `SistemaMetroLima` y el destino `My Mac`.
5. Presionar `Command + R`.
6. Escribir las opciones y los datos solicitados en la consola de Xcode.

## Revisar el proyecto desde Terminal

Ingresar a la ubicación definitiva y comprobar la rama:

```bash
cd "/Users/jason/Dev/MovilesAvanzado_JasonGomez/Semana03/SistemaMetroLima"
pwd
git status
git log --oneline -20
```

Mostrar los requerimientos usando `nano`:

```bash
nano README.md
```

Dentro de `nano`, presionar `Control + W`, escribir `Requerimientos funcionales` y presionar `Enter`. Para salir sin modificar el archivo, presionar `Control + X`.

También se puede revisar el menú principal:

```bash
nano SistemaMetroCLI/main.swift
```

Después de revisar el código, ejecutar la aplicación:

```bash
swift run SistemaMetroLima
```

## Ejecutar las pruebas en Playground

1. Abrir `SistemaMetro.playground` con Xcode.
2. Mostrar la consola con `Shift + Command + Y`.
3. Presionar el botón para ejecutar el Playground.
4. Verificar que el resumen indique 37 pruebas correctas y 0 pruebas fallidas.

Los archivos ubicados en `SistemaMetro.playground/Sources` son compartidos con la aplicación de consola. De esta forma, el Playground prueba exactamente los mismos modelos, datos y funciones.

## Opciones del menú

1. Buscar estación.
2. Ver información y estaciones por línea.
3. Consultar accesibilidad.
4. Consultar conexiones.
5. Calcular ruta entre estaciones.
6. Buscar lugar de interés.
7. Salir.

## Demostración sugerida para el profesor

La presentación puede realizarse con el siguiente recorrido:

1. Abrir `README.md` con `nano` y mostrar los requerimientos `RF01` a `RF17`.
2. Ejecutar `swift run SistemaMetroLima`.
3. Elegir la opción `1` y buscar `miguel grau` para demostrar que la búsqueda ignora mayúsculas y tildes.
4. Elegir la opción `2` y consultar la Línea `3` para mostrar sus 28 estaciones planificadas.
5. Repetir la opción `2` con la Línea `4` para distinguir estaciones en construcción y planificadas.
6. Repetir la opción `2` con la Línea `5` para demostrar que la aplicación no inventa estaciones.
7. Elegir la opción `3` y consultar `Pumacahua` para mostrar su acceso alternativo.
8. Elegir la opción `4` y consultar `Miguel Grau` para confirmar que no registra una conexión directa.
9. Repetir la opción `4` con `28 de Julio` para mostrar la conexión planificada entre las líneas 1 y 2.
10. Elegir la opción `1` y buscar `Cabitos` para mostrar sus estados diferentes en las líneas 1 y 3.
11. Elegir la opción `5`, usar `El Álamo` como origen y `Aeropuerto` como destino para mostrar una ruta con dos transbordos y advertencias.
12. Elegir la opción `6`, usar `Gamarra` como origen y `Estadio Nacional` como lugar para mostrar la recomendación mediante Estación Central y el Metropolitano.
13. Elegir la opción `7` para cerrar correctamente la aplicación.
14. Abrir `SistemaMetro.playground` y comprobar el resumen de 37 pruebas correctas y 0 pruebas fallidas.

## Alcance sobre las tarifas

La aplicación no calcula precios ni tarifas de viaje porque esa función no formó parte de los requerimientos originales. Su alcance académico es consultar estaciones, líneas, accesibilidad, conexiones, rutas y lugares de interés. Una consulta de tarifas tendría que desarrollarse posteriormente como un requerimiento adicional basado en información oficial vigente.

## Fuentes de información

Fuentes consultadas y verificadas hasta el 9 de septiembre de 2026:

- [Mapa del Metro de Lima](https://upload.wikimedia.org/wikipedia/commons/0/05/Lima_Metro_Map.svg)
- [Estaciones y accesibilidad de Línea 1](https://www.lineauno.pe/preguntas/las-estaciones-de-linea1-cuentan-con-accesos-para-personas-con-movilidad-reducida/)
- [Estaciones de Línea 2](https://www.metrolima2.com/linea-2/)
- [Conexión de Línea 2 con el Metropolitano](https://www.gob.pe/institucion/atu/noticias/1065334-atu-como-se-conectaran-las-estaciones-centrales-de-la-linea-2-y-el-metropolitano)
- [Nueva estación de intercambio 28 de Julio](https://www.gob.pe/institucion/atu/noticias/1401829-mtc-renueva-operatividad-e-impulsa-modernizacion-de-linea-1-del-metro-de-lima-y-callao-por-mas-de-uds-3-887-millones)
- [Hoja de ruta oficial para las líneas 3, 4, 5 y 6](https://www.gob.pe/institucion/atu/noticias/1428232-que-distritos-conectaran-las-futuras-lineas-3-4-5-y-6-del-metro-conoce-la-hoja-de-ruta-del-transporte-para-los-proximos-20-anos)
- [Interconexiones proyectadas de las líneas 3 y 4](https://www.gob.pe/institucion/atu/noticias/1409879-atu-lineas-3-y-4-se-conectaran-con-las-lineas-1-2-y-el-metropolitano-para-mejorar-la-movilidad-en-la-ciudad)
- [Características e interconexiones de la Línea 3](https://www.gob.pe/institucion/atu/noticias/1009807-linea-3-del-metro-se-interconectara-con-las-lineas-1-y-2-el-metropolitano-y-los-corredores-complementarios/)
- [Estaciones oficiales del ramal de la Línea 4](https://www.gob.pe/institucion/mtc/noticias/965061-mtc-conozca-todos-los-detalles-del-ramal-de-la-linea-4-del-metro-de-lima-y-callao)

## Consideración sobre los datos

La aplicación es un ejercicio académico y no reemplaza la información oficial para planificar un viaje real. Los estados de servicio pueden cambiar después de la fecha de consulta indicada.
