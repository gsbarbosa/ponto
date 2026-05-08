# Orchestrator — Camada 2: Liderança Técnica

---

## Pré-requisito

Tenha o **Handoff L1→L2** preenchido e aprovado antes de iniciar.
Arquivo: `../schemas/handoff-l1-l2.md` (preenchido)

---

## Contexto que todos os agentes devem carregar

Antes de rodar qualquer agente desta camada, injete o knowledge base **e o decisions-log** no contexto:

```
[KNOWLEDGE BASE KENLO]

Stack e Padrões: {conteúdo de knowledge-base/stack-e-padroes.md}
Arquitetura: {conteúdo de knowledge-base/arquitetura.md}
Infraestrutura: {conteúdo de knowledge-base/infraestrutura.md}
Bancos de Dados: {conteúdo de knowledge-base/bancos-de-dados.md}
CI/CD: {conteúdo de knowledge-base/cicd.md}
Convenções: {conteúdo de knowledge-base/convencoes.md}

[DECISIONS LOG — MEMÓRIA INSTITUCIONAL]
{conteúdo de ../../decisions-log.md}
```

> O decisions-log registra decisões arquiteturais tomadas em demandas anteriores com contexto e razão. Consulte antes de tomar decisões — evite contradizer entradas ativas sem justificativa explícita.

---

## Fase 1 — CTO (primeiro, bloqueante)

```
[KNOWLEDGE BASE KENLO]
{conteúdo dos 6 arquivos de knowledge base}

[AGENTE: CTO Kenlo]
{conteúdo de agents/cto.md}

PRD FINAL:
{conteúdo do handoff L1→L2}

Analise esta demanda e produza as Decisões Técnicas Estratégicas conforme seu papel.
```

**Aguardar output do CTO antes de continuar.**

---

## Fase 2 — Arquiteto (segundo, bloqueante)

```
[KNOWLEDGE BASE KENLO]
{conteúdo dos 6 arquivos de knowledge base}

[AGENTE: Arquiteto de Software Kenlo]
{conteúdo de agents/arquiteto.md}

PRD FINAL:
{conteúdo do handoff L1→L2}

DECISÕES DO CTO:
{output do agente CTO}

Produza o Design Técnico detalhado conforme seu papel.
```

**Aguardar output do Arquiteto antes de continuar.**

---

## Fase 3 — Paralela (Security + Cloud Engineer + Tech Lead + UX Designer)

Rode os quatro agentes abaixo **simultaneamente** com os outputs acumulados:

### Security

```
[KNOWLEDGE BASE KENLO]
{knowledge base}

[AGENTE: Security Engineer Kenlo]
{conteúdo de agents/security.md}

PRD FINAL: {handoff L1→L2}
DECISÕES DO CTO: {output CTO}
DESIGN TÉCNICO: {output Arquiteto}

Produza a Análise de Segurança conforme seu papel.
```

### Cloud Engineer

```
[KNOWLEDGE BASE KENLO]
{knowledge base}

[AGENTE: Cloud Engineer Kenlo]
{conteúdo de agents/cloud-engineer.md}

PRD FINAL: {handoff L1→L2}
DECISÕES DO CTO: {output CTO}
DESIGN TÉCNICO: {output Arquiteto}

Produza o Plano de Infraestrutura conforme seu papel.
```

### Tech Lead

```
[KNOWLEDGE BASE KENLO]
{knowledge base}

[AGENTE: Tech Lead Kenlo]
{conteúdo de agents/tech-lead.md}

PRD FINAL: {handoff L1→L2}
DECISÕES DO CTO: {output CTO}
DESIGN TÉCNICO: {output Arquiteto}
ANÁLISE DE SEGURANÇA: [será preenchida — use o design técnico como base]

Produza o Plano de Implementação conforme seu papel.
```

### UX Designer

> Rodar apenas se a demanda tiver impacto em interface (frontend, fluxo de usuário, nova tela ou modificação de tela existente). Pular se for exclusivamente backend/infra.

```
[KNOWLEDGE BASE KENLO]
{knowledge base}

[AGENTE: UX Designer Kenlo]
{conteúdo de agents/ux-designer.md}

PRD FINAL: {handoff L1→L2}
DECISÕES DO CTO: {output CTO}
DESIGN TÉCNICO: {output Arquiteto}

Produza a Especificação de UX conforme seu papel.
```

**Aguardar os quatro outputs antes de continuar.**

---

## Fase 4 — Paralela (QA Lead + UI Designer)

Rode os dois agentes abaixo **simultaneamente**:

### QA Lead

```
[KNOWLEDGE BASE KENLO]
{knowledge base}

[AGENTE: QA Lead Kenlo]
{conteúdo de agents/qa-lead.md}

PRD FINAL: {handoff L1→L2}
DESIGN TÉCNICO: {output Arquiteto}
PLANO DE IMPLEMENTAÇÃO: {output Tech Lead}
ANÁLISE DE SEGURANÇA: {output Security}

Produza o Plano de Testes conforme seu papel.
```

### UI Designer

> Rodar apenas se o UX Designer foi acionado na Fase 3.

```
[KNOWLEDGE BASE KENLO]
{knowledge base}

[AGENTE: UI Designer Kenlo]
{conteúdo de agents/ui-designer.md}

PRD FINAL: {handoff L1→L2}
DESIGN TÉCNICO: {output Arquiteto}
ESPECIFICAÇÃO DE UX: {output UX Designer}

Produza a Especificação de UI conforme seu papel.
```

---

## Ponto de Decisão Humana

Antes de avançar para a Camada 3, revise:

- [ ] As decisões arquiteturais fazem sentido para o contexto?
- [ ] O plano de implementação é executável?
- [ ] Os riscos de segurança foram adequadamente tratados?
- [ ] O plano de infra cobre do dev ao prod?
- [ ] Os casos de teste cobrem os critérios de aceite do PRD?
- [ ] (se aplicável) Os fluxos de UX cobrem todos os perfis de usuário impactados?
- [ ] (se aplicável) A especificação de UI está granular o suficiente para o dev frontend implementar sem adivinhar?
- [ ] Há algo que ficou inconsistente entre os agentes?

**Se sim para tudo → preencha o output-template.md e avance para a Camada 3**
**Se não → ajuste os pontos antes de avançar**
