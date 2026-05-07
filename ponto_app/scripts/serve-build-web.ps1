$ErrorActionPreference = "Stop"

$Port = if ($env:PORT -match '^\d+$') { [int]$env:PORT } else { 5173 }
$HostName = if ([string]::IsNullOrWhiteSpace($env:HOSTNAME)) { "127.0.0.1" } else { $env:HOSTNAME }
$Root = Join-Path $PSScriptRoot "..\\build\\web"
$Root = [System.IO.Path]::GetFullPath($Root)

if (-not (Test-Path $Root -PathType Container)) {
  throw "Pasta de build web não encontrada: $Root. Rode: flutter build web"
}

function Get-ContentType([string]$Path) {
  switch ([System.IO.Path]::GetExtension($Path).ToLowerInvariant()) {
    ".html" { "text/html; charset=utf-8" }
    ".js" { "text/javascript; charset=utf-8" }
    ".css" { "text/css; charset=utf-8" }
    ".json" { "application/json; charset=utf-8" }
    ".png" { "image/png" }
    ".jpg" { "image/jpeg" }
    ".jpeg" { "image/jpeg" }
    ".svg" { "image/svg+xml" }
    ".ico" { "image/x-icon" }
    ".wasm" { "application/wasm" }
    default { "application/octet-stream" }
  }
}

$Listener = [System.Net.HttpListener]::new()
$Listener.Prefixes.Add("http://$HostName`:$Port/")
$Listener.Start()

Write-Host "Serving $Root on http://$HostName`:$Port"

try {
  while ($Listener.IsListening) {
    $Ctx = $Listener.GetContext()
    try {
      $Path = $Ctx.Request.Url.AbsolutePath.TrimStart("/")
      if ([string]::IsNullOrWhiteSpace($Path)) { $Path = "index.html" }

      $FilePath = Join-Path $Root $Path
      if (-not (Test-Path $FilePath -PathType Leaf)) {
        # SPA fallback
        $FilePath = Join-Path $Root "index.html"
      }

      $Bytes = [System.IO.File]::ReadAllBytes($FilePath)
      $Ctx.Response.ContentType = Get-ContentType $FilePath
      $Ctx.Response.ContentLength64 = $Bytes.Length
      $Ctx.Response.OutputStream.Write($Bytes, 0, $Bytes.Length)
    } catch {
      $Ctx.Response.StatusCode = 500
    } finally {
      $Ctx.Response.OutputStream.Close()
    }
  }
} finally {
  $Listener.Stop()
  $Listener.Close()
}

