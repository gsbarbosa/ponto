#!/usr/bin/env bash
# Hook Cursor: alerta comandos que costumam recriar projeto Flutter aninhado.
set -euo pipefail
INPUT="$(cat)"
CMD="$(python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("command") or d.get("shell_command") or "")' <<<"$INPUT" 2>/dev/null || true)"

# Normaliza para grep simples
LOWER="$(printf '%s' "$CMD" | tr '[:upper:]' '[:lower:]')"

if printf '%s' "$LOWER" | grep -qE '(^|[/\s])ponto_app([/\s]|$)|mkdir\s.*ponto_app|flutter\s+create\s'; then
  printf '%s\n' '{"permission":"ask","user_message":"Este comando pode criar ou usar uma segunda árvore Flutter (ex.: ponto_app/). Neste repo o app deve ficar só na raiz — confira .cursor/rules e scripts/check-repo-layout.sh.","agent_message":"Possível violação da regra de um único Flutter na raiz. Não criar ponto_app/ nem segundo pubspec; editar lib/ na raiz e workflows só em .github/workflows/. Pedir confirmação ao usuário ou cancelar."}'
  exit 0
fi

printf '%s\n' '{"permission":"allow"}'
exit 0
