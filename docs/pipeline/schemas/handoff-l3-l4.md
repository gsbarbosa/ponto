# Schema — Handoff L3 → L4 (Desenvolvimento → Retrospectiva)

Este documento é o contrato de entrada da Camada 4. Preencha entre 1 e 4 semanas após o deploy em produção, quando houver dados de comportamento real do sistema.

---

## Metadados

- **ID da Demanda:**
- **Título:**
- **Data do Deploy em Produção:**
- **Data desta Retrospectiva:**
- **Responsável pelo preenchimento:**

---

## 1. Registro de Entrega (da Camada 3)

*(Cole o output-template.md preenchido da Camada 3)*

```
[output da Camada 3 aqui]
```

---

## 2. Métricas de Sucesso (da Camada 1)

*(Cole as métricas de sucesso definidas no PRD da Camada 1)*

| Métrica | Meta Definida | Resultado Real | Atingido? |
|---------|--------------|----------------|-----------|
| [métrica 1] | [meta] | [resultado] | ✅ / ❌ / ⏳ |
| [métrica 2] | [meta] | [resultado] | ✅ / ❌ / ⏳ |

---

## 3. Dados de Produção (após 1-4 semanas)

**Adoção:**
- Quantos usuários usaram a feature?
- Frequência de uso observada:
- Fluxo mais usado vs. esperado:

**Performance:**
- Latência p95 em produção:
- Taxa de erro em produção:
- Incidentes relacionados: (sim/não — se sim, descreva)

**Feedback de usuário (se coletado):**
```
[quotes, tickets de suporte, NPS, entrevistas pós-lançamento]
```

---

## 4. Desvios do Plano

**O que foi diferente do planejado na Camada 2?**
*(design técnico, arquitetura, infra, estimativas)*

```
[descreva divergências — se nenhuma, escreva "Nenhum desvio significativo"]
```

**A Camada 3 precisou improvisar em algum ponto?**
*(soluções não previstas no design, workarounds, decisões tomadas na hora)*

```
[descreva — se não, escreva "Não"]
```

**Houve escalada da Camada 3 para a Camada 2?**
*(re-trabalho de design durante implementação)*

- Sim / Não
- Se sim:

---

## 5. O que Funcionou Bem

*(práticas, decisões, padrões que devem ser repetidos)*

```
[lista livre]
```

---

## 6. O que Causou Atrito

*(qualquer coisa que tornou o processo mais lento, difícil ou arriscado)*

```
[lista livre — sem julgamento, foco em aprendizado]
```

---

## 7. Decisões que Merecem ser Registradas

*(preencha se houver — o Guardião do Conhecimento vai processar)*

| Decisão tomada | Alternativa descartada | Motivo | Categoria |
|---------------|----------------------|--------|-----------|
| [decisão] | [alternativa] | [motivo] | Arquitetura / DB / Infra / Processo |

---

## Checklist de Aprovação

- [ ] Dados de produção coletados (mínimo 1 semana pós-deploy)
- [ ] Métricas de sucesso avaliadas
- [ ] Desvios documentados (mesmo que "nenhum")
- [ ] Decisões dignas de registro identificadas
- [ ] Responsável assinou

**Se tudo marcado → avance para o orchestrator da Camada 4**
