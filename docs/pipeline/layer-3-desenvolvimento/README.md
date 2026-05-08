# Camada 3 — Desenvolvimento

Esta camada executa o plano técnico produzido pela Camada 2 e entrega a feature rodando em produção.

---

## Agentes

| Agente | Responsabilidade |
|--------|-----------------|
| [Backend](./agents/backend.md) | APIs, serviços, repositories, migrations, eventos |
| [Frontend](./agents/frontend.md) | React, Next.js, integração com GraphQL/REST |
| [QA](./agents/qa.md) | Implementação e execução dos testes |

---

## Princípio desta Camada

Os agentes aqui **não tomam decisões de arquitetura ou negócio**. Todas as decisões já foram tomadas nas camadas anteriores. O papel aqui é **executar com precisão e qualidade**.

Se um agente encontrar algo tecnicamente inviável ou inconsistente no plano → escalar para revisão da Camada 2. Não inventar soluções alternativas sem validação.

---

## Fluxo de Execução

```
Handoff L2→L3 (plano completo)
    │
    ├──▶ Backend → implementa serviços e APIs
    │
    ├──▶ Frontend → implementa UI (se aplicável)
    │
    └──▶ QA → implementa e executa testes
                    │
                    ▼
              Todos passando?
                  │
         ┌────────┴────────┐
         ▼                 ▼
        Sim              Não
         │                 │
    Deploy dev        Corrigir
         │
    Smoke tests OK?
         │
    Deploy staging
         │
    Aceite QA OK?
         │
    Deploy produção
         │
    Monitoramento 2h
         │
    CONCLUÍDO
```

---

## Critério de Saída

A camada só está concluída quando:
- [ ] Todos os testes unitários passando
- [ ] Todos os testes E2E passando
- [ ] ESLint e TypeScript sem erros
- [ ] Rodando em dev
- [ ] Rodando em staging com testes de aceite validados
- [ ] Rodando em produção
- [ ] Sem erros no Sentry nas primeiras 2h
- [ ] Checklist do handoff L2→L3 completo

---

## Arquivos

- [orchestrator.md](./orchestrator.md) — Como orquestrar os agentes desta camada
- [output-template.md](./output-template.md) — Registro de conclusão da demanda
