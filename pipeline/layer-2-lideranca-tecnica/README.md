# Camada 2 — Liderança Técnica

Esta camada transforma o PRD de negócio em uma estratégia técnica completa, cobrindo do design de solução até o plano de deploy em produção.

---

## Knowledge Base

O diferencial desta camada é o **conhecimento organizacional pré-carregado**. Todos os agentes conhecem a stack, os padrões e as decisões arquiteturais da Kenlo.

| Documento | Conteúdo |
|-----------|---------|
| [stack-e-padroes.md](./knowledge-base/stack-e-padroes.md) | TypeScript, NestJS, estrutura de módulos, naming, observabilidade |
| [arquitetura.md](./knowledge-base/arquitetura.md) | Microserviços, gateway GraphQL, dependências entre serviços |
| [infraestrutura.md](./knowledge-base/infraestrutura.md) | GCP, GKE, Helm, Cloud Run, Istio |
| [bancos-de-dados.md](./knowledge-base/bancos-de-dados.md) | Critérios de escolha, padrões por banco, migrations |
| [cicd.md](./knowledge-base/cicd.md) | GitLab CI, template compartilhado, deploy pipeline |
| [convencoes.md](./knowledge-base/convencoes.md) | Naming, endpoints, commits, logs, responses |

---

## Agentes

| Agente | Responsabilidade |
|--------|-----------------|
| [CTO](./agents/cto.md) | Decisões estratégicas de arquitetura e risco |
| [Arquiteto](./agents/arquiteto.md) | Design técnico: APIs, modelos de dados, fluxos |
| [Security](./agents/security.md) | Segurança, LGPD, OWASP, autenticação |
| [Cloud Engineer](./agents/cloud-engineer.md) | Infra, Helm, CI/CD, rollout, rollback |
| [Tech Lead](./agents/tech-lead.md) | Plano de implementação sequenciado |
| [QA Lead](./agents/qa-lead.md) | Estratégia e casos de teste |

---

## Fluxo de Execução

```
PRD Final (Camada 1)
    │
    ├──▶ CTO → Decisões Estratégicas
    │
    └──▶ (com CTO) ──▶ Arquiteto → Design Técnico
                            │
                ┌───────────┼──────────────┐
                ▼           ▼              ▼
            Security   Cloud Eng      Tech Lead
                │           │              │
                └───────────┴──────────────┘
                            │
                        QA Lead → Plano de Testes
                            │
                            ▼
                   Output Template L2→L3
```

**CTO e Arquiteto são sequenciais** — as decisões do CTO informam o design.
**Security, Cloud Engineer e Tech Lead são paralelos** — todos recebem o design do Arquiteto.
**QA Lead** roda por último, com o plano de implementação do Tech Lead.

---

## Critério de Saída

A camada só avança quando:
- [ ] Decisões arquiteturais tomadas e documentadas
- [ ] Design técnico completo (APIs, dados, fluxos)
- [ ] Riscos de segurança mapeados e mitigados
- [ ] Plano de infra e CI/CD definido
- [ ] Plano de implementação sequenciado
- [ ] Casos de teste escritos
- [ ] Aprovação humana da estratégia técnica

---

## Arquivos

- [orchestrator.md](./orchestrator.md) — Como orquestrar os agentes desta camada
- [output-template.md](./output-template.md) — Template do output para a Camada 3
