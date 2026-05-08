# Output Template — Camada 2 → Camada 3

Preencha todos os campos antes de iniciar a Camada 3. Este é o artefato que os agentes de desenvolvimento vão executar.

---

```markdown
# HANDOFF L2 → L3

## Metadados
- **ID da Demanda:** [mesmo ID do handoff L1→L2]
- **Título:** [nome da feature/produto]
- **Data:** [data de hoje]
- **Fase:** [1 de N / única]

---

## Resumo da Solução Técnica
[3-5 linhas descrevendo o que vai ser implementado, onde e como]

---

## Decisões Arquiteturais

| Decisão | Escolha | Motivo |
|---------|---------|--------|
| Serviço principal | [nome] | [por que] |
| Banco de dados | [tipo] | [por que] |
| Comunicação | [sync/async] | [por que] |
| Deploy | [GKE/Cloud Run] | [por que] |

---

## Design da Solução

### Fluxo
[diagrama ASCII do fluxo completo]

### Contratos de API
[todos os endpoints com request/response/errors]

### Modelo de Dados
[todos os schemas/entities com campos e índices]

### Eventos Pub/Sub (se aplicável)
[tópicos, payloads, produtores, consumidores]

---

## Plano de Implementação

### Fase [N]: [Nome]

#### Tarefa [N.N] — [Título]
- **Serviço:** [nome]
- **Depende de:** [tarefa X ou nenhuma]
- **O que fazer:** [descrição detalhada]
- **Arquivos:** [lista de arquivos a criar/modificar]
- **Padrões:** [padrões obrigatórios]
- **Pronto quando:** [critério]

[repetir para todas as tarefas]

---

## Requisitos de Segurança (obrigatórios)
[lista de requisitos que DEVEM ser implementados]
- [ ] [requisito 1]
- [ ] [requisito 2]

---

## Configuração de Infraestrutura

### Helm (chart-v2)
[configuração de resources, replicas, probes]

### Variáveis de Ambiente
[lista completa — secrets marcados como tal]

### GitLab CI
[configuração do .gitlab-ci.yml se novo serviço]

---

## Plano de Rollout

| Ambiente | Ordem | Critério para Avançar |
|----------|-------|----------------------|
| dev | 1º | Health check OK, endpoints respondendo |
| staging | 2º | Todos os casos de teste passando |
| produção | 3º | Aprovação QA + 2h de monitoramento |

---

## Plano de Testes

### Casos de Teste por US
[todos os CTs gerados pelo QA Lead]

### Testes de Regressão
[fluxos existentes a validar]

### Critérios de Go/No-Go para Produção
- [ ] Todos os CTs passando
- [ ] Regressão validada
- [ ] Sentry sem novos erros em staging
- [ ] Performance OK

---

## Checklist Final para a Camada 3

Antes de marcar como concluído, verificar:
- [ ] Todos os testes passando
- [ ] ESLint e TypeScript sem erros
- [ ] Health check funcionando
- [ ] Deploy em dev funcionando
- [ ] Deploy em staging funcionando
- [ ] Casos de teste de aceite validados
- [ ] Deploy em produção executado
- [ ] Monitoramento ativo (Datadog + Sentry)
- [ ] Sem erros críticos nas primeiras 2h
```
