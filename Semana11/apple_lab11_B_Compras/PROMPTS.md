# Prompts utilizados — Laboratorio 11, Caso B (Compras)

## Herramienta de IA utilizada

Claude Code (modelo Claude Sonnet 5.5), dentro de la app de escritorio de Claude.

## Qué se pidió

El enunciado `GLAB-S11-JLEONS-2026-02.pdf` (Caso B de compras) y mis notas de la clase
del profesor:

> con core data o con swiftdata, hacer caso de compras, caso B presentar la próxima semana,
> agregar la imagen que sale en la tarea, caso B trabajo individual, darle valores agregados
> obligatorio agregarle algo que diferencie al trabajo es obligatorio, entregar con ficha
> técnica si o si

Se pidió desarrollar únicamente la parte B, completa, con commits y con ficha técnica. Antes
de empezar, la IA hizo preguntas y se respondió esto:

- **Valor agregado:** gráficos con Swift Charts, con un diseño propio y no genérico.
- **Ramas:** hacer el trabajo en `ai-assisted` y también en `manual`.
- **Formato de entrega:** ficha técnica en PDF y Markdown dentro del repositorio.
- **Visto bueno del docente:** todavía no lo tengo.

## Respuesta de la IA

Creó el proyecto `apple_lab11_B_Compras` con SwiftUI y SwiftData: cuatro clases `@Model`
(`Usuario`, `Proveedor`, `Producto`, `Compra`), las nueve pantallas B1 a B9, la lógica de
negocio en `ReglasCompra`, un verificador de los casos de prueba y la ficha técnica.
Tomó el ícono y el logo de la imagen del enunciado, como pidió el profesor.

## ¿Funcionó a la primera?

La lógica sí: el verificador dio 11 de 11 casos desde la primera ejecución. En la interfaz
hubo ajustes después de probar en el simulador:

- `.onDelete(perform: condición ? borrar : nil)` no compilaba; se cambió por
  `.deleteDisabled(!sesion.esSupervisor)`.
- iOS ofrecía «contraseña segura» y tapaba el campo; se quitó `textContentType(.newPassword)`.
- El teclado numérico no tenía tecla para cerrarse; se agregó un botón «Listo».
- La fila de producto cortaba el texto; se reordenó el costo y el stock.
- Un texto formado con `+` está obsoleto en iOS 26; se pasó a interpolación.

## ¿Usó algo que no hemos visto en clase?

Sí, y conviene saberlo para la presentación:

- **Swift Charts** (`BarMark`, `SectorMark`): es el valor agregado elegido.
- **`@Observable`** para la sesión y **`#Predicate`** con `@Query` en `init` para filtrar.
- **`ContentUnavailableView`**, `swipeActions`, `sensoryFeedback`.

Todo lo demás (SwiftData, `@Model`, `@Query`, relaciones y regla de borrado) es lo visto en
las Actividades 1 y 2 del laboratorio.

## Lo que debo poder explicar

Según el profesor, no se pregunta el código sino la secuencia. Resumen de la secuencia:

1. `ComprasApp` crea el contenedor SwiftData y la sesión.
2. `RaizView` muestra el login si no hay sesión, o las pestañas del rol si la hay.
3. El comprador registra una compra: `ReglasCompra.registrar` calcula el total y, si es menor
   a S/ 5,000, la aprueba al instante (cambia stock y costo promedio); si no, queda pendiente.
4. El supervisor aprueba (efecto en inventario), rechaza (motivo obligatorio) o paga.
5. El Resumen lee las compras aprobadas y las grafica.
