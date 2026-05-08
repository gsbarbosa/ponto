# KNL-2026-OTN01 — Resumo de entrega

- **PRD (curto):** [PRD.md](./PRD.md)
- **Código:** diretório [`../../../web/`](../../../web/) (Next.js 15)
- **Mockups / prompts IA:** [`../../../web/MOCKUPS-IA.md`](../../../web/MOCKUPS-IA.md)
- **Deploy / env / QR:** [`../../../web/README.md`](../../../web/README.md)

## Checklist antes do show

1. [ ] Preencher `.env.local` (ou Vercel) com WhatsApp, e-mail e **links de pagamento** reais.
2. [ ] (Opcional) Trocar SVGs em `web/public/merch/` por imagens exportadas (ver MOCKUPS-IA).
3. [ ] Fazer deploy e definir `NEXT_PUBLIC_SITE_URL` com a URL final.
4. [ ] Gerar e testar o **QR** apontando para a URL de produção.
5. [ ] Fazer um teste de compra e de WhatsApp a partir de um celular.

## Handoff L2 → L3 (implícito)

Estratégia técnica: SPA estática, sem backend, env-only para links externos. Implementado em `web/`; critérios de aceite alinhados ao PRD (hero, 5 SKUs, CTAs, forma mailto, mobile-first).
