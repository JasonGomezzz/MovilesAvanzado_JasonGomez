# Compras Tecsup · Laboratorio 11 · Caso B

App de compras en **SwiftUI + SwiftData** con inicio de sesión y dos roles:
el **comprador** registra compras y el **supervisor** las aprueba, rechaza o paga.
Esta es la versión simple de la rama `manual`, escrita al estilo de la Actividad 02.

## Cómo ejecutarla

1. Abrir `apple_lab11_B_Compras.xcodeproj` en Xcode.
2. Elegir un iPhone del simulador y pulsar Run.
3. Crear una cuenta de **Supervisor** y otra de **Comprador** desde «Crear cuenta».
   El catálogo (4 productos y 3 proveedores) se carga solo la primera vez.
4. Opcional: menú del avatar ▸ «Cargar compras de ejemplo» (solo supervisor).

Para repetir los casos desde cero, borrar la app del simulador.

## Roles

| Rol | Pestañas |
| --- | --- |
| Comprador | Productos · Proveedores · Compra · Mis compras |
| Supervisor | Resumen · Aprobar · Por pagar · Productos · Proveedores |

## Reglas de negocio

- IGV 18 %: `total = subtotal + subtotal × 0.18`, redondeado a céntimos.
- Total menor a S/ 5,000 queda **Aprobada**; de S/ 5,000 en adelante queda **Pendiente**
  hasta que el supervisor la apruebe.
- Al aprobar: `stock += cantidad` y costo promedio ponderado
  `(stock × costo + cantidad × costoUnitario) ÷ (stock + cantidad)`.
- Crédito a 30 días: vence a los 30 días y queda por pagar hasta que el supervisor la paga.
- El rechazo exige un motivo, que el comprador ve en «Mis compras».
- Un producto, proveedor o usuario con compras no se puede borrar (`.deny`).

## Valor agregado

Resumen del supervisor con **Swift Charts** (total por proveedor y compras por mes)
y vista previa del efecto antes de aprobar una compra.

## Verificar las reglas sin abrir el simulador

```bash
./Verificacion/ejecutar.sh
```

Ejecuta los 9 casos del enunciado y 2 propios contra las clases reales de la app
con una base de datos en memoria (resultado esperado: 11 de 11).

## Estructura

```
apple_lab11_B_Compras/
├── Modelos/                 Usuario, Proveedor, Producto, Compra (con sus reglas)
├── Vistas/                  Las pantallas B1 a B9, MenuAvatar y Ayudas
├── Sesion.swift             Registro, login y usuario de la sesión
├── ModelContainerProvider   Contenedor SwiftData (singleton)
├── DatosIniciales.swift     Catálogo inicial y compras de ejemplo
├── ContentView.swift        Login o pestañas según el rol
└── Verificacion/            Verificador de casos de prueba
```
