# Camada 4 — Retrospectiva

**Entrada:** Handoff L3→L4 preenchido (dados de produção + registro da Camada 3)
**Saída:** Learnings documentados + decisions-log atualizado

---

## Propósito

A Camada 4 fecha o loop de aprendizado do pipeline. Sem ela, cada feature começa do zero — os agentes não aprendem com o que foi entregue, os padrões não evoluem, os erros se repetem.

Com ela, o pipeline fica mais inteligente a cada entrega.

---

## Quando Rodar

Entre **1 e 4 semanas** após o deploy em produção — tempo suficiente para ter dados reais de uso e comportamento do sistema.

Não antes de 1 semana (dados insuficientes).
Não depois de 4 semanas (contexto esfria, detalhes se perdem).

---

## Agentes

| Agente | Papel |
|--------|-------|
| [Analista de Resultado](./agents/analista-resultado.md) | Compara planejado vs. executado, identifica desvios e padrões |
| [Guardião do Conhecimento](./agents/guardiao-conhecimento.md) | Extrai decisões relevantes e atualiza o decisions-log |

---

## Sequência de Execução

```
Handoff L3→L4
     │
     ▼
Analista de Resultado
     │ Relatório de Retrospectiva
     ▼
Guardião do Conhecimento
     │
     ├── Atualiza decisions-log.md
     └── Sinaliza se knowledge base precisa revisão
```

---

## Output da Camada 4

Ver [output-template.md](./output-template.md)

---

## Princípio

A Camada 4 não julga pessoas — analisa processos e decisões. O objetivo é extrair aprendizado acionável, não atribuir culpa.
