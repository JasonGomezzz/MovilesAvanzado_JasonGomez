# Semana 13 · Consumir una API desde SwiftUI

Laboratorio 13 de Programación en Móviles Avanzados. Las tres apps consumen `https://jsonplaceholder.typicode.com/users` con MVVM (`Models/`, `View/`, `ViewModels/`).

| Carpeta | Actividad | Qué hace |
|---|---|---|
| `Semana13_ConsumoAPI` | 01 | GET de usuarios con `dataTask` y filtro por nombre (`searchText` + `filteredUsers`) |
| `Semana13_MetodosAPI` | 02 | GET, POST, PUT y DELETE con `dataTask`, formulario `UserFormView` validado |
| `Semana13_MetodosAPI_Async` | 03 | Los mismos métodos con `URLSession.shared.data` y `async/await` |

## Cómo ejecutar

1. Abrir el `.xcodeproj` de la actividad en Xcode 27 o superior.
2. Elegir un simulador con iOS 26 o superior (las capturas son del iPhone 18 Pro, iOS 27.2).
3. Ejecutar con `Cmd + R`. Se necesita internet porque los datos vienen de la API.

Las reglas del formulario (actividades 02 y 03) se pueden probar sin simulador:

```bash
./Semana13/Semana13_MetodosAPI/Verificacion/ejecutar.sh
```

Debe terminar con `Resultado: 20 correctos, 0 con falla`.

## Reglas del formulario

- Nombre y apellido reales: sin números ni símbolos, sin texto de relleno (`xxx`, `test`, `asdf`), sin letras repetidas tres veces y con máximo 60 caracteres.
- Correo con forma `nombre@dominio.ext`, que no sea de prueba (`test@test.com`) y que no lo use otro usuario.
- Al editar, Guardar se activa solo si cambió algo.

## Detalles de la API

JSONPlaceholder responde como si guardara, pero no guarda nada:

- Todo POST devuelve `id 11`. Si ese id ya está en la lista, la app usa el siguiente libre para no repetir filas.
- Un PUT o DELETE a un usuario creado en la app daría error 500, por eso esos usuarios se editan y se borran solo en la app (la tarjeta "Última petición" lo indica).

## Cambios respecto al enunciado

- `import Combine` en los ViewModels: sin eso el código del enunciado no compila en Xcode 27.
- `NavigationStack`, `.toolbar`, `@Environment(\.dismiss)` y `.foregroundStyle` en vez de las APIs obsoletas.
- `.searchable` como buscador, enlazado al mismo `searchText`.
- Los errores se muestran en pantalla en vez de solo hacer `print`.
- En las actividades 01 y 02 se mantiene `dataTask` porque las preguntas tratan sobre `resume()` y `DispatchQueue`.
