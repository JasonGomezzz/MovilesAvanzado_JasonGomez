# Sistema de consulta del Metro de Lima

Desarrollado por: Jason Gomez

Aplicación académica en Swift para consultar estaciones, accesibilidad, conexiones y rutas de las líneas 1 y 2 del Metro de Lima. El proyecto incluye una aplicación de consola y un Playground que utilizan la misma lógica.

## Objetivo

Aplicar arrays, diccionarios, estructuras, condicionales, funciones y ciclos para organizar información de transporte y responder consultas realizadas por el usuario.

## Requerimientos funcionales

### RF01 Buscar estaciones

El sistema debe permitir buscar una estación por su nombre sin diferenciar entre mayúsculas, minúsculas o tildes.

### RF02 Listar estaciones por línea

El sistema debe mostrar en orden todas las estaciones registradas para la Línea 1 o la Línea 2.

### RF03 Mostrar información de una estación

El sistema debe indicar el nombre, la línea, la ubicación, el distrito y el estado de servicio de una estación encontrada.

### RF04 Consultar accesibilidad

El sistema debe informar si una estación cuenta con ascensor o con otro medio de acceso asistido.

### RF05 Consultar conexiones

El sistema debe mostrar las conexiones de una estación con otras líneas del Metro o con el Metropolitano. También debe diferenciar las conexiones operativas de las planificadas.

### RF06 Calcular rutas

El sistema debe recibir una estación de origen y otra de destino para mostrar las estaciones del recorrido en el orden correcto.

### RF07 Mostrar transbordos

Cuando el origen y el destino pertenezcan a líneas diferentes, el sistema debe indicar la estación donde se realiza el transbordo.

### RF08 Recomendar rutas por lugar de interés

El sistema debe recomendar cómo llegar al Estadio Nacional, Gamarra, Museo de la Nación, Mercado Mayorista de Santa Anita y Plaza de Armas de Ate.

### RF09 Advertir servicios no operativos

El sistema debe advertir cuando una estación, conexión o tramo de la ruta todavía se encuentre en construcción o esté planificado.

### RF10 Validar entradas

El sistema debe controlar opciones de menú incorrectas, textos vacíos y estaciones que no estén registradas, sin finalizar inesperadamente.

## Reglas de los datos

- La Línea 1 contiene sus 26 estaciones operativas.
- La futura estación 28 de Julio se registra como conexión planificada entre las líneas 1 y 2.
- La Línea 2 contiene sus 27 estaciones y conserva el estado de servicio de cada una.
- La estación Miguel Grau no se registra como conexión con la Línea 2.
- La Estación Central conserva su conexión planificada con el Metropolitano.
- En las estaciones en construcción, la accesibilidad corresponde a la infraestructura prevista y no a un servicio actualmente disponible.

## Estructura del proyecto

- `SistemaMetroCLI`: contiene la entrada y el menú de la aplicación de consola.
- `SistemaMetro.playground`: contiene los casos de prueba para ejecutar en Xcode.
- `SistemaMetro.playground/Sources`: contiene los modelos, datos y funciones compartidos.

## Fuentes de información

Fuentes consultadas el 8 de septiembre de 2026:

- [Mapa del Metro de Lima](https://upload.wikimedia.org/wikipedia/commons/0/05/Lima_Metro_Map.svg)
- [Estaciones y accesibilidad de Línea 1](https://www.lineauno.pe/preguntas/las-estaciones-de-linea1-cuentan-con-accesos-para-personas-con-movilidad-reducida/)
- [Estaciones de Línea 2](https://www.metrolima2.com/linea-2/)
- [Conexión de Línea 2 con el Metropolitano](https://www.gob.pe/institucion/atu/noticias/1065334-atu-como-se-conectaran-las-estaciones-centrales-de-la-linea-2-y-el-metropolitano)
- [Nueva estación de intercambio 28 de Julio](https://www.gob.pe/institucion/atu/noticias/1401829-mtc-renueva-operatividad-e-impulsa-modernizacion-de-linea-1-del-metro-de-lima-y-callao-por-mas-de-uds-3-887-millones)
