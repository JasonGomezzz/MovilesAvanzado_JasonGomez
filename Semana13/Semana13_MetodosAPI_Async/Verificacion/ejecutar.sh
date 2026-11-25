#!/bin/zsh
# Compila el validador junto con los casos de prueba y los ejecuta.
cd "$(dirname "$0")/.."
APP=Semana13_MetodosAPI_Async
OUT=$(mktemp -d)/verificacion
xcrun swiftc -o "$OUT" \
  $APP/Models/User.swift $APP/Models/UserValidator.swift Verificacion/main.swift 2>&1 | grep -v "^$" ; "$OUT"
