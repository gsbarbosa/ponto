# Output Template — Camada 1 → Camada 2

Este é o artefato estruturado que a Camada 1 entrega para a Camada 2. Preencha todos os campos antes de iniciar a Camada 2.

---

```markdown
# HANDOFF L1 → L2

## Metadados
- **ID da Demanda:** [gerado automaticamente ou sequencial: KNL-YYYY-NNN]
- **Título:** [nome curto da feature/produto]
- **Data:** [data de hoje]
- **Solicitante:** [quem pediu]
- **Prioridade:** [alta/média/baixa]
- **Prazo Desejado:** [se houver]

---

## Resumo Executivo
[3-5 linhas descrevendo o que é, para quem serve e por que foi aprovado]

---

## Validação de Negócio
- **Aprovado pelo mercado:** [sim/não] — [justificativa resumida]
- **Valor classificado como:** [alto/médio/baixo]
- **Score de prioridade:** [X.X / 5.0]
- **Recomendação:** [prosseguir / prosseguir com ressalvas]

---

## PRD Final

### Problema
[descrição clara do problema]

### Personas
[quem usa, quem é impactado]

### Solução
[descrição da solução em linguagem de negócio]

### Escopo MVP

**IN (deve ser implementado):**
- [ ] [funcionalidade 1]
- [ ] [funcionalidade 2]

**OUT (não será implementado agora):**
- [ ] [funcionalidade X] — motivo: [...]

### User Stories

**US-001:** [título]
- Como [persona], quero [ação], para [objetivo]
- Critérios de aceite:
  - Dado [...], quando [...], então [...]
  - Dado [...], quando [...], então [...]

[repetir para cada US]

### Regras de Negócio

| ID | Regra | Exceções |
|----|-------|----------|
| RN-001 | [descrição] | [exceções] |

### Estados do Objeto Principal

| Estado | Descrição | Transições |
|--------|-----------|------------|
| [estado] | [descrição] | → [próximo] |

### Notificações Necessárias

| Evento | Destinatário | Canal | Conteúdo |
|--------|-------------|-------|---------|
| [evento] | [quem] | email/push/inbox | [o que comunicar] |

### Integrações de Negócio
- [sistema externo]: [para que é usado neste contexto]

### Dados Sensíveis / LGPD
- [sim/não — se sim, detalhar]

### Auditoria / Histórico
- [precisa ou não de log de auditoria — detalhar se sim]

### Métricas de Sucesso
- [como medir se funcionou]

### Glossário de Domínio
- **[termo]:** [definição]

---

## Decisões em Aberto para a Camada 2
[questões que a liderança técnica precisa resolver — não são decisões de negócio]
- [ ] [questão técnica 1]
- [ ] [questão técnica 2]

---

## Artefatos da Camada 1
- Relatório de Mercado: [disponível em / resumo]
- Análise de Valor: [disponível em / resumo]
```
