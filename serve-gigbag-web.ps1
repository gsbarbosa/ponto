param(
  [int]$Port = 8080,
  [string]$Root = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Root)) {
  $Root = (Join-Path $PSScriptRoot "gigbag_app\build\web")
}

if (-not (Test-Path $Root)) {
  throw "Diretório não encontrado: $Root"
}

$listener = New-Object System.Net.HttpListener
$prefix = "http://localhost:$Port/"
$listener.Prefixes.Add($prefix)
$listener.Start()

Write-Host "Servindo $Root em $prefix"
Write-Host "Ctrl+C para parar."

function Get-ContentType([string]$path) {
  switch ([IO.Path]::GetExtension($path).ToLowerInvariant()) {
    ".html" { "text/html; charset=utf-8" }
    ".js" { "application/javascript; charset=utf-8" }
    ".css" { "text/css; charset=utf-8" }
    ".json" { "application/json; charset=utf-8" }
    ".png" { "image/png" }
    ".jpg" { "image/jpeg" }
    ".jpeg" { "image/jpeg" }
    ".gif" { "image/gif" }
    ".svg" { "image/svg+xml" }
    ".ico" { "image/x-icon" }
    ".wasm" { "application/wasm" }
    ".map" { "application/json; charset=utf-8" }
    ".txt" { "text/plain; charset=utf-8" }
    default { "application/octet-stream" }
  }
}

try {
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    try {
      $req = $ctx.Request
      $res = $ctx.Response

      $rawPath = $req.Url.AbsolutePath
      $path = [Uri]::UnescapeDataString($rawPath.TrimStart("/"))
      if ([string]::IsNullOrWhiteSpace($path)) { $path = "index.html" }

      # bloqueia path traversal
      if ($path.Contains("..")) {
        $res.StatusCode = 400
        $bytes = [Text.Encoding]::UTF8.GetBytes("Bad Request")
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
        $res.Close()
        continue
      }

      $file = Join-Path $Root $path
      if (-not (Test-Path $file -PathType Leaf)) {
        # fallback típico de SPA: retorna index.html
        $file = Join-Path $Root "index.html"
      }

      $res.StatusCode = 200
      $res.ContentType = (Get-ContentType $file)

      $data = [IO.File]::ReadAllBytes($file)
      $res.ContentLength64 = $data.Length
      $res.OutputStream.Write($data, 0, $data.Length)
      $res.Close()
    } catch {
      try {
        $ctx.Response.StatusCode = 500
        $bytes = [Text.Encoding]::UTF8.GetBytes("Internal Server Error")
        $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
        $ctx.Response.Close()
      } catch {}
    }
  }
} finally {
  if ($listener) {
    $listener.Stop()
    $listener.Close()
  }
}

