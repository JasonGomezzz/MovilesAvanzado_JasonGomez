# Actividad 02 Clientes bancarios

## Descripción

Esta actividad representa los datos de clientes bancarios mediante una clase
base y dos clases especializadas. La solución aplica herencia, sobrescritura de
métodos y polimorfismo para mostrar clientes naturales y jurídicos utilizando
un solo recorrido.

El archivo ejecutable es `Actividad02.swift` y funciona de manera independiente
del Playground general del laboratorio.

## Requerimientos funcionales

1. RF01 Registrar el código único de cada cliente.
2. RF02 Registrar dirección, fecha de registro y número de cuenta.
3. RF03 Registrar el monto mínimo requerido para abrir la cuenta.
4. RF04 Registrar nombre completo y DNI para un cliente natural.
5. RF05 Registrar razón social, RUC y representante para un cliente jurídico.
6. RF06 Reutilizar los datos comunes mediante una clase base `Cliente`.
7. RF07 Inicializar los datos heredados desde las clases especializadas.
8. RF08 Mostrar los datos particulares del cliente natural.
9. RF09 Mostrar los datos particulares del cliente jurídico.
10. RF10 Sobrescribir `mostrarDatos()` según el tipo real del cliente.
11. RF11 Almacenar clientes naturales y jurídicos en un arreglo `[Cliente]`.
12. RF12 Recorrer todos los clientes con un solo `for-in` y mostrar el monto de
    apertura con dos decimales.

## Cumplimiento de los requerimientos

- `Cliente` conserva código, dirección, fecha, cuenta y monto de apertura.
- `ClienteNatural` agrega nombre completo y DNI.
- `ClienteJuridico` agrega razón social, RUC y representante legal.
- Los inicializadores especializados llaman a `super.init`.
- Ambas subclases usan `override func mostrarDatos()`.
- Cada implementación especializada llama a `super.mostrarDatos()` para evitar
  duplicar la presentación de los datos comunes.
- El arreglo `[Cliente]` reúne objetos de los dos tipos.
- El `for-in` demuestra polimorfismo mediante una única llamada a
  `cliente.mostrarDatos()`.

## Datos utilizados

Cliente natural:

- Nombre: Juan Pérez.
- DNI: 12345678.
- Código: C001.
- Cuenta: 001-2025-000123.
- Monto mínimo: S/ 500.00.

Cliente jurídico:

- Razón social: Soluciones SAC.
- RUC: 20123456789.
- Representante legal: María León.
- Código: C002.
- Cuenta: 001-2025-000456.
- Monto mínimo: S/ 3000.00.

## Resultado esperado

La ejecución debe mostrar primero al cliente natural y después al cliente
jurídico. Los montos mínimos deben aparecer de esta forma:

```text
Monto mínimo de apertura: S/ 500.00
Monto mínimo de apertura: S/ 3000.00
```

## Abrir el código con nano

Desde Terminal:

```bash
cd "/Users/jason/Dev/MovilesAvanzado_JasonGomez/Semana04/Lab04-POO/Actividad02"
nano Actividad02.swift
```

Dentro de `nano` se puede recorrer todo el código con las flechas. Para salir
sin modificarlo se presiona `Control + X`.

## Ejecutar desde Terminal

```bash
cd "/Users/jason/Dev/MovilesAvanzado_JasonGomez/Semana04/Lab04-POO/Actividad02"
swift Actividad02.swift
```

La ejecución debe mostrar los dos tipos de cliente sin errores.

## Clases utilizadas

- `Cliente`: contiene los datos comunes y el método base.
- `ClienteNatural`: especializa los datos de una persona.
- `ClienteJuridico`: especializa los datos de una empresa.
