# Semana 07 – Manejo de Tablas y Colecciones

Laboratorio de **Programación en Móviles Avanzado** (TECSUP) sobre `UITableView` en UIKit.
Cada parte del procedimiento y el caso a desarrollar son proyectos de Xcode independientes dentro de esta carpeta.

Repositorio: <https://github.com/JasonGomezzz/MovilesAvanzado_JasonGomez>

## Requisitos

- macOS con Xcode (el proyecto usa `IPHONEOS_DEPLOYMENT_TARGET = 27.0`)
- Simulador de iOS 27 o superior
- Lenguaje: Swift 5, UIKit con Storyboard

## Estructura

| Carpeta | Parte del laboratorio | Qué muestra |
| --- | --- | --- |
| `Lab07/` | A. Crear un proyecto usando `UITableView` | Lista de docentes de TECSUP con foto, nombre y cargo en una celda estilo *Subtitle* |
| `Lab07B/` | B. Personalizar un `TableView` | Celda personalizada con imagen y nombre, y alerta al seleccionar una fila |
| `Lab07Culturas/` | Caso a desarrollar | Explorador de culturas peruanas: lista con imagen y nombre, y vista de detalle con región y descripción |

### `Lab07` – Lista de docentes

```
Lab07/Lab07/
├── Profesor.swift          Modelo: nombre, cargo y foto (UIImage)
├── ViewController.swift    DataSource y Delegate de la tabla, lista listaProfesores
└── Base.lproj/Main.storyboard   TableView con la celda prototipo "celda" (Subtitle)
```

- `Profesor` es un `NSObject` con `nombre`, `cargo` y `foto`.
- `ViewController` implementa `UITableViewDelegate` y `UITableViewDataSource`:
  `numberOfRowsInSection` devuelve `listaProfesores.count` y `cellForRowAt` reutiliza la celda
  con identificador `celda` mostrando nombre, cargo y foto.
- Los siete avatares (`avatar1` … `avatar7`) están en `Assets.xcassets`; cada docente usa uno distinto.

### `Lab07B` – TableView personalizado

```
Lab07B/Lab07B/
├── PersonasTableViewCell.swift   Celda con los outlets PersonaImagen y personaNombre
├── ViewController.swift          Arreglos personasArreglo / personasImagenarreglo, DataSource y Delegate
└── Base.lproj/Main.storyboard    TableView con la celda prototipo "miCell" (UIImageView + UILabel)
```

- La celda `miCell` es de la clase `PersonasTableViewCell`; su imagen mide 80 × 80 y el nombre
  queda a la derecha, centrado verticalmente con Auto Layout.
- `didSelectRowAt` abre un `UIAlertController` con el nombre del docente seleccionado y un botón **OK**.

### `Lab07Culturas` – Explorador de culturas peruanas

```
Lab07Culturas/Lab07Culturas/
├── Cultura.swift                        Modelo: nombre, región, descripción e imagen
├── Cultura+Datos.swift                  Cultura.todas: las ocho culturas (fuente única de datos)
├── CulturaTableViewCell.swift           Celda con imagen, nombre y región
├── CulturasViewController.swift         Pantalla 1: lista y prepare(for:) del segue
├── DetalleCulturaViewController.swift   Pantalla 2: detalle de la cultura
└── Base.lproj/Main.storyboard           Navigation Controller → Lista → (segue show) → Detalle
```

**Flujo entre pantallas**

1. El *Navigation Controller* es el controlador inicial y tiene como raíz la lista.
2. El segue `verCultura` (tipo *show*) sale de la **celda prototipo** hacia el detalle, así que tocar
   cualquier fila navega sin escribir código de navegación.
3. En `prepare(for:sender:)` de la lista, el `sender` es la celda tocada: con
   `tableView.indexPath(for:)` se obtiene la fila y se asigna `destino.cultura = culturas[fila]`.
4. El detalle recibe la cultura **antes** de `viewDidLoad` (los `IBOutlet` aún son `nil`), por eso
   solo la guarda y llena los controles en `viewDidLoad`.
5. El botón *Culturas* para regresar lo pone el Navigation Controller.

**Para agregar una cultura:** agregar un elemento en `Cultura.todas` y un imageset en `Assets.xcassets`
con el mismo nombre que `imagen`. La lista y el detalle no necesitan cambios.

**Decisiones de diseño**

- `Cultura` es un `struct`: son datos de solo lectura y el detalle recibe su propia copia.
- El modelo guarda el nombre de la imagen y no la `UIImage`, para no depender de UIKit.
- El detalle va dentro de un `UIScrollView` con un `UIStackView`: las descripciones largas o el texto
  grande de accesibilidad (Dynamic Type) se desplazan en lugar de cortarse.
- Colores y fuentes del sistema, por lo que funciona en modo claro y oscuro.

## Cómo ejecutar

Desde Xcode: abrir `Semana07/Lab07/Lab07.xcodeproj`, `Semana07/Lab07B/Lab07B.xcodeproj` o
`Semana07/Lab07Culturas/Lab07Culturas.xcodeproj`,
elegir un simulador de iPhone con iOS 27 y presionar **Run**.

Desde la terminal:

```bash
xcodebuild -project Semana07/Lab07/Lab07.xcodeproj -scheme Lab07 \
  -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build

xcodebuild -project Semana07/Lab07B/Lab07B.xcodeproj -scheme Lab07B \
  -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build

xcodebuild -project Semana07/Lab07Culturas/Lab07Culturas.xcodeproj -scheme Lab07Culturas \
  -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

## Cómo probar

1. **Lab07**: deben verse siete filas, cada una con su foto, el nombre y el cargo debajo.
2. **Lab07B**: deben verse cinco filas con la foto a la izquierda y el nombre; al tocar una fila
   aparece la alerta *"El docente que seleccionó es:"* con el nombre de la persona y el botón **OK**.
3. **Lab07Culturas**: deben verse ocho culturas con su imagen, nombre y región. Al tocar una fila se
   abre el detalle con la imagen, el nombre, la región y la descripción de esa cultura; el botón
   *Culturas* de la barra regresa a la lista.

## Desviaciones respecto al enunciado

- **Parte B como proyecto aparte.** El documento crea una aplicación nueva (`Semana07_B`); aquí es
  `Lab07B`, con su propio *scheme* compartido, para poder ejecutar cada parte por separado.
- **Celda sin desempaquetado forzado.** En `Lab07B` se usa `guard let … as? PersonasTableViewCell`
  en lugar de `cell!`, y en `Lab07` la foto se asigna sin `!`, para evitar un cierre inesperado
  si falta un avatar.
- **Texto de la alerta corregido.** El enunciado muestra *"El Docente que Selecciono es  :"*;
  se escribió *"El docente que seleccionó es:"*.
- **Avatares distintos.** El enunciado repite `avatar4` y `avatar2` para dos docentes; como se
  descargaron siete imágenes, Elliot Garamendi usa `avatar6` y Edwin Huerto `avatar7`.
- **Avatares según el nombre.** Con las imágenes descargadas, `avatar3` es un hombre y `avatar5` una mujer;
  por eso Silvia Montoya usa `avatar5` (en `Lab07`, Theobaldo Diaz usa `avatar3`; en `Lab07B`, Elliot Garamendi usa `avatar3`).
- **Nombre de docente.** En `Lab07B` se quitó el espacio sobrante de `"Silvia Montoya "` del enunciado.
- **Imágenes de las culturas.** Son ilustraciones propias generadas con un script (no son fotografías).
  Para usar fotos reales basta reemplazar el PNG dentro de cada imageset de `Lab07Culturas`,
  manteniendo el nombre del imageset.
