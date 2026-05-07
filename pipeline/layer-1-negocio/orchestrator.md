# Orchestrator — Camada 1: Conselho de Negócio

Este documento define como orquestrar os agentes da Camada 1 para processar uma ideia bruta e gerar o PRD Final.

---

## Sequência de Execução

Os dois primeiros agentes rodam em paralelo. Os dois últimos rodam em sequência depois.

```
FASE 1 (paralelo):
  ├── Validador de Mercado
  └── Verificador de Valor

FASE 2 (sequencial, com outputs da Fase 1):
  ├── Product Owner → PRD Inicial
  └── Product Manager → PRD Final
```

---

## Pré-requisito: Intake Preenchido

Antes de rodar qualquer agente, o solicitante deve preencher o **[intake.md](../../intake.md)**.

O intake substitui o formulário de 5 perguntas anterior. Ele captura:
- A ideia em linguagem natural
- **Evidências reais** do problema (clientes, tickets, quotes literais)
- Contexto do problema e workaround atual
- Escopo mínimo e critérios de sucesso

> Um intake bem preenchido ancora os agentes em realidade, não em suposição. O Validador de Mercado e o Verificador de Valor produzem outputs muito mais precisos quando têm evidências concretas como entrada.

---

## Execução Fase 1 — Paralela

### Rodando o Validador de Mercado

Copie o prompt abaixo, substituindo os campos:

```
[AGENTE: Validador de Mercado]
[CONTEXTO: Kenlo — plataforma SaaS para o mercado imobiliário brasileiro]

INTAKE DA DEMANDA:
{conteúdo completo do intake.md preenchido}

Siga as instruções do agente Validador de Mercado e produza o Relatório de Mercado.
Priorize as evidências concretas do intake (quotes, tickets, dados) sobre inferências genéricas de mercado.
```

### Rodando o Verificador de Valor

```
[AGENTE: Verificador de Valor]
[CONTEXTO: Kenlo — plataforma SaaS para o mercado imobiliário brasileiro]

INTAKE DA DEMANDA:
{conteúdo completo do intake.md preenchido}

Siga as instruções do agente Verificador de Valor e produza a Análise de Valor.
Baseie a análise nas evidências reais do intake — quantos clientes, frequência de dor, impacto observado.
Nota: o Relatório de Mercado ainda não está disponível — faça sua análise com base no intake.
```

---

## Execução Fase 2 — Sequencial

### Rodando o Product Owner (com outputs da Fase 1)

```
[AGENTE: Product Owner]
[CONTEXTO: Kenlo — plataforma SaaS para o mercado imobiliário brasileiro]

IDEIA ORIGINAL: {ideia bruta}

RELATÓRIO DE MERCADO:
{output do Validador de Mercado}

ANÁLISE DE VALOR:
{output do Verificador de Valor}

Siga as instruções do agente Product Owner e produza o PRD Inicial.
```

### Rodando o Product Manager (com PRD Inicial)

```
[AGENTE: Product Manager]
[CONTEXTO: Kenlo — plataforma SaaS para o mercado imobiliário brasileiro]

PRD INICIAL:
{output do Product Owner}

RELATÓRIO DE MERCADO:
{output do Validador de Mercado}

ANÁLISE DE VALOR:
{output do Verificador de Valor}

Siga as instruções do agente Product Manager. Revise o PRD, feche as arestas e produza o PRD Final pronto para handoff à Camada 2.
```

---

## Ponto de Decisão Humana

Antes de avançar para a Camada 2:

- [ ] O PRD Final representa o que você queria?
- [ ] O escopo está correto (nem muito, nem pouco)?
- [ ] As regras de negócio estão certas?
- [ ] Há algo que ficou de fora que deveria estar?

**Se sim para tudo → avance para a Camada 2 usando o [output-template.md](./output-template.md)**
**Se não → ajuste o PRD antes de avançar**
