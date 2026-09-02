# Pruebas del plan de pago

## Caso principal

Datos utilizados:

- Producto: Laptop
- Precio unitario: S/. 2500.00
- Cantidad: 2
- Plan seleccionado: 12 cuotas
- Cuotas pagadas: 3

## Resultados esperados

- Monto de compra: S/. 5000.00
- Interés: 40%
- Monto de interés: S/. 2000.00
- Monto final: S/. 7000.00
- Cuota mensual: S/. 583.33
- Cuotas pagadas: 3
- Cuotas pendientes: 9

## Validaciones realizadas

### Plan de 6 cuotas

El sistema asigna un interés de 20%.

### Plan de 12 cuotas

El sistema asigna un interés de 40%.

### Plan de 24 cuotas

El sistema asigna un interés de 60%.

### Plan inválido

Si se introduce una cantidad diferente de 6, 12 o 24, el sistema muestra un mensaje de error.

### Precio inválido

Si el precio es cero o negativo, el sistema impide generar el plan.

### Cantidad inválida

Si la cantidad es cero o negativa, el sistema muestra un mensaje de error.

## Diferencia entre versiones

La versión manual muestra el cálculo y la reducción mensual del saldo.

La versión con IA añade fechas, estado de cuotas, seguimiento de pagos, validaciones y una tabla con mejor presentación.
