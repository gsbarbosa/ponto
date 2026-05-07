# Intake — Gigbag (Checklist de Equipamentos por Evento)

## Identificação

- ID da demanda: A DEFINIR
- Título curto: Gigbag — agenda de eventos + checklist de equipamentos (ida/volta)
- Data: 2026-04-27
- Solicitante: A DEFINIR
- Prioridade percebida: A DEFINIR

---

## A Ideia

**Gigbag** é um app que ajuda **músicos, artistas e técnicos** a organizar os equipamentos ao sair para um evento/show.

O app funciona como uma **agenda de eventos** onde, a partir do inventário de equipamentos do usuário, ele cria um evento e define **quais itens serão levados**. No dia do evento (e na volta), o app conduz um **briefing/checklist guiado** para garantir que nada seja esquecido.

---

## Evidência do Problema

- Em dias de evento é comum **esquecer itens** (cabo, fonte, pedestal, etc.), gerando atraso, estresse e impacto no show/produção.
- O processo costuma ser **manual e inconsistente** (memória/planilha/anotações), especialmente quando a lista varia por evento.

---

## Contexto do Problema

Hoje (pelo briefing disponível):
- Usuário tem equipamentos, mas a conferência antes de sair/ir embora depende de memória/rotina.
- As necessidades variam por evento (nem sempre leva tudo).

Workaround atual:
- A DEFINIR (provável: checklist mental, lista no celular, planilha, papel).

Por que agora:
- A DEFINIR

---

## Usuários e Casos de Uso

Quem usa:
- **Músicos/Artistas**
- **Técnicos** (som/luz/backline)

Principais casos:
- **Planejar**: cadastrar inventário de equipamentos.
- **Preparar evento**: criar evento e selecionar itens que serão levados.
- **Antes de sair (ida)**: seguir checklist e marcar item a item conforme recolhe.
- **Antes de ir embora (volta)**: repetir o processo reverso para recolher tudo ao final.
- **Conferência final**: receber alerta/feedback de itens faltantes.

---

## Escopo Preliminar (MVP)

MVP sugerido a partir do briefing:

1. **Inventário**
   - CRUD de equipamentos (nome do item; demais campos a definir).
2. **Agenda/Eventos**
   - Criar evento (data/hora/local a definir).
   - Selecionar equipamentos para levar no evento (lista por evento).
3. **Briefing/Checklist guiado (ida)**
   - Percorrer lista do evento item a item.
   - Permitir marcar como “recolhido/ok”.
   - Ao final, indicar se faltou algo.
4. **Briefing/Checklist guiado (volta)**
   - Processo reverso ao fim do evento, com a mesma lógica de marcação e conferência.

---

## Fora de Escopo (por enquanto)

- Compartilhamento/collab em tempo real (equipe)
- Controle de estoque por quantidade/lotes
- Integração com calendários externos (Google/Apple)
- Gestão financeira/contratos do evento
- Multi-usuário e permissões (a menos que seja requisito)
- Offline-first avançado (pode ser desejável; a definir)

---

## Critérios de Sucesso

- Usuário consegue:
  - Cadastrar seus equipamentos
  - Criar um evento e selecionar o que vai levar
  - Executar briefing de ida e de volta, com **feedback claro** do que faltou
- Redução percebida de esquecimentos (qualitativo) e aumento de confiança no processo

---

## Requisitos e Decisões em Aberto (para completar o intake)

- **Plataforma**: iOS/Android/Web? (a definir)
- **Autenticação**: local (sem login) vs conta (a definir)
- **Armazenamento**: local (SQLite/IndexedDB) vs nuvem/sync (a definir)
- **Offline**: obrigatório? (muito provável em locais de evento; a definir)
- **Modelo de equipamento**: categorias, tags, quantidades, fotos, casos (a definir)
- **Modelo de evento**: campos (local, horário, observações), recorrência (a definir)
- **UX do checklist**:
  - ordem (manual, por categoria, “mais crítico primeiro”)
  - busca/atalhos
  - confirmação de conclusão e resumo (a definir)
- **Monetização**: gratuito, freemium, assinatura, compra única (a definir)
- **Privacidade/LGPD**: dados coletados (a definir)

---

## Entregáveis Esperados (para iniciar o projeto)

- Definição do MVP fechado (inventário + eventos + briefings ida/volta)
- Fluxos e telas principais (wireframe de alto nível)
- Modelo de dados (equipamento, evento, checklist/execução)
- Protótipo navegável ou primeira versão funcional (a definir conforme stack)

---

## Instrução Final

Com base neste intake, prossiga para:

1. Definir o **MVP exato** (telas + fluxos + dados mínimos)
2. Propor a **arquitetura mais simples** para entregar rápido
3. Priorizar UX do checklist (ida/volta) e clareza do “faltou X”