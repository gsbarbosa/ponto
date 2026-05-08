# Schema de Handoff — Camada 1 → Camada 2

Este é o contrato entre a Camada de Negócio e a Camada Técnica. Deve ser preenchido ao final da Camada 1 e aprovado antes de iniciar a Camada 2.

---

## Instruções de Uso

1. Copie o template abaixo
2. Preencha todos os campos obrigatórios (marcados com `*`)
3. Campos opcionais preencha quando aplicável
4. Valide o checklist ao final
5. Salve como: `tasks/[KNL-YYYY-NNN]-handoff-l1-l2.md`

---

## Template

```markdown
# Handoff L1 → L2
**ID:** KNL-[YYYY]-[NNN]                    *obrigatório
**Título:** [nome curto]                     *obrigatório
**Data:** [YYYY-MM-DD]                       *obrigatório
**Solicitante:** [nome]                      *obrigatório
**Prioridade:** alta / média / baixa         *obrigatório
**Prazo desejado:** [data ou "sem prazo"]    *obrigatório

---

## 1. Validação de Negócio                  *obrigatório

**Mercado:**
- Demanda validada: sim / não
- Concorrentes: [lista ou "sem concorrentes diretos"]
- Timing: cedo demais / momento certo / atrasado

**Valor:**
- Score de prioridade: [X.X / 5.0]
- Impacto principal: retenção / aquisição / receita / diferenciação
- Recomendação: prosseguir agora / prosseguir depois

---

## 2. Problema                              *obrigatório

[Descrição clara e objetiva do problema que será resolvido.
Sem solução ainda — apenas o problema.]

---

## 3. Solução                               *obrigatório

[Descrição da solução em linguagem de negócio.
Sem detalhes técnicos — apenas o que faz e para quem.]

---

## 4. Personas                              *obrigatório

- **Usuário principal:** [quem usa a feature]
- **Decisor:** [quem aprova / autoriza]
- **Impactados:** [quem é afetado indiretamente]

---

## 5. Escopo MVP                            *obrigatório

**IN — deve ser implementado:**
- [ ] [funcionalidade 1]
- [ ] [funcionalidade 2]

**OUT — não será implementado agora:**
- [funcionalidade X] — motivo: [...]

---

## 6. User Stories                          *obrigatório

### US-001: [título]
**Como** [persona]
**Quero** [ação]
**Para** [objetivo]

**Critérios de Aceite:**
- Dado [contexto], quando [ação], então [resultado esperado]
- Dado [erro], quando [ação], então [tratamento esperado]

[repetir para cada US]

---

## 7. Regras de Negócio                     *obrigatório

| ID     | Regra                          | Exceções           |
|--------|--------------------------------|--------------------|
| RN-001 | [descrição da regra]           | [exceções ou "—"]  |

---

## 8. Estados (se aplicável)                opcional

| Estado      | Descrição                  | Transições possíveis    |
|-------------|----------------------------|------------------------|
| [estado]    | [o que significa]          | → [próximos estados]   |

---

## 9. Notificações (se aplicável)           opcional

| Evento        | Destinatário | Canal              | Conteúdo resumido |
|---------------|--------------|--------------------|------------------|
| [evento]      | [quem]       | email/push/inbox   | [mensagem]        |

---

## 10. Integrações de Negócio               opcional

- [sistema externo]: [como é usado neste contexto]

---

## 11. Dados Sensíveis / LGPD               *obrigatório

- Coleta dados pessoais: sim / não
- Se sim: [quais dados e finalidade]
- Necessita auditoria: sim / não

---

## 12. Métricas de Sucesso                  *obrigatório

- [como saberemos que a feature foi bem-sucedida?]
- [o que vamos medir?]

---

## 13. Decisões para a Camada 2            opcional

[Questões técnicas que o negócio não deve responder.
A Camada 2 decide estas.]
- [ ] [questão técnica aberta]

---

## 14. Glossário                            opcional

- **[termo de domínio]:** [definição]

---

## Checklist de Aprovação

- [ ] Problema claramente descrito
- [ ] Solução em linguagem de negócio
- [ ] MVP com escopo fechado (IN e OUT)
- [ ] User stories com critérios de aceite
- [ ] Regras de negócio documentadas
- [ ] LGPD avaliado
- [ ] Métricas de sucesso definidas
- [ ] Aprovado pelo solicitante
- [ ] Pronto para a Camada 2
```
