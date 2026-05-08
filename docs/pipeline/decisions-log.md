# Decisions Log — Memória Institucional Kenlo

Este arquivo é a memória viva do pipeline. Registra decisões arquiteturais e de produto tomadas ao longo do tempo, com contexto suficiente para que agentes e pessoas entendam o raciocínio por trás de cada escolha.

**Injetado automaticamente em todos os agentes da Camada 2.**
**Atualizado pelo Guardião do Conhecimento ao final de cada Camada 4.**

---

## Como Usar

- **Camada 2 (todos os agentes):** carregue este arquivo junto com o knowledge base
- **CTO:** consulte antes de tomar decisões arquiteturais — evite repetir erros ou contradizer decisões ainda vigentes
- **Camada 4 (Guardião do Conhecimento):** adicione novas entradas após cada retrospectiva

---

## Convenções de Entrada

```
### [AAAA-MM] <ID-Demanda> — <Categoria>
**Decisão:** o que foi decidido
**Alternativa descartada:** o que foi considerado e rejeitado
**Motivo:** por que essa escolha e não a outra
**Aprendizado (se houver):** o que a execução revelou sobre essa decisão
**Status:** Ativa | Revisada | Obsoleta
```

Categorias disponíveis: `Arquitetura` · `Banco de Dados` · `Infra` · `Segurança` · `Processo` · `Produto`

---

## Decisões Ativas

<!-- O Guardião do Conhecimento adiciona entradas aqui após cada Camada 4 -->

<!-- EXEMPLO (remova ao adicionar a primeira entrada real):

### [2026-01] KNL-2026-001 — Banco de Dados
**Decisão:** MongoDB como padrão para entidades de domínio; PostgreSQL apenas para relatórios e dados relacionais
**Alternativa descartada:** PostgreSQL para tudo
**Motivo:** Flexibilidade de schema em domínios que evoluem rapidamente; PostgreSQL reservado onde integridade relacional é crítica
**Aprendizado:** —
**Status:** Ativa

### [2026-03] KNL-2026-003 — Arquitetura
**Decisão:** Pub/Sub com ordering key obrigatório em eventos de transação financeira
**Alternativa descartada:** REST síncrono entre serviços de pagamento
**Motivo:** Garantia de ordem de processamento; REST síncrono criaria acoplamento e risco de perda de evento em falha de rede
**Aprendizado:** Implementação revelou necessidade de dead-letter topic — adicionado ao knowledge base de infra
**Status:** Ativa

-->

---

## Decisões Revisadas ou Obsoletas

<!-- Decisões que foram substituídas. Mantenha o histórico para rastreabilidade -->

<!-- EXEMPLO:

### [2025-06] KNL-2025-010 — Infra *(Obsoleta desde 2026-01)*
**Decisão original:** Cloud Run para todos os serviços stateless
**Substituída por:** GKE para serviços com alto volume de requests (>1k/min)
**Motivo da revisão:** Cold start do Cloud Run gerou p95 > 2s em pico — incompatível com SLA

-->
