# Output Template — Camada 3: Registro de Conclusão

Preencha ao finalizar a demanda. Este é o registro de que a feature foi entregue em produção.

---

```markdown
# REGISTRO DE CONCLUSÃO

## Metadados
- **ID da Demanda:** [mesmo ID do início]
- **Título:** [nome da feature]
- **Data de Conclusão:** [data]
- **Fase:** [1 de N / única]

---

## O que foi Entregue
[3-5 linhas descrevendo o que foi implementado]

---

## Serviços Modificados

| Serviço | Tipo de Alteração | Branch/MR |
|---------|------------------|-----------|
| [nome] | nova feature / bugfix / config | [link MR] |

---

## Resultado dos Testes

### Automatizados
- Unitários: [X passando / Y total]
- E2E: [X passando / Y total]
- Coverage: [X%]

### Manuais em Staging
| CT | Resultado |
|----|-----------|
| CT-001.1 | ✅ PASSOU |
| CT-001.2 | ✅ PASSOU |

### Regressão
- [ ] Fluxos impactados validados

---

## Deploy

| Ambiente | Data/Hora | Status |
|----------|-----------|--------|
| dev | [data] | ✅ OK |
| staging | [data] | ✅ OK |
| produção | [data] | ✅ OK |

---

## Monitoramento Pós-Deploy (2h)

- **Sentry:** [sem novos erros / X erros — status]
- **Datadog:** [latência p95: Xms / erros: Y%]
- **Saúde do serviço:** [OK / degradado]

---

## Decisão Final

- **Status:** ✅ CONCLUÍDO / ⚠️ CONCLUÍDO COM RESSALVAS / ❌ REVERTIDO
- **Observações:** [se houver]

---

## Pendências (se houver)
- [ ] [item que ficou para próxima iteração]
```
