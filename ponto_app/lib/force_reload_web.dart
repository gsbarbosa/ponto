import 'dart:html' as html;

void forceReload() {
  // Reload "hard" não é garantido em todos os browsers, mas isso força
  // uma navegação/reload mesmo em modo "app"/bookmark.
  html.window.location.reload();
}

