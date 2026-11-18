#!/bin/zsh
# Compila los modelos y la sesión junto con main.swift y ejecuta los casos de prueba en la Mac.
set -e
cd "$(dirname "$0")/.."
SALIDA=$(mktemp -d)
swiftc -swift-version 5 \
  apple_lab11_B_Compras/Modelos/*.swift \
  apple_lab11_B_Compras/Sesion.swift \
  Verificacion/main.swift \
  -o "$SALIDA/verificar"
"$SALIDA/verificar"
