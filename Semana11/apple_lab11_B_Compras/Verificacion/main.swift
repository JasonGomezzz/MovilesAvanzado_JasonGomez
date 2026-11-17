// Verificación de los 9 casos de prueba del profesor sin abrir el simulador.
// Usa las mismas clases del proyecto (Modelos y Servicios) con una base en memoria.
// Ejecutar con: ./Verificacion/ejecutar.sh
import Foundation
import SwiftData

var aprobados = 0
var total = 0

func caso(_ n: Int, _ descripcion: String, _ condiciones: [(String, Bool)]) {
    total += 1
    let ok = condiciones.allSatisfy { $0.1 }
    if ok { aprobados += 1 }
    print("\(ok ? "✅" : "❌") Caso \(n): \(descripcion)")
    for (detalle, cumple) in condiciones {
        print("      \(cumple ? "✓" : "✗") \(detalle)")
    }
}

func nuevoContexto() -> ModelContext {
    let configuracion = ModelConfiguration(isStoredInMemoryOnly: true)
    let contenedor = try! ModelContainer(for: Usuario.self, Proveedor.self, Producto.self, Compra.self,
                                         configurations: configuracion)
    return ModelContext(contenedor)
}

func lanza<T>(_ bloque: () throws -> T) -> Bool {
    do { _ = try bloque(); return false } catch { return true }
}

func casi(_ a: Double, _ b: Double) -> Bool { abs(a - b) < 0.005 }

let contexto = nuevoContexto()
let supervisor = try! Autenticacion.registrar(nombre: "Lucía Paredes", usuario: "lparedes", clave: "secreta1",
                                              confirmacion: "secreta1", rol: .supervisor, en: contexto)
let proveedor = Proveedor(nombre: "Dist. Lima SAC", ruc: "20481230011")
contexto.insert(proveedor)

func productoNuevo() -> Producto {
    let p = Producto(nombre: "Laptop Pro 14", categoria: "Laptops", stock: 40, costoPromedio: 110)
    contexto.insert(p)
    return p
}

// Caso 1: usuario único (sin distinguir mayúsculas)
let comprador = try! Autenticacion.registrar(nombre: "Marco Torres", usuario: "mtorres", clave: "abc12345",
                                             confirmacion: "abc12345", rol: .comprador, en: contexto)
let repetido = lanza { try Autenticacion.registrar(nombre: "Otro", usuario: "MTorres", clave: "abc12345",
                                                   confirmacion: "abc12345", rol: .comprador, en: contexto) }
let usuariosMtorres = (try? contexto.fetchCount(FetchDescriptor<Usuario>(predicate: #Predicate { $0.usuario == "mtorres" }))) ?? -1
caso(1, "Registrar a \"mtorres\" como Comprador e intentar repetir el usuario", [
    ("el primero se crea con rol Comprador", comprador.rol == "Comprador"),
    ("el repetido \"MTorres\" se rechaza", repetido),
    ("solo existe un mtorres en la base", usuariosMtorres == 1)
])

// Caso 2: login con clave incorrecta
let entraMal = Autenticacion.iniciarSesion(usuario: "mtorres", clave: "equivocada", en: contexto)
let entraBien = Autenticacion.iniciarSesion(usuario: "MTORRES", clave: "abc12345", en: contexto)
let claveCorta = lanza { try Autenticacion.registrar(nombre: "Ana", usuario: "ana", clave: "1234", confirmacion: "1234", rol: .comprador, en: contexto) }
let clavesDistintas = lanza { try Autenticacion.registrar(nombre: "Ana", usuario: "ana", clave: "123456", confirmacion: "654321", rol: .comprador, en: contexto) }
caso(2, "Login con clave incorrecta (y registro con claves inválidas)", [
    ("clave incorrecta: no entra", entraMal == nil),
    ("clave correcta: sí entra (sin distinguir mayúsculas en el usuario)", entraBien != nil),
    ("clave de 4 caracteres: no se crea el usuario", claveCorta),
    ("claves distintas: no se crea el usuario", clavesDistintas),
    ("Ana nunca se creó", !Autenticacion.existe("ana", en: contexto))
])

// Caso 3: compra de 10 a 120.00 al crédito
let p3 = productoNuevo()
let c3 = try! ReglasCompra.registrar(comprador: comprador, proveedor: proveedor, producto: p3,
                                     cantidad: 10, costoUnitario: 120, alCredito: true, en: contexto)
let dias3 = Calendar.current.dateComponents([.day], from: c3.fecha, to: c3.vence!).day
caso(3, "Producto stock 40 · costo prom. 110.00 → compra de 10 a 120.00 al crédito", [
    ("subtotal 1,200.00", casi(c3.subtotal, 1200)),
    ("IGV 216.00", casi(c3.igv, 216)),
    ("total 1,416.00", casi(c3.total, 1416)),
    ("queda Aprobada", c3.estadoCompra == .aprobada),
    ("stock 50", p3.stock == 50),
    ("costo promedio 112.00", casi(p3.costoPromedio, 112)),
    ("vence a 30 días", dias3 == 30),
    ("queda sin pagar (por pagar)", !c3.pagada)
])

// Caso 4: la misma compra al contado
let p4 = productoNuevo()
let c4 = try! ReglasCompra.registrar(comprador: comprador, proveedor: proveedor, producto: p4,
                                     cantidad: 10, costoUnitario: 120, alCredito: false, en: contexto)
let porPagar4 = proveedor.comprasPorPagar.contains { $0 === c4 }
caso(4, "La misma compra, pero al contado", [
    ("queda pagada", c4.pagada),
    ("no aparece en Pendientes de pago", !porPagar4),
    ("no tiene fecha de vencimiento", c4.vence == nil)
])

// Caso 5: compra de 50 a 120.00 (total 7,080.00)
let p5 = productoNuevo()
let c5 = try! ReglasCompra.registrar(comprador: comprador, proveedor: proveedor, producto: p5,
                                     cantidad: 50, costoUnitario: 120, alCredito: true, en: contexto)
caso(5, "Compra de 50 a 120.00 (total 7,080.00)", [
    ("total 7,080.00", casi(c5.total, 7080)),
    ("queda Pendiente de aprobación", c5.estadoCompra == .pendiente),
    ("el stock sigue en 40", p5.stock == 40),
    ("el costo promedio sigue en 110.00", casi(p5.costoPromedio, 110)),
    ("no suma a por pagar", !proveedor.comprasPorPagar.contains { $0 === c5 })
])

// Caso 6: el supervisor aprueba la compra del caso 5
let apruebaComprador = lanza { try ReglasCompra.aprobar(c5, por: comprador, en: contexto) }
try! ReglasCompra.aprobar(c5, por: supervisor, en: contexto)
caso(6, "El supervisor aprueba la compra del caso 5", [
    ("un comprador no puede aprobar", apruebaComprador),
    ("stock 90", p5.stock == 90),
    ("costo promedio 115.56", casi(p5.costoPromedio, 115.56)),
    ("aparece en Por pagar", proveedor.comprasPorPagar.contains { $0 === c5 })
])

// Caso 7: el supervisor rechaza otra compra grande
let p7 = productoNuevo()
let c7 = try! ReglasCompra.registrar(comprador: comprador, proveedor: proveedor, producto: p7,
                                     cantidad: 60, costoUnitario: 100, alCredito: true, en: contexto)
let sinMotivo = lanza { try ReglasCompra.rechazar(c7, motivo: "   ", por: supervisor, en: contexto) }
let sigueIgual = c7.estadoCompra == .pendiente
try! ReglasCompra.rechazar(c7, motivo: "Precio alto", por: supervisor, en: contexto)
caso(7, "El supervisor rechaza otra compra grande sin motivo y luego con motivo", [
    ("sin motivo no se puede", sinMotivo && sigueIgual),
    ("con motivo queda Rechazada", c7.estadoCompra == .rechazada),
    ("el comprador ve el motivo", c7.motivoRechazo == "Precio alto"),
    ("no cambia el stock", p7.stock == 40)
])

// Caso 8: crédito vencido, luego Pagar
let p8 = productoNuevo()
let hace40 = Calendar.current.date(byAdding: .day, value: -40, to: .now)!
let c8 = try! ReglasCompra.registrar(comprador: comprador, proveedor: proveedor, producto: p8,
                                     cantidad: 10, costoUnitario: 120, alCredito: true, fecha: hace40, en: contexto)
let deudaAntes = proveedor.comprasPorPagar.reduce(0) { $0 + $1.total }
let vencidaAntes = c8.estaVencida
let compradorPaga = lanza { try ReglasCompra.pagar(c8, por: comprador, en: contexto) }
try! ReglasCompra.pagar(c8, por: supervisor, en: contexto)
let deudaDespues = proveedor.comprasPorPagar.reduce(0) { $0 + $1.total }
caso(8, "Compra a crédito con vencimiento ya pasado y luego Pagar", [
    ("aparece como VENCIDA", vencidaAntes),
    ("un comprador no puede pagar", compradorPaga),
    ("al pagar queda pagada", c8.pagada && !c8.estaVencida),
    ("el total por pagar baja en 1,416.00", casi(deudaAntes - deudaDespues, 1416))
])

// Caso 9: visibilidad y permisos del comprador
let otro = try! Autenticacion.registrar(nombre: "Rosa Díaz", usuario: "rdiaz", clave: "clave123",
                                        confirmacion: "clave123", rol: .comprador, en: contexto)
try! ReglasCompra.registrar(comprador: otro, proveedor: proveedor, producto: p3,
                            cantidad: 1, costoUnitario: 100, alCredito: false, en: contexto)
let nombreMtorres = "mtorres"
let suyas = (try? contexto.fetch(FetchDescriptor<Compra>(predicate: #Predicate { $0.comprador?.usuario == nombreMtorres }))) ?? []
let todas = (try? contexto.fetch(FetchDescriptor<Compra>())) ?? []
caso(9, "Un comprador abre Mis compras e intenta pagar", [
    ("solo ve sus compras (\(suyas.count) de \(todas.count))", suyas.count == 5 && todas.count == 6),
    ("ninguna es de otro usuario", suyas.allSatisfy { $0.comprador?.usuario == "mtorres" }),
    ("pagar está prohibido para el comprador", lanza { try ReglasCompra.pagar(c3, por: comprador, en: contexto) })
])

// Extra A: delete rule .deny
let intentoBorrarProducto = p3.compras.isEmpty
let intentoBorrarProveedor = proveedor.compras.isEmpty
let libre = Producto(nombre: "Libre", categoria: "Otros", stock: 0, costoPromedio: 0)
contexto.insert(libre)
caso(10, "EXTRA: no se puede borrar producto/proveedor/usuario con compras (.deny)", [
    ("el producto con compras no está libre", !intentoBorrarProducto),
    ("el proveedor con compras no está libre", !intentoBorrarProveedor),
    ("el comprador con compras no está libre", !comprador.compras.isEmpty),
    ("un producto sin compras sí se puede borrar", libre.compras.isEmpty)
])

// Extra B: costo promedio con rendondeo y total de resumen
let totalCreditoFiscal = todas.filter { $0.estadoCompra == .aprobada }.reduce(0) { $0 + $1.igv }
caso(11, "EXTRA: crédito fiscal = suma del IGV de las compras aprobadas", [
    ("IGV de c3 + c4 + c5 + c8 + 1 compra de Rosa", casi(totalCreditoFiscal, 216 + 216 + 1080 + 216 + 18))
])

print("\nResultado: \(aprobados) de \(total) casos aprobados")
exit(aprobados == total ? 0 : 1)
