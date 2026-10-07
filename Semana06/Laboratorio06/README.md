# Laboratorio 06 Calculadora de venta a plazos

App UIKit de dos pantallas que calcula la venta a plazos de un electrodoméstico.
Refuerza el paso de datos entre pantallas con un modelo propio (`VentaModel`) y un
segue Show con identifier `showResultado`.

## Requisitos

- macOS con Xcode 27 (el proyecto compila con un deployment target de iOS 27.0).
- Un simulador de iPhone con iOS 27.

No usa dependencias externas, claves ni archivos de configuración local.

## Ejecución

Abrir `Laboratorio06.xcodeproj` en Xcode, elegir el esquema `Laboratorio06` y
ejecutar en un simulador. También se puede compilar desde la terminal:

```bash
xcodebuild -project Laboratorio06.xcodeproj -scheme Laboratorio06 \
  -destination 'platform=iOS Simulator,name=iPhone 17' build
```

## Estructura

```
Laboratorio06/
├── Laboratorio06.xcodeproj
└── Laboratorio06/
    ├── VentaModel.swift                 modelo con las seis salidas del cálculo
    ├── NuevaVentaViewController.swift   lectura de campos, cálculo y prepare(for:sender:)
    ├── ResultadoViewController.swift    muestra los valores formateados en soles
    ├── AppDelegate.swift
    ├── SceneDelegate.swift
    └── Base.lproj/Main.storyboard       Navigation Controller, Nueva Venta y Resultado
```

## Pantallas

**Nueva Venta** tiene cinco `UITextField` (electrodoméstico, precio unitario,
cantidad, meses e interés mensual en %), un botón "Calcular" y una etiqueta para
avisos. El botón tiene un segue Show hacia Resultado con identifier `showResultado`.

**Resultado** tiene seis `UILabel` con subtotal, IGV, base, intereses, total y
cuota mensual. Cada valor se muestra con `String(format: "S/. %.2f", valor)`.

## Fórmulas

```
subtotal  = precioUnitario x cantidad
igv       = subtotal x 0.18
base      = subtotal + igv
intereses = base x (tasaInteresMensual / 100) x meses
total     = base + intereses
cuota     = total / meses
```

`VentaModel` es una `class` (subclase de `NSObject`), igual que `ClienteModel` del
laboratorio anterior. La pantalla Resultado recibe la misma referencia que arma
Nueva Venta en `prepare(for:sender:)`, sin copiar el valor.

## Cómo probar

| Caso | Entrada | Resultado esperado |
|------|---------|--------------------|
| Ejemplo del enunciado | Refrigeradora, 3500, 1, 12 meses, 1 % | Subtotal 3500.00, IGV 630.00, base 4130.00, intereses 495.60, total 4625.60, cuota 385.47 |
| Campos vacíos | Todo vacío | No navega y muestra el aviso en rojo |
| Meses en cero | Meses = 0 | No navega y muestra el aviso en rojo |

## Desviaciones respecto al enunciado

- **Validación de los datos.** El enunciado no la pide, pero con un campo vacío o
  con 0 meses la cuota divide entre cero. Se valida en
  `shouldPerformSegue(withIdentifier:sender:)`, que impide el segue y muestra un
  aviso. El segue sigue saliendo del botón "Calcular" con el identifier pedido.
- **Etiqueta de aviso.** Se agregó un `UILabel` extra (`lblError`) en Nueva Venta
  para mostrar el mensaje de validación.
- **Tipos de entrada.** Cantidad y meses se leen como enteros; precio e interés
  como `Double`. Los teclados numéricos de cada campo se configuran en el storyboard.
- **Nombre del electrodoméstico.** Es obligatorio, pero no forma parte de
  `VentaModel`, porque el enunciado define solo las seis salidas del cálculo.
- **Layout.** Las pantallas usan Auto Layout con `UIStackView` en lugar de frames
  fijos, para que se adapten a distintos tamaños de iPhone.

## Repositorio

https://github.com/JasonGomezzz/MovilesAvanzado_JasonGomez (rama `ai-assisted`)
