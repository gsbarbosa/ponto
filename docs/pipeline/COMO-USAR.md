# Como Usar o Pipeline — Guia para Não-Técnicos

Este guia mostra como transformar uma ideia em software rodando em produção, passo a passo. Você não precisa saber programar para usar as primeiras etapas.

---

## Visão Geral do Processo

```
Sua Ideia
   │
   ▼
[1] Preencha o Intake (você faz isso)
   │
   ▼
[2] Camada 1 — IA valida e estrutura a ideia (você revisa)
   │
   ▼
[3] Camada 2 — IA planeja como construir (você revisa)
   │
   ▼
[4] Camada 3 — IA implementa e faz o deploy (você acompanha)
   │
   ▼
[5] Produção rodando 🚀
   │
   ▼ (1-4 semanas depois)
[6] Camada 4 — IA analisa o que aprendeu (você valida e arquiva)
```

---

## Passo a Passo

---

### Passo 1 — Capture sua Ideia

Abra o arquivo `intake.md` e preencha as perguntas.

**Dicas:**
- Escreva como falaria para um colega — sem termos técnicos
- Quanto mais evidências reais você tiver (clientes que pediram, tickets, frases literais), melhor
- Se não souber responder algo, escreva "não sei" — é melhor do que inventar

**Exemplo de intake bem preenchido:**

> **A Ideia:** Quero que o corretor consiga enviar o contrato para assinatura digital direto do sistema, sem precisar baixar PDF e usar o DocuSign separado.
>
> **Quantos clientes pediram?** 8 clientes em 2 meses. Três deles reclamaram explicitamente em reunião de CS.
>
> **Quote real:** "Toda vez que preciso assinar um contrato perco 30 minutos saindo do sistema, gerando PDF, enviando pro DocuSign e depois voltando pra atualizar o status manualmente."

---

### Passo 2 — Rode a Camada 1 (Conselho de Negócio)

Abra o arquivo `layer-1-negocio/orchestrator.md`.

Ele vai te guiar para rodar 4 agentes de IA nesta ordem:
1. **Validador de Mercado** — verifica se a ideia faz sentido no mercado
2. **Verificador de Valor** — avalia o impacto real para usuários e negócio
3. **Product Owner** — transforma a ideia em um documento estruturado
4. **Product Manager** — refina e fecha o documento

**Sua parte:** Ao final, você recebe um **PRD** (documento de requisitos). Leia e responda:
- Isso representa o que eu queria?
- Há algo errado ou faltando?

Se estiver ok, assine e avance. Se não, ajuste antes de continuar.

> **Regra de ouro:** Nunca avance sem validar. O que for aprovado aqui vai guiar toda a implementação.

---

### Passo 3 — Rode a Camada 2 (Liderança Técnica)

Abra o arquivo `layer-2-lideranca-tecnica/orchestrator.md`.

Esta camada é mais técnica — ela define **como** construir. Você não precisa entender cada detalhe técnico, mas precisa validar se o plano faz sentido para o negócio:

- O que foi decidido implementar parece correto?
- Algo ficou de fora do escopo que não deveria?
- Há algo que parece excessivamente complexo para o problema?

Se algo não fizer sentido, questione — é muito mais barato ajustar aqui do que depois.

---

### Passo 4 — Rode a Camada 3 (Desenvolvimento)

Abra o arquivo `layer-3-desenvolvimento/orchestrator.md`.

Esta camada implementa e faz o deploy. Seu papel é acompanhar:

- **Dev:** primeira versão no ar (ambiente de testes)
- **Staging:** testes de aceite — verifique se a feature funciona como esperado
- **Produção:** deploy final — monitore por 2h após o lançamento

Se algo não funcionar como esperado em staging, **não deixe ir para produção**. Documente o problema e sinalize.

---

### Passo 5 — Aguarde 1-4 Semanas

A feature está em produção. Neste período:

- Observe como os usuários estão usando (ou não usando)
- Colete feedback — tickets de suporte, conversas, NPS
- Anote o que foi diferente do esperado

---

### Passo 6 — Rode a Camada 4 (Retrospectiva)

Abra o arquivo `schemas/handoff-l3-l4.md` e preencha com o que coletou.

Depois rode o `layer-4-retrospectiva/orchestrator.md`.

Esta camada analisa o que aconteceu e atualiza a memória do pipeline. Sua parte é:
- Revisar os aprendizados gerados
- Aprovar ou ajustar as entradas no `decisions-log.md`

---

## Regras Que Nunca Quebrar

| Regra | Por quê |
|-------|---------|
| Sempre valide o PRD antes de ir para a Camada 2 | Tudo que vem depois é construído sobre o PRD |
| Sempre valide a Camada 2 antes de ir para a Camada 3 | Mudar o design durante o desenvolvimento é caro |
| Sempre teste em staging antes de ir para produção | Produção é território real, com usuários reais |
| Sempre rode a Camada 4 (mesmo que breve) | Sem retrospectiva, o pipeline não aprende |

---

## Onde Estão os Arquivos

```
pipeline/
├── COMO-USAR.md                    ← você está aqui
├── intake.md                       ← começa aqui com sua ideia
├── decisions-log.md                ← memória institucional (não edite manualmente)
├── schemas/
│   ├── handoff-l1-l2.md           ← contrato L1 → L2
│   ├── handoff-l2-l3.md           ← contrato L2 → L3
│   └── handoff-l3-l4.md           ← contrato L3 → L4
├── layer-1-negocio/
│   └── orchestrator.md            ← guia da Camada 1
├── layer-2-lideranca-tecnica/
│   └── orchestrator.md            ← guia da Camada 2
├── layer-3-desenvolvimento/
│   └── orchestrator.md            ← guia da Camada 3
├── layer-4-retrospectiva/
│   └── orchestrator.md            ← guia da Camada 4
└── tasks/
    └── KNL-AAAA-NNN/              ← pasta de cada demanda
```

---

## Quando Travar, Faça Isso

**Não sei responder uma pergunta do intake:**
→ Escreva "não sei" e continue. A Camada 1 vai sinalizar o que está faltando.

**O PRD não está certo:**
→ Ajuste antes de avançar. Nunca force o PRD para frente se estiver errado.

**A feature em staging não funciona como esperado:**
→ Não vai para produção. Documente o problema e escale para a Camada 2.

**Não entendo algo técnico da Camada 2:**
→ Pergunte. Se não faz sentido para você em linguagem de negócio, provavelmente precisa ser explicado melhor.
