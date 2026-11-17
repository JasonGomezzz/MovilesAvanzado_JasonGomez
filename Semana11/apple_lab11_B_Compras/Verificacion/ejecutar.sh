#!/bin/zsh
# Compila las reglas de negocio de la app junto con main.swift y las ejecuta en la Mac.
set -e
cd "$(dirname "$0")/.."
SALIDA=$(mktemp -d)
swiftc -swift-version 5 \
  apple_lab11_B_Compras/Modelos/*.swift \
  apple_lab11_B_Compras/Servicios/ReglasCompra.swift \
  apple_lab11_B_Compras/Servicios/Autenticacion.swift \
  apple_lab11_B_Compras/Servicios/Formato.swift \
  Verificacion/main.swift \
  -o "$SALIDA/verificar_reglas"
"$SALIDA/verificar_reglas"
