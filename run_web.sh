#!/bin/bash
# Roda o app Flutter no Chrome
cd "$(dirname "$0")"
# Tenta fvm, depois flutter direto
command -v fvm >/dev/null 2>&1 && fvm flutter run -d chrome || flutter run -d chrome
