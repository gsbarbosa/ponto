# Orchestrator — Camada 3: Desenvolvimento

---

## Pré-requisito

Tenha o **Handoff L2→L3** preenchido e aprovado antes de iniciar.

---

## Fase 1 — Implementação Backend

Para cada tarefa do plano de implementação, na ordem definida pelo Tech Lead:

```
[AGENTE: Backend Developer Kenlo]
{conteúdo de agents/backend.md}

[KNOWLEDGE BASE KENLO — Stack e Padrões]
{conteúdo de layer-2-lideranca-tecnica/knowledge-base/stack-e-padroes.md}
{conteúdo de layer-2-lideranca-tecnica/knowledge-base/convencoes.md}

[HANDOFF L2→L3]
{conteúdo do handoff}

[CÓDIGO ATUAL DO SERVIÇO]
{arquivos relevantes do serviço que será modificado}

Implemente a Tarefa [N.N]: [título da tarefa]
Siga exatamente o design técnico e os padrões definidos.
Ao finalizar, confirme o checklist de conclusão da tarefa.
```

**Repita para cada tarefa, em ordem.**

---

## Fase 2 — Implementação Frontend (se aplicável)

```
[AGENTE: Frontend Developer Kenlo]
{conteúdo de agents/frontend.md}

[HANDOFF L2→L3]
{contratos de API e design da feature}

[CÓDIGO ATUAL DO FRONTEND]
{arquivos relevantes}

Implemente a feature de frontend conforme o plano.
```

---

## Fase 3 — Testes (paralelo com implementação, mas validação após)

### Implementação dos Testes Automatizados

```
[AGENTE: QA Engineer Kenlo]
{conteúdo de agents/qa.md}

[PLANO DE TESTES]
{plano de testes do QA Lead — do handoff L2→L3}

[CÓDIGO IMPLEMENTADO]
{código dos serviços}

Implemente os testes automatizados conforme o plano de testes.
Rode os testes e reporte o resultado.
```

---

## Fase 4 — Deploy em Dev

Após todos os testes passando localmente:

```bash
# Verificar que o pipeline CI está configurado
cat .gitlab-ci.yml

# Fazer push e acompanhar o pipeline
git add .
git commit -m "feat([scope]): [description]"
git push

# Acompanhar deploy em dev
# Verificar health check
curl https://[servico]-dev.kenlo.com/health

# Verificar logs (sem erros)
```

**Critério para avançar:** health check OK, endpoints respondendo, sem erros em Sentry.

---

## Fase 5 — Deploy em Staging + Aceite

```
[AGENTE: QA Engineer Kenlo]
{conteúdo de agents/qa.md}

[PLANO DE TESTES — casos manuais]
{lista de casos de teste para staging}

Execute os casos de teste manuais em staging.
Documente o resultado de cada CT.
Emita a decisão de Go/No-Go.
```

**Critério para avançar:** GO do QA.

---

## Fase 6 — Deploy em Produção

```bash
# Merge na branch main (via GitLab MR aprovado)
# CI/CD faz deploy automaticamente

# Monitorar por 2h:
# - Datadog: métricas de erro e latência
# - Sentry: novos erros
# - Health check
```

**Critério de conclusão:** 2h sem erros críticos em produção.

---

## Escalada para Camada 2

Se durante a implementação encontrar:
- Design técnico inconsistente ou inviável
- Conflito com código existente não previsto
- Requisito de segurança impossível de implementar como especificado

→ **Não invente solução alternativa.** Documente o problema e escale para revisão da Camada 2 antes de prosseguir.
