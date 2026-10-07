# Laboratorio 06 Caso integrador: tienda de electrodomésticos

App UIKit de cinco pantallas en la que el cliente elige productos, arma su carrito,
ingresa sus datos y recibe una boleta. Integra la navegación con segues del
Laboratorio 06, las colecciones del Laboratorio 03 (arrays, condicionales y `switch`)
y las clases del Laboratorio 04.

## Requisitos

- macOS con Xcode 27 (el proyecto compila con un deployment target de iOS 27.0).
- Un simulador de iPhone con iOS 27.

No usa dependencias externas, claves ni archivos de configuración local.

## Ejecución

Abrir `Laboratorio06Integrador.xcodeproj` en Xcode, elegir el esquema
`Laboratorio06Integrador` y ejecutar en un simulador. También se puede compilar desde
la terminal:

```bash
xcodebuild -project Laboratorio06Integrador.xcodeproj -scheme Laboratorio06Integrador \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=27.0' build
```

## Estructura

```
Laboratorio06Integrador/
├── Laboratorio06Integrador.xcodeproj
└── Laboratorio06Integrador/
    ├── Modelos.swift                     Producto, ItemCarrito y CarritoModel (todos los cálculos)
    ├── ClienteModel.swift                cliente del ejercicio 2
    ├── CatalogoViewController.swift      productos, único carrito y segue verDetalle
    ├── DetalleViewController.swift       cantidad con stepper y validación de stock
    ├── CarritoViewController.swift       líneas, descuento, IGV, total y categoría
    ├── DatosClienteViewController.swift  campos obligatorios y DNI de 8 dígitos
    ├── BoletaViewController.swift        boleta modal y confirmación de la compra
    ├── Utilidades.swift                  formato de importes, alertas y textos del carrito
    ├── AppDelegate.swift
    ├── SceneDelegate.swift
    └── Base.lproj/Main.storyboard        Navigation Controller y las cinco pantallas
```

## Flujo y segues

```
Catálogo --Show--> Detalle
   |
   +--Show--> Carrito --Show--> Datos del cliente --Modal--> Boleta
```

| Origen → Destino | Tipo | Identifier | Sale de | Datos que viajan |
|---|---|---|---|---|
| Catálogo → Detalle | Show | `verDetalle` | ícono del View Controller | Producto elegido (por `tag`) y CarritoModel |
| Catálogo → Carrito | Show | `verCarrito` | botón "Ver carrito" | CarritoModel |
| Carrito → Datos del cliente | Show | `irDatosCliente` | ícono del View Controller | CarritoModel |
| Datos del cliente → Boleta | Modal | `verBoleta` | ícono del View Controller | CarritoModel y ClienteModel (en `sender`) |

Los botones de producto (cinco, con `tag` de 0 a 4) comparten la acción
`productoTapped` y el segue `verDetalle`. El `tag` coincide con la posición del
producto en el array `productos`. El carrito se crea una sola vez en el Catálogo y
viaja por `prepare(for:sender:)`, así que todas las pantallas comparten el mismo
objeto `CarritoModel`.

## Reglas de cálculo

Todo vive en `CarritoModel`:

```
subtotal  = suma de (precio x cantidad) de cada línea
descuento = subtotal x 5 % (desde 500) | 10 % (desde 2000) | 15 % (desde 5000)
base      = subtotal - descuento
IGV       = base x 0.18
total     = base + IGV
```

La categoría del cliente sale de un `switch Int(subtotal)`: menos de 500 Regular,
de 500 a 1999 Frecuente, de 2000 a 4999 VIP y desde 5000 Premium.

Validaciones, cada una con un `UIAlertController`: no se agrega más cantidad que el
stock (cuenta lo que ya hay en el carrito), los tres campos del cliente son
obligatorios y el DNI tiene exactamente 8 dígitos. Al confirmar la compra baja el
stock de cada producto y el carrito queda vacío.

## Cómo probar

Cada escenario parte de la app recién abierta:

| # | Acciones | Resultado esperado |
|---|----------|--------------------|
| 1 | Agregar Refrigeradora x1 y Licuadora x2; ir al Carrito | Subtotal S/ 2500.00, descuento 10 % (-S/ 250.00), IGV S/ 405.00, total S/ 2655.00, VIP |
| 2 | Agregar Laptop x1 y Licuadora x1 | Subtotal S/ 3750.00, descuento 10 % (-S/ 375.00), IGV S/ 607.50, total S/ 3982.50, VIP |
| 3 | Abrir Laptop, subir la cantidad a 4 y agregar | Alerta de stock insuficiente y el carrito no cambia |
| 4 | Agregar Licuadora x1 y, en otra visita al Detalle, Licuadora x1 otra vez | El Carrito muestra una sola línea "Licuadora x2" |
| 5 | Confirmar la compra del escenario 1 y cerrar la boleta | Vuelve al Catálogo con "Ver carrito (0)"; el Detalle muestra stock 4 en Refrigeradora y 8 en Licuadora |

También avisan con una alerta: "Finalizar compra" con el carrito vacío, campos vacíos
en Datos del cliente y un DNI que no tenga 8 dígitos.

El stock vive en memoria: al cerrar la app los productos vuelven a sus valores
iniciales.

## Desviaciones respecto al enunciado

- **Cálculos del modelo.** Los TODO A1 a A5 no cubren la regla 5 (subtotal, descuento
  y totales dentro del modelo), así que `CarritoModel` suma `montoDescuento()`,
  `montoConDescuento()`, `igv()`, `total()`, `categoriaCliente()`,
  `cantidadEnCarrito(de:)` y `confirmarCompra()`.
- **Categoría en el Carrito.** El layout del Carrito no la muestra, pero los
  escenarios 1 y 2 piden la categoría, por eso hay una etiqueta extra.
- **Subtotal en la boleta.** El layout de la boleta lo omite y la boleta esperada sí
  lo incluye; se muestra.
- **Stepper sin tope.** No se limita al stock para poder probar el escenario 3
  (Laptop x4). La validación es la del modelo y se avisa con una alerta.
- **Reto 1.** El escenario 5 pide volver al Catálogo, así que "Cerrar" cierra el modal
  y desapila hasta el Catálogo con `popToRootViewController`. La boleta no se puede
  deslizar hacia abajo (`isModalInPresentation`) para que solo se cierre con el
  botón. Los retos 2 y 3 no se hicieron.
- **Compra confirmada al abrir la boleta.** La boleta primero dibuja los datos del
  carrito y recién después llama a `confirmarCompra()`.
- **Carrito vacío.** "Finalizar compra" avisa con una alerta; no está en el
  enunciado, pero evita una boleta de S/ 0.00.
- **Segues desde el View Controller.** Además de `verDetalle`, que lo pide el
  enunciado, `irDatosCliente` y `verBoleta` salen del ícono del View Controller
  para validar antes de navegar.
- **Layout.** Auto Layout con `UIStackView` en lugar de frames fijos. Las líneas del
  carrito son dos etiquetas de varias líneas (producto e importe) dentro de un stack,
  porque la cantidad de líneas cambia.
- **`import UIKit`.** El ejemplo del Catálogo del enunciado no lo trae y sin él no
  compila.
- **Entregable.** El enunciado menciona "6 resultados de la calculadora", que
  corresponde al Ejercicio 4 y no aplica a este caso.
- **Cliente.** `ClienteModel` se reutiliza tal cual del ejercicio 2. Su código es
  fijo (1) porque no hay base de datos.

## Repositorio

https://github.com/JasonGomezzz/MovilesAvanzado_JasonGomez (rama `integrador`)
