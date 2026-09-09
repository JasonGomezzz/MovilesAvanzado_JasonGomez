# Pruebas del sistema de consulta del Metro de Lima

Desarrollado por: Jason Gomez

Las pruebas fueron ejecutadas con Swift 6.3.3 el 8 de septiembre de 2026. El proyecto compiló correctamente y el Playground terminó con 23 pruebas correctas y 0 pruebas fallidas.

## Catálogo de estaciones

### Catálogo general

- Resultado esperado: 53 estaciones únicas.
- Resultado obtenido: 53 estaciones únicas.
- Estado: Correcto.

### Línea 1

- Resultado esperado: 26 estaciones operativas y la futura estación 28 de Julio.
- Resultado obtenido: 27 registros, de los cuales 26 están operativos.
- Estado: Correcto.

### Línea 2

- Resultado esperado: 27 estaciones, con 5 operativas.
- Resultado obtenido: 27 registros, con 5 operativos y 22 en construcción.
- Estado: Correcto.

## Búsqueda de estaciones

### Búsqueda sin mayúsculas

- Entrada: `miguel grau`.
- Resultado esperado: Miguel Grau.
- Resultado obtenido: Miguel Grau.
- Estado: Correcto.

### Búsqueda sin tildes

- Entrada: `maria auxiliadora`.
- Resultado esperado: María Auxiliadora.
- Resultado obtenido: María Auxiliadora.
- Estado: Correcto.

### Búsqueda parcial

- Entrada: `santa anita`.
- Resultado esperado: Mercado Santa Anita y Óvalo Santa Anita.
- Resultado obtenido: dos coincidencias.
- Estado: Correcto.

### Búsqueda vacía

- Entrada: texto vacío.
- Resultado esperado: ninguna estación.
- Resultado obtenido: ninguna estación.
- Estado: Correcto.

## Accesibilidad y conexiones

### Estación sin ascensor

- Entrada: Pumacahua.
- Resultado esperado: informar que usa salvaescaleras y asistencia del personal.
- Resultado obtenido: acceso alternativo informado correctamente.
- Estado: Correcto.

### Ascensor de una estación en construcción

- Entrada: Puerto del Callao.
- Resultado esperado: mostrar el ascensor como infraestructura prevista.
- Resultado obtenido: el sistema aclara que la estación todavía no está operativa.
- Estado: Correcto.

### Consulta de Miguel Grau

- Resultado esperado: no indicar conexión directa con otra línea.
- Resultado obtenido: no registra conexiones directas.
- Estado: Correcto.

### Consulta de 28 de Julio

- Resultado esperado: conexión planificada entre Línea 1 y Línea 2.
- Resultado obtenido: conexión planificada mostrada correctamente.
- Estado: Correcto.

### Consulta de Estación Central

- Resultado esperado: conexión planificada con el Metropolitano.
- Resultado obtenido: conexión planificada mostrada correctamente.
- Estado: Correcto.

## Cálculo de rutas

### Ruta operativa en Línea 1

- Origen: Gamarra.
- Destino: Miguel Grau.
- Resultado esperado: Gamarra y Miguel Grau, sin presentar 28 de Julio como parada operativa.
- Resultado obtenido: Gamarra y Miguel Grau.
- Estado: Correcto.

### Ruta operativa en Línea 2

- Origen: Evitamiento.
- Destino: Mercado Santa Anita.
- Resultado esperado: cinco estaciones operativas y ninguna advertencia.
- Resultado obtenido: cinco estaciones y ninguna advertencia.
- Estado: Correcto.

### Ruta con transbordo

- Origen: Gamarra.
- Destino: Mercado Santa Anita.
- Resultado esperado: transbordo en 28 de Julio y advertencias por infraestructura no operativa.
- Resultado obtenido: un transbordo y dos advertencias.
- Estado: Correcto.

### Ruta inválida

- Origen: Estación inexistente.
- Destino: Gamarra.
- Resultado esperado: no generar una ruta.
- Resultado obtenido: no se generó una ruta.
- Estado: Correcto.

## Lugares de interés

### Museo de la Nación

- Origen: La Cultura.
- Resultado esperado: recomendar la estación La Cultura.
- Resultado obtenido: estación La Cultura.
- Estado: Correcto.

### Estadio Nacional

- Origen: Gamarra.
- Resultado esperado: dirigir a Estación Central, indicar el Metropolitano y advertir que la conexión es planificada.
- Resultado obtenido: recorrido, instrucciones y advertencias completas.
- Estado: Correcto.

## Validaciones del menú

- Una opción fuera del rango 1 a 7 muestra un mensaje y vuelve al menú.
- Una línea distinta de 1 o 2 muestra un mensaje de error.
- Una entrada vacía solicita nuevamente el dato.
- Una estación inexistente no cierra el programa.
- La opción 7 finaliza la aplicación correctamente.
