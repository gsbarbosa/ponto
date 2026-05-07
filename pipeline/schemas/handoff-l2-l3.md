# Schema de Handoff — Camada 2 → Camada 3

Este é o contrato entre a Camada Técnica e a Camada de Desenvolvimento. Deve ser preenchido ao final da Camada 2 e aprovado antes de iniciar a implementação.

---

## Instruções de Uso

1. Copie o template abaixo
2. Preencha todos os campos obrigatórios
3. Salve como: `tasks/[KNL-YYYY-NNN]-handoff-l2-l3.md`
4. Valide o checklist ao final

---

## Template

```markdown
# Handoff L2 → L3
**ID:** KNL-[YYYY]-[NNN]                    *obrigatório
**Título:** [nome curto]                     *obrigatório
**Data:** [YYYY-MM-DD]                       *obrigatório
**Fase:** [1 de N / única]                   *obrigatório

---

## 1. Resumo da Solução Técnica             *obrigatório

[3-5 linhas descrevendo o que será implementado, onde e como.
Ex: "Será adicionado um endpoint POST /api/v1/proposals/:id/sign
no proposal-api que integra com o kenlo-sign-api via HTTP.
Notificação de assinatura via Pub/Sub para o kenlo-notify."]

---

## 2. Decisões Arquiteturais               *obrigatório

| Decisão              | Escolha              | Motivo                        |
|----------------------|----------------------|-------------------------------|
| Serviço principal    | [nome-do-servico]    | [por que este serviço]        |
| Banco de dados       | MongoDB / PG / MSSQL | [por que este banco]          |
| Comunicação          | sync HTTP / Pub/Sub  | [por que este padrão]         |
| Deploy               | GKE / Cloud Run      | [por que]                     |
| Novo serviço?        | sim / não            | [justificativa se sim]        |

---

## 3. Design da Solução                    *obrigatório

### 3.1 Fluxo
```
[diagrama ASCII do fluxo completo de ponta a ponta]
```

### 3.2 Contratos de API

#### [MÉTODO] /api/v1/[endpoint]
**Autenticação:** Bearer JWT obrigatório / opcional / não requerido
**Request Body:**
```json
{
  "campo": "tipo — obrigatório/opcional"
}
```
**Response [status]:**
```json
{
  "data": { ... }
}
```
**Errors:**
- 400: [quando]
- 401: sem autenticação
- 404: [quando]
- 409: [quando]
- 500: erro interno

[repetir para cada endpoint]

### 3.3 Modelo de Dados

#### [NomeEntity] — [collection/tabela]
```
Campo           Tipo        Obrigatório  Índice   Descrição
externalId      String      ✅           unique   ID externo
name            String      ✅           —        Nome
status          Enum        ✅           sim      active|inactive
createdAt       Date        auto         —        timestamps
updatedAt       Date        auto         —        timestamps
```

[repetir para cada entidade nova/modificada]

### 3.4 Eventos Pub/Sub (se aplicável)

**Tópico:** `kenlo.[dominio].[evento]`
**Payload:**
```json
{
  "eventId": "uuid",
  "eventType": "string",
  "occurredAt": "ISO8601",
  "data": { ... }
}
```
- Produtor: [serviço]
- Consumidores: [lista]

---

## 4. Plano de Implementação               *obrigatório

### Fase [N]: [Nome da Fase]
**Objetivo:** [o que esta fase entrega]

#### Tarefa [N.N] — [Título]
- **Serviço:** [nome]
- **Tipo:** Backend / Frontend / Infra / Config
- **Depende de:** [tarefa X.X / nenhuma]
- **O que fazer:** [descrição detalhada]
- **Arquivos a criar/modificar:**
  - `[caminho/arquivo]` — [o que fazer]
- **Padrões obrigatórios:** [lista]
- **Armadilhas:** [o que evitar]
- **Pronto quando:**
  - [ ] [critério 1]
  - [ ] [critério 2]

[repetir para cada tarefa]

---

## 5. Requisitos de Segurança              *obrigatório

Todos os itens abaixo DEVEM ser implementados:

- [ ] [requisito de autenticação/autorização]
- [ ] [requisito de dados sensíveis/LGPD]
- [ ] [proteção contra vulnerabilidade X]
- [ ] [campos sensíveis não aparecem em logs]
- [ ] [secrets via variáveis de ambiente]

---

## 6. Configuração de Infraestrutura       *obrigatório

### 6.1 Helm (chart-v2)
```yaml
# valores para este deploy
replicaCount: [N]
resources:
  requests:
    cpu: "[Xm]"
    memory: "[XMi]"
  limits:
    cpu: "[Xm]"
    memory: "[XMi]"
autoscaling:
  minReplicas: [N]
  maxReplicas: [N]
```

### 6.2 Variáveis de Ambiente

| Variável            | Tipo    | Descrição                    |
|---------------------|---------|------------------------------|
| [VARIAVEL_1]        | secret  | [para que serve]             |
| [VARIAVEL_2]        | config  | [para que serve]             |

### 6.3 GitLab CI (se novo serviço)
```yaml
include:
  - project: 'kenlo1/system-gcp/cicd-template'
    ref: 'ingress'
    file: '/template.yml'

variables:
  KUBERNETES_CLUSTER_ZONE: us-east1
  NAMESPACE: [namespace]
  APP_NAME: [nome]
  CHART_PATH: ./chart-v2
  HELM_VERSION: "3.12.0"
```

---

## 7. Plano de Rollout                     *obrigatório

| Ambiente   | Ordem | Critério para Avançar                        |
|------------|-------|----------------------------------------------|
| dev        | 1º    | Health check OK, endpoints respondendo       |
| staging    | 2º    | Todos os CTs passando, aprovação QA          |
| produção   | 3º    | GO do QA, 2h de monitoramento sem erros      |

**Ordem de deploy entre serviços (se múltiplos):**
1. [serviço com migration de banco]
2. [serviço dependência]
3. [serviço principal]
4. [graphql-api se schema mudou]

**Rollback:**
```bash
helm rollback [app-name] [revision] -n [namespace]
```

---

## 8. Plano de Testes                      *obrigatório

### 8.1 Casos de Teste

#### US-001: [título]
| CT       | Descrição                | Tipo      | Prioridade |
|----------|--------------------------|-----------|------------|
| CT-001.1 | [caminho feliz]          | E2E       | P1         |
| CT-001.2 | [validação de entrada]   | E2E       | P1         |
| CT-001.3 | [edge case]              | E2E       | P2         |

[repetir por US]

### 8.2 Testes de Regressão
| Fluxo          | Serviço       | Por que validar            |
|----------------|---------------|---------------------------|
| [fluxo X]      | [serviço]     | [impacto potencial]        |

### 8.3 Critérios de Go/No-Go para Produção
- [ ] Todos os CTs P1 passando
- [ ] Sem bugs de severidade alta abertos
- [ ] Regressão validada
- [ ] Sentry sem novos erros em staging por 1h
- [ ] Performance p95 < 500ms

---

## 9. Checklist de Aprovação para Iniciar  *obrigatório

- [ ] Decisões arquiteturais documentadas e aprovadas
- [ ] Design técnico completo (API, dados, fluxo)
- [ ] Segurança revisada
- [ ] Infra configurada
- [ ] Plano de implementação sequenciado
- [ ] Plano de testes com casos escritos
- [ ] Aprovação humana concedida
- [ ] Pronto para a Camada 3
```
