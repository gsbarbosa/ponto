# Configuração do Ponto - Google Sheets

Para o app enviar os registros de ENTRAR e SAIR para uma planilha do Google, siga estes passos:

## 1. Criar a planilha no Google Sheets

1. Acesse [sheets.google.com](https://sheets.google.com)
2. Crie uma nova planilha
3. O script cria automaticamente uma aba para cada profissional, com colunas: `Data` | `Entrada` | `Saída` | `Observação`

## 2. Criar o script do Google Apps Script

1. Na planilha, vá em **Extensões** → **Apps Script**
2. Apague o código existente e cole o conteúdo do arquivo `Code.gs` (na raiz do projeto `ponto`)
3. Salve o projeto (Ctrl+S ou ícone de disquete)
4. Na primeira execução, clique em **Executar** (▶) e autorize o script com sua conta Google
5. Vá em **Implantar** → **Nova implantação** → escolha **Aplicativo da Web**
6. Defina:
   - **Executar como**: Eu
   - **Quem tem acesso**: Qualquer pessoa
7. Clique em **Implantar** e copie a URL gerada (algo como `https://script.google.com/macros/s/XXXXX/exec`)

## 3. Configurar o app Flutter

1. Abra `lib/main.dart`
2. Substitua `SEU_SCRIPT_ID` na constante `_urlScript` pela URL completa que você copiou no passo anterior (ou apenas o ID do script se preferir montar a URL)
3. A URL completa deve ficar assim:
   ```dart
   static const _urlScript = 'https://script.google.com/macros/s/XXXXXXXX/exec';
   ```

## 4. Associar o script à planilha

O script usa a planilha "ativa" por padrão (a que estava aberta quando você criou o Apps Script). Se você criou o script a partir da planilha correta, já está vinculado.

Pronto! Execute o app e teste o botão ENTRAR/SAIR.

---

## Webapp

O app pode rodar como webapp (PWA) no navegador.

### Rodar localmente
```bash
flutter run -d chrome
```

### Build para produção
```bash
flutter build web
```

A pasta `build/web` conterá os arquivos estáticos. Publique em qualquer hospedagem:
- **Firebase Hosting**: `firebase deploy`
- **Netlify / Vercel**: arraste a pasta `build/web` ou configure o build
- **Servidor próprio**: sirva os arquivos com nginx, Apache, etc.

### GitHub Pages
O repositório inclui `.github/workflows/deploy.yml`. Ao fazer push para a branch `main`:
1. O workflow faz build do Flutter web
2. Publica em `https://seu-usuario.github.io/nome-do-repositorio`

**Antes do primeiro deploy:** em **Settings → Pages**, escolha **GitHub Actions** como fonte do site.

Se sua branch padrão for `master`, altere `branches: - main` para `branches: - master` no workflow.

### CORS
O app usa `Content-Type: text/plain` nas requisições para evitar preflight CORS com o Google Apps Script. Se ainda houver erro de CORS ao publicar, garanta que o script está implantado com **"Quem tem acesso: Qualquer pessoa"**.
