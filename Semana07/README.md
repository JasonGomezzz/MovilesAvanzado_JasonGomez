# Semana 07 – Manejo de Tablas y Colecciones

Laboratorio de **Programación en Móviles Avanzado** (TECSUP) sobre `UITableView` en UIKit.
Cada parte del procedimiento es un proyecto de Xcode independiente dentro de esta carpeta.

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

## Cómo ejecutar

Desde Xcode: abrir `Semana07/Lab07/Lab07.xcodeproj` o `Semana07/Lab07B/Lab07B.xcodeproj`,
elegir un simulador de iPhone con iOS 27 y presionar **Run**.

Desde la terminal:

```bash
xcodebuild -project Semana07/Lab07/Lab07.xcodeproj -scheme Lab07 \
  -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build

xcodebuild -project Semana07/Lab07B/Lab07B.xcodeproj -scheme Lab07B \
  -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

## Cómo probar

1. **Lab07**: deben verse siete filas, cada una con su foto, el nombre y el cargo debajo.
2. **Lab07B**: deben verse cinco filas con la foto a la izquierda y el nombre; al tocar una fila
   aparece la alerta *"El docente que seleccionó es:"* con el nombre de la persona y el botón **OK**.

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
- **Nombre de docente.** En `Lab07B` se quitó el espacio sobrante de `"Silvia Montoya "` del enunciado.
