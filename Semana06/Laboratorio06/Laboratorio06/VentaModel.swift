//
//  VentaModel.swift
//  Laboratorio06
//
//  Created by Jason on 06/10/26.
//

import UIKit

// Es class (y no struct) igual que ClienteModel: la pantalla Resultado recibe
// la misma referencia que arma Nueva Venta, sin copiar el valor.
class VentaModel: NSObject {
    var subtotal: Double = 0
    var igv: Double = 0
    var base: Double = 0
    var intereses: Double = 0
    var total: Double = 0
    var cuota: Double = 0

    override init() {
        self.subtotal = 0
        self.igv = 0
        self.base = 0
        self.intereses = 0
        self.total = 0
        self.cuota = 0
    }

    init(pSubtotal: Double, pIgv: Double, pBase: Double, pIntereses: Double, pTotal: Double, pCuota: Double) {
        self.subtotal = pSubtotal
        self.igv = pIgv
        self.base = pBase
        self.intereses = pIntereses
        self.total = pTotal
        self.cuota = pCuota
    }
}
