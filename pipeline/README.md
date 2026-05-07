# Pipeline de Desenvolvimento com IA — Kenlo

Pipeline de 4 camadas para transformar ideias brutas em software rodando em produção — e aprender com cada ciclo.

---

## Visão Geral

```
INTAKE (evidências reais)
    │
    ▼
┌─────────────────────────────────┐
│  CAMADA 1 — Conselho de Negócio │
│  PO · PM · Validador · Valor    │
└─────────────────┬───────────────┘
                  │ PRD Estruturado
                  ▼
┌─────────────────────────────────┐
│  CAMADA 2 — Liderança Técnica   │
│  CTO · Arquiteto · Security     │  ← decisions-log injetado
│  Cloud · Tech Lead · QA Lead    │
└─────────────────┬───────────────┘
                  │ Estratégia de Implementação
                  ▼
┌─────────────────────────────────┐
│  CAMADA 3 — Desenvolvimento     │
│  Backend · Frontend · QA        │
└─────────────────┬───────────────┘
                  │
                  ▼
            PRODUÇÃO
                  │
         (1-4 semanas depois)
                  ▼
┌─────────────────────────────────┐
│  CAMADA 4 — Retrospectiva       │
│  Analista de Resultado          │
│  Guardião do Conhecimento       │
└─────────────────┬───────────────┘
                  │
                  ▼
         decisions-log atualizado
         (alimenta próximo ciclo)
```

---

## Princípio Fundamental

Cada camada **recebe** um artefato estruturado e **entrega** um artefato estruturado para a próxima. Nenhuma camada começa sem o output validado da anterior.

O output de cada camada não é texto livre — é um **documento com schema definido** que a próxima camada sabe consumir.

---

## As 4 Camadas

### Camada 1 — Conselho de Negócio
**Entrada:** Intake preenchido (ideia + evidências reais)
**Saída:** PRD estruturado + handoff para Camada 2

Agentes responsáveis por:
- Validar a ideia no mercado (benchmarking, concorrentes, tendências)
- Verificar o valor real da demanda (ROI, dor que resolve, prioridade)
- Transformar ideia bruta em solução de valor com escopo fechado
- Fechar arestas de negócio (edge cases, regras, restrições)

[Ver Camada 1 →](./layer-1-negocio/README.md)

---

### Camada 2 — Liderança Técnica
**Entrada:** PRD estruturado da Camada 1
**Saída:** Estratégia técnica completa + handoff para Camada 3

Agentes responsáveis por:
- Definir arquitetura da solução dentro dos padrões Kenlo
- Garantir segurança, escalabilidade e idempotência
- Planejar infraestrutura e deploy (do localhost ao GCP)
- Definir estratégia de testes e critérios de aceite técnico
- Faseamento da implementação se necessário

Knowledge base com toda a stack e padrões Kenlo pré-carregados.

[Ver Camada 2 →](./layer-2-lideranca-tecnica/README.md)

---

### Camada 3 — Desenvolvimento
**Entrada:** Estratégia técnica da Camada 2
**Saída:** Código rodando em produção

Agentes responsáveis por:
- Implementar o código seguindo os padrões definidos
- Executar e validar os testes
- Fazer o deploy até produção
- Garantir que não há pendências técnicas

[Ver Camada 3 →](./layer-3-desenvolvimento/README.md)

---

### Camada 4 — Retrospectiva
**Entrada:** Handoff L3→L4 (registro de entrega + dados de produção após 1-4 semanas)
**Saída:** decisions-log atualizado + knowledge base sinalizado se necessário

Agentes responsáveis por:
- Comparar o que foi planejado com o que aconteceu
- Identificar decisões que merecem entrar na memória institucional
- Manter o pipeline aprendendo a cada ciclo

[Ver Camada 4 →](./layer-4-retrospectiva/README.md)

---

## Schemas de Handoff

| Handoff | De → Para | Arquivo |
|---------|-----------|---------|
| L1 → L2 | Negócio → Técnico | [schemas/handoff-l1-l2.md](./schemas/handoff-l1-l2.md) |
| L2 → L3 | Técnico → Dev | [schemas/handoff-l2-l3.md](./schemas/handoff-l2-l3.md) |
| L3 → L4 | Dev → Retrospectiva | [schemas/handoff-l3-l4.md](./schemas/handoff-l3-l4.md) |

---

## Arquivos de Contexto Injetável

| Arquivo | Função |
|---------|--------|
| [intake.md](./intake.md) | Formulário de entrada — captura ideia + evidências reais |
| [decisions-log.md](./decisions-log.md) | Memória institucional — decisões arquiteturais acumuladas |
| [COMO-USAR.md](./COMO-USAR.md) | Guia passo a passo para não-técnicos |

---

## Como Usar

1. **Preencha o intake** com a ideia e evidências reais — `intake.md`
2. **Rode a Camada 1** com o orchestrator de negócio
3. **Valide o PRD** gerado antes de avançar
4. **Rode a Camada 2** com o PRD aprovado (decisions-log é injetado automaticamente)
5. **Valide a estratégia técnica** antes de avançar
6. **Rode a Camada 3** com a estratégia aprovada
7. **Monitore** o output em produção por 1-4 semanas
8. **Rode a Camada 4** — feche o ciclo e atualize a memória institucional

> Não-técnico? Leia primeiro o [COMO-USAR.md](./COMO-USAR.md)

---

## Loop de Feedback

Quando a Camada 3 encontra impedimento técnico → volta para Camada 2
Quando a Camada 2 encontra conflito com negócio → volta para Camada 1
Quando a Camada 4 conclui → alimenta o decisions-log para o próximo ciclo

Nunca avance para a próxima camada sem aprovação do output da camada anterior.
