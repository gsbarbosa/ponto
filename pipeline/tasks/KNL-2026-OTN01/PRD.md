# PRD — KNL-2026-OTN01 (curto) — Loja Othon Palace (landing + pré-venda)

**Data:** 2026-04-24 · **Prazo:** < 48h (show ao vivo) · **Prioridade:** alta

## Resumo executivo

Single page (vitrine) para a banda Othon Palace: identidade **indie/alt + noite + neon** (dossiê), **Drop 01** com 3–5 produtos em mockup, CTAs para **compra via link** (Mercado Pago ou Stripe) e **interesse** (WhatsApp ou e-mail), **mobile-first**, acessível via **QR** no show. Objetivo: validar demanda e primeiras conversões, sem e-commerce completo.

## Problema

Sem merch físico nem canal digital, a banda perde monetização e conexão com o público no show iminente.

## Personas

- Público no show / mobile (18–35, indie/alternativo).
- Banda: validar interesse, testar quais itens ressoam.

## Solução (MVP)

Uma **landing** estática/SSR leve (Next.js + Tailwind) com: hero, grid de produtos, preços, botões de ação, rodapé com redes; configuração via **variáveis de ambiente** para links de pagamento e WhatsApp. Deploy em Vercel/Netlify.

## IN (escopo)

- [x] Hero com identidade e CTA
- [x] Seção “Drop 01” com 5 SKUs (dados em código/config)
- [x] Placeholders visuais para mockups + doc de **prompts IA** para substituir imagens
- [x] “Comprar agora” → URL de Payment Link (env por produto ou padrão)
- [x] “Quero esse merch” → `wa.me` com texto pré-preenchido (env)
- [x] Formulário leve: opção `mailto:` / ou link para Google Forms (zero backend)
- [x] Mobile-first, acessibilidade básica (contraste, labels)
- [x] README: deploy, QR, `.env`

## OUT

- Carrinho, frete, estoque, painel, auth, checkout custom, backend próprio (conforme intake).

## User stories (aceite resumido)

| ID | Story | Aceite |
|----|--------|--------|
| US-1 | Visitante vê a banda e o drop | Hero + seção de produtos acima da dobra (mobile) |
| US-2 | Visitante inicia compra | Botão abre **nova aba** com URL pública de pagamento |
| US-3 | Visitante manifesta interesse | WhatsApp com mensagem contendo o produto |
| US-4 | Time publica no show | Site em HTTPS + instrução de gerar QR apontando para a URL de produção |

## Regras de negócio

| ID | Regra |
|----|--------|
| RN-1 | Nenhum dado de pagamento trafega no site — só redirecionamento para o provedor |
| RN-2 | Dados de contato: mínimo necessário; LGPD: aviso no rodapé (texto padrão) |

## Integrações

- Mercado Pago **ou** Stripe: **Payment Links** (URLs estáticas).
- WhatsApp Click to Chat (número E.164 sem + no path).

## Métricas de sucesso

- QR acessado no show; >0 cliques em compra ou interesse; feedback informal sobre estética.

## Decisões para Camada 2 (fechadas neste PRD curto)

- Stack: **Next.js 15 (App Router) + TypeScript + Tailwind**.
- Hospedagem: **Vercel** (recomendado) ou Netlify.
- Imagens: assets em `public/merch/` quando disponíveis; até lá placeholders.

---

# Handoff L1 → L2 (mínimo)

- **Requisitos não-funcionais:** TTFB aceitável (página leve), SEO básico (title, description, OG).
- **Segurança:** Sem segredos no client; só `NEXT_PUBLIC_*` para URLs públicas.
- **Riscos:** Prazo — priorizar entrega e troca de links em minutos via env.

**Implementação:** ver repositório `web/` (código) e `README.md` do projeto.
