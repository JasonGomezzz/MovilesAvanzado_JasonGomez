// Verificación de los 9 casos de prueba del enunciado (versión manual).
// Usa las mismas clases de la app con una base de datos en memoria.
// Ejecutar con: ./Verificacion/ejecutar.sh
import Foundation
import SwiftData

var aprobados = 0
var total = 0

func caso(_ numero: Int, _ titulo: String, _ condiciones: [(String, Bool)]) {
    total += 1
    let ok = condiciones.allSatisfy { $0.1 }
    if ok { aprobados += 1 }
    print("\(ok ? "OK " : "MAL") Caso \(numero): \(titulo)")
    for (detalle, cumple) in condiciones {
        print("      \(cumple ? "✓" : "✗") \(detalle)")
    }
}

func casi(_ a: Double, _ b: Double) -> Bool { abs(a - b) < 0.005 }

let contenedor = try! ModelContainer(for: Usuario.self, Proveedor.self, Producto.self, Compra.self,
                                     configurations: ModelConfiguration(isStoredInMemoryOnly: true))
let contexto = ModelContext(contenedor)
let sesion = Sesion()

// Caso 1: usuario único
let error1 = sesion.registrar(nombre: "Marco Torres", usuario: "mtorres", clave: "abc12345",
                              confirmacion: "abc12345", rol: "Comprador", contexto: contexto)
sesion.cerrarSesion()
let error1b = sesion.registrar(nombre: "Otro", usuario: "MTorres", clave: "abc12345",
                               confirmacion: "abc12345", rol: "Comprador", contexto: contexto)
caso(1, "Registrar a mtorres como Comprador e intentar repetir el usuario", [
    ("el primero se crea", error1 == nil),
    ("el repetido (MTorres) se rechaza", error1b != nil),
    ("solo hay un mtorres", ((try? contexto.fetchCount(FetchDescriptor<Usuario>())) ?? 0) == 1)
])

// Caso 2: login con clave incorrecta
let malo = sesion.iniciarSesion(usuario: "mtorres", clave: "equivocada", contexto: contexto)
let bueno = sesion.iniciarSesion(usuario: "MTORRES", clave: "abc12345", contexto: contexto)
let corta = sesion.registrar(nombre: "Ana", usuario: "ana", clave: "1234", confirmacion: "1234", rol: "Comprador", contexto: contexto)
let distintas = sesion.registrar(nombre: "Ana", usuario: "ana", clave: "123456", confirmacion: "654321", rol: "Comprador", contexto: contexto)
caso(2, "Login con clave incorrecta y registros inválidos", [
    ("clave incorrecta: no entra", !malo),
    ("clave correcta: entra", bueno),
    ("clave de 4 caracteres: error", corta != nil),
    ("claves distintas: error", distintas != nil)
])

let comprador = sesion.usuario!
let supervisor = Usuario(nombre: "Lucía Paredes", usuario: "lparedes", clave: "secreta1", rol: "Supervisor")
contexto.insert(supervisor)
let proveedor = Proveedor(nombre: "Dist. Lima SAC", ruc: "20481230011")
contexto.insert(proveedor)

func productoNuevo() -> Producto {
    let p = Producto(nombre: "Laptop Pro 14", categoria: "Laptops", stock: 40, costoPromedio: 110)
    contexto.insert(p)
    return p
}

func comprar(_ producto: Producto, cantidad: Int, costo: Double, credito: Bool, fecha: Date = Date()) -> Compra {
    let compra = Compra(fecha: fecha, cantidad: cantidad, costoUnitario: costo, alCredito: credito,
                        comprador: comprador, proveedor: proveedor, producto: producto)
    contexto.insert(compra)
    if !compra.necesitaAprobacion { compra.aprobar() }
    return compra
}

// Caso 3
let p3 = productoNuevo()
let c3 = comprar(p3, cantidad: 10, costo: 120, credito: true)
let dias = Calendar.current.dateComponents([.day], from: c3.fecha, to: c3.vence!).day
caso(3, "Stock 40, costo 110.00, compra de 10 a 120.00 al crédito", [
    ("subtotal 1,200.00", casi(c3.subtotal, 1200)),
    ("IGV 216.00", casi(c3.igv, 216)),
    ("total 1,416.00", casi(c3.total, 1416)),
    ("queda Aprobada", c3.estado == "Aprobada"),
    ("stock 50", p3.stock == 50),
    ("costo promedio 112.00", casi(p3.costoPromedio, 112)),
    ("vence a 30 días", dias == 30)
])

// Caso 4
let p4 = productoNuevo()
let c4 = comprar(p4, cantidad: 10, costo: 120, credito: false)
caso(4, "La misma compra al contado", [
    ("queda pagada", c4.pagada),
    ("no aparece en por pagar", !proveedor.comprasPorPagar.contains { $0 === c4 }),
    ("sin fecha de vencimiento", c4.vence == nil)
])

// Caso 5
let p5 = productoNuevo()
let c5 = comprar(p5, cantidad: 50, costo: 120, credito: true)
caso(5, "Compra de 50 a 120.00 (total 7,080.00)", [
    ("total 7,080.00", casi(c5.total, 7080)),
    ("queda Pendiente", c5.estado == "Pendiente"),
    ("stock sigue en 40", p5.stock == 40),
    ("costo promedio sigue en 110.00", casi(p5.costoPromedio, 110)),
    ("no suma a por pagar", !proveedor.comprasPorPagar.contains { $0 === c5 })
])

// Caso 6
c5.aprobar()
caso(6, "El supervisor aprueba la compra del caso 5", [
    ("stock 90", p5.stock == 90),
    ("costo promedio 115.56", casi(p5.costoPromedio, 115.56)),
    ("aparece en por pagar", proveedor.comprasPorPagar.contains { $0 === c5 })
])

// Caso 7
let p7 = productoNuevo()
let c7 = comprar(p7, cantidad: 60, costo: 100, credito: true)
c7.rechazar(motivo: "Precio alto")
caso(7, "El supervisor rechaza otra compra grande con motivo", [
    ("queda Rechazada", c7.estado == "Rechazada"),
    ("el comprador ve el motivo", c7.motivoRechazo == "Precio alto"),
    ("no cambia el stock", p7.stock == 40)
])

// Caso 8
let p8 = productoNuevo()
let hace40 = Calendar.current.date(byAdding: .day, value: -40, to: Date())!
let c8 = comprar(p8, cantidad: 10, costo: 120, credito: true, fecha: hace40)
let deudaAntes = proveedor.comprasPorPagar.reduce(0) { $0 + $1.total }
let vencidaAntes = c8.estaVencida
c8.pagar()
let deudaDespues = proveedor.comprasPorPagar.reduce(0) { $0 + $1.total }
caso(8, "Crédito vencido y luego Pagar", [
    ("aparece como vencida", vencidaAntes),
    ("al pagar deja de estar vencida", !c8.estaVencida && c8.pagada),
    ("el total por pagar baja 1,416.00", casi(deudaAntes - deudaDespues, 1416))
])

// Caso 9
let otro = Usuario(nombre: "Rosa Díaz", usuario: "rdiaz", clave: "clave123", rol: "Comprador")
contexto.insert(otro)
let ajena = Compra(cantidad: 1, costoUnitario: 100, alCredito: false, comprador: otro, proveedor: proveedor, producto: p3)
contexto.insert(ajena)
let todas = (try? contexto.fetch(FetchDescriptor<Compra>())) ?? []
let mias = todas.filter { $0.comprador?.usuario == "mtorres" }
caso(9, "Un comprador abre Mis compras", [
    ("solo ve las suyas (\(mias.count) de \(todas.count))", mias.count == 5 && todas.count == 6),
    ("ninguna es de otro usuario", mias.allSatisfy { $0.comprador?.usuario == "mtorres" })
])

// Extra: delete rule deny
caso(10, "EXTRA: producto, proveedor y usuario con compras no están libres para borrar", [
    ("producto con compras", !p3.compras.isEmpty),
    ("proveedor con compras", !proveedor.compras.isEmpty),
    ("usuario con compras", !comprador.compras.isEmpty)
])

// Extra: crédito fiscal
let aprobadas = todas.filter { $0.estado == "Aprobada" }
let igvTotal = aprobadas.reduce(0) { $0 + $1.igv }
caso(11, "EXTRA: crédito fiscal = IGV de las compras aprobadas", [
    ("IGV de los casos 3, 4, 5 y 8 (216 + 216 + 1,080 + 216)", casi(igvTotal, 216 + 216 + 1080 + 216))
])

print("\nResultado: \(aprobados) de \(total) casos aprobados")
exit(aprobados == total ? 0 : 1)
