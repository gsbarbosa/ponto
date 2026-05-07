# Camada 1 — Conselho de Negócio

Esta camada transforma uma ideia bruta em um PRD estruturado e validado, pronto para ser consumido pela liderança técnica.

---

## Agentes

| Agente | Responsabilidade |
|--------|-----------------|
| [Validador de Mercado](./agents/validador-mercado.md) | Benchmarking, concorrentes, tendências de mercado |
| [Verificador de Valor](./agents/verificador-valor.md) | ROI, dor que resolve, prioridade estratégica |
| [Product Owner](./agents/product-owner.md) | Transforma ideia em escopo com critérios de aceite |
| [Product Manager](./agents/product-manager.md) | Fecha arestas de negócio, regras e edge cases |

---

## Fluxo de Execução

```
Ideia Bruta
    │
    ├──▶ Validador de Mercado ──▶ Relatório de Mercado
    │
    ├──▶ Verificador de Valor ──▶ Análise de Valor
    │
    └──▶ (com os dois acima) ──▶ Product Owner ──▶ PRD Inicial
                                        │
                                        ▼
                                 Product Manager ──▶ PRD Final (fechado)
                                        │
                                        ▼
                               Output Template L1→L2
```

---

## Critério de Saída

A camada só avança quando:
- [ ] Ideia validada no mercado (há demanda real?)
- [ ] Valor quantificado (qual a dor que resolve?)
- [ ] Escopo fechado (o que está IN e o que está OUT?)
- [ ] Critérios de aceite de negócio definidos
- [ ] Edge cases mapeados
- [ ] Aprovação humana do PRD

---

## Arquivos

- [orchestrator.md](./orchestrator.md) — Como orquestrar os agentes desta camada
- [output-template.md](./output-template.md) — Template do output para a Camada 2
