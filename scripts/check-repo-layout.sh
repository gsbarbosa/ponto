#!/usr/bin/env bash
# Falha se a estrutura violar "um Flutter na raiz" (guardrail CI/local).
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

if [[ -d ponto_app ]]; then
  echo "::error::Pasta 'ponto_app/' não é permitida. Use apenas o projeto Flutter na raiz (lib/, pubspec.yaml)."
  exit 1
fi

TMP="$(mktemp)"
find . -name pubspec.yaml -not -path './.git/*' | LC_ALL=C sort >"$TMP"
COUNT="$(grep -c . "$TMP" 2>/dev/null || true)"
if [[ -z "$COUNT" ]]; then COUNT=0; fi

if [[ "$COUNT" -ne 1 ]]; then
  echo "::error::Esperado exatamente 1 pubspec.yaml para o app; encontrados: $COUNT"
  cat "$TMP"
  rm -f "$TMP"
  exit 1
fi

ONLY="$(head -1 "$TMP")"
rm -f "$TMP"

if [[ "$ONLY" != "./pubspec.yaml" ]]; then
  echo "::error::pubspec.yaml deve ficar na raiz do repositório, não em '${ONLY#./}'"
  exit 1
fi

while IFS= read -r wf; do
  case "$wf" in
    ./.github/workflows/*) ;;
    *)
      echo "::error::Workflow do GitHub Actions fora da raiz (inválido): $wf"
      exit 1
      ;;
  esac
done < <(find . -path './.git' -prune -o -type f \( -name '*.yml' -o -name '*.yaml' \) -path '*/.github/workflows/*' -print)

echo "OK: layout do repositório (Flutter único na raiz)."
