# Orchestrator — Camada 4: Retrospectiva

---

## Pré-requisito

Tenha o **Handoff L3→L4** preenchido antes de iniciar.
Arquivo: `../schemas/handoff-l3-l4.md` (preenchido)

**Janela ideal:** entre 1 e 4 semanas após o deploy em produção.

---

## Fase 1 — Analista de Resultado

```
[AGENTE: Analista de Resultado]
{conteúdo de agents/analista-resultado.md}

HANDOFF L3→L4:
{conteúdo do handoff-l3-l4.md preenchido}

Analise o resultado desta demanda e produza o Relatório de Retrospectiva conforme seu papel.
```

**Aguardar output antes de continuar.**

---

## Fase 2 — Guardião do Conhecimento

```
[AGENTE: Guardião do Conhecimento]
{conteúdo de agents/guardiao-conhecimento.md}

RELATÓRIO DE RETROSPECTIVA:
{output do Analista de Resultado}

DECISIONS-LOG ATUAL:
{conteúdo atual de decisions-log.md}

Processe o relatório, determine quais decisões registrar e produza as atualizações do decisions-log conforme seu papel.
```

---

## Ação Humana Final

Com o output do Guardião do Conhecimento:

1. **Revise as entradas propostas** — edite se necessário
2. **Aplique no decisions-log.md** — cole as novas entradas na seção "Decisões Ativas"
3. **Mova obsoletas** para a seção "Histórico de Decisões Revisadas"
4. **Sinalize knowledge base** — se houver atualizações necessárias, agende para a próxima sessão

---

## Ponto de Decisão Humana

Antes de encerrar:

- [ ] Relatório de Retrospectiva revisado e faz sentido
- [ ] Entradas do decisions-log revisadas e aprovadas
- [ ] decisions-log.md atualizado
- [ ] Knowledge base sinalizado se necessário
- [ ] Output template preenchido (registro de conclusão da retrospectiva)

**Após isso → ciclo completo. Próxima demanda começa com memória atualizada.**
