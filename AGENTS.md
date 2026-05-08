# Instruções para agentes (Cursor / IA)

## Estrutura

- **Um único projeto Flutter na raiz** (`pubspec.yaml`, `lib/`). Não criar `ponto_app/` nem duplicar Android/iOS/web em subpastas paralelas.
- Workflows GitHub Actions: **somente** `.github/workflows/` na raiz.

## Git

- Commits focados, mensagens claras; depois **`git push`** e PR para `main` quando aplicável.
- Antes de deploy relevante: `fvm flutter pub get`, `fvm flutter analyze` ou `fvm flutter build web --release`.

## Cursor

- Regras permanentes: `.cursor/rules/*.mdc`
- Skill de fluxo Git: projeto `.cursor/skills/ponto-git-workflow/` (referenciar quando trabalhar versionamento ou deploy)
- Hook opcional: `.cursor/hooks.json` — alerta comandos de shell que sugerem segundo Flutter (`ponto_app`, `flutter create`, etc.)

## CI

- `scripts/check-repo-layout.sh` roda no workflow **Repo layout guardrails**.
