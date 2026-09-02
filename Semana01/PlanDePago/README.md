# Ejercicio: Plan de pago

Este ejercicio calcula un plan de financiamiento para un producto utilizando Swift Playground.

## Datos utilizados

- Nombre del producto.
- Precio unitario.
- Cantidad.
- Plan de 6, 12 o 24 cuotas.
- Interés de 20%, 40% o 60%.

## Fórmulas

- Monto de compra = precio unitario × cantidad.
- Monto de interés = monto de compra × porcentaje.
- Monto final = monto de compra + monto de interés.
- Cuota mensual = monto final ÷ cantidad de cuotas.

## Versión manual/base

La versión manual utiliza variables, condicionales, switch y un ciclo for para calcular el plan y mostrar cómo disminuye el saldo después de cada pago.

Archivo:

`PlanDePagoManual.playground`

## Versión mejorada con IA

La versión mejorada incorpora validaciones adicionales, fechas de vencimiento, formato de tabla, estado de cada cuota y una leyenda con la cantidad de cuotas pagadas y pendientes.

Archivo:

`PlanDePagoIA.playground`

## Comparación

| Característica | Manual/base | Con IA |
|---|---|---|
| Validación de 6, 12 y 24 cuotas | Sí | Sí |
| Cálculo de interés | Sí | Sí |
| Cronograma mensual | Sí | Sí |
| Fechas de pago | No | Sí |
| Estado pagada o pendiente | No | Sí |
| Seguimiento de cuotas | No | Sí |
| Columnas alineadas | No | Sí |
