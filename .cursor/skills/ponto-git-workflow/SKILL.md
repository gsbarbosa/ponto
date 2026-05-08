---
name: ponto-git-workflow
description: Orienta commits, push, PR e validação Flutter neste repositório (uma única raiz Flutter). Use quando o usuário ou o agente for versionar código, fazer deploy, abrir PR, ou perguntar como subir alterações no projeto ponto.
disable-model-invocation: false
---

# Ponto — Git e entrega

## Contexto do repo

- App Flutter **somente na raiz** (`pubspec.yaml`, `lib/`). Não criar `ponto_app/` nem segundo projeto Flutter aninhado.
- CI deploy: **`.github/workflows/` na raiz** (não dentro de subpastas do app).

## Fluxo recomendado (copiar checklist na conversa)

```
- [ ] git status / git diff — só escopo da tarefa
- [ ] fvm flutter pub get (se mudou pubspec ou primeiro clone)
- [ ] fvm flutter analyze ou build web --release antes de PR/deploy
- [ ] Commit(es) atômico(s) + mensagem clara (feat/fix/refactor/chore)
- [ ] git push origin <branch>
- [ ] Abrir PR para main com resumo e impacto (Hosting/Firestore?)
```

## Mensagens de commit (exemplos)

```
feat(admin): export mensal em Excel e reload PWA
fix(auth): evita leitura Firestore antes do login
chore(ci): workflow Firebase só com FIREBASE_KEY
refactor: remove código morto no painel admin
```

## Antes de “publicar” (Firebase / Hosting)

Na raiz do repositório:

```bash
fvm flutter build web --release
firebase deploy --only hosting,firestore:rules,firestore:indexes --project ponto-444b1
```

(Ajustar projeto se mudar o ID.)

## Verificação automática de layout

Rodar na raiz:

```bash
bash scripts/check-repo-layout.sh
```

Falha se existir pasta proibida tipo `ponto_app/` ou mais de um `pubspec.yaml` aplicável ao app.

## O que não fazer

- Mega-commit misturando app + outro produto + docs irrelevantes sem separar commits ou PRs.
- Workflow só em `subpasta/.github/` — GitHub não usa para este repo.
- Editar código “na cópia” dentro de uma pasta duplicada do Flutter.
