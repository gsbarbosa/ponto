/**
 * Script do Google Apps Script para receber registros de ponto.
 * Cada usuário tem sua própria aba no formato nome_matrícula (ex.: João_020021209).
 * Na aba: linha 1 = nome do profissional; linha 2 = cabeçalhos; da linha 3 = Data | Entrada | Saída
 *
 * Como configurar:
 * 1. Crie uma planilha no Google Sheets
 * 2. Extensões > Apps Script
 * 3. Cole este código, salve e execute uma vez para autorizar
 * 4. Implantar > Nova implantação > Aplicativo da Web
 * 5. Use a URL gerada no app Flutter
 */

// Cores: Data | Entrada | Saída
const CORES_COLUNAS = ['#f9cb9c', '#a4c2f4', '#d5a6bd'];
const LARGURA_COLUNA = 180;
const NUM_COLUNAS = 3;

function formatarPlanilha(sheet) {
  const lastRow = sheet.getLastRow();
  const numRows = Math.max(lastRow + 1, 100);
  const range = sheet.getRange(1, 1, numRows, 3);
  const backgrounds = [];
  for (let r = 0; r < numRows; r++) {
    backgrounds.push([CORES_COLUNAS[0], CORES_COLUNAS[1], CORES_COLUNAS[2]]);
  }
  range.setBackgrounds(backgrounds);
  range.setHorizontalAlignment(SpreadsheetApp.HorizontalAlignment.LEFT);
  sheet.getRange(1, 1, 1, 3).setFontWeight(null);
  sheet.setColumnWidths(1, 3, LARGURA_COLUNA);
  SpreadsheetApp.flush();
}

function doGet() {
  return ContentService
    .createTextOutput(JSON.stringify({ ok: true, mensagem: 'Script Ponto ativo. Use POST para registrar.' }))
    .setMimeType(ContentService.MimeType.JSON);
}

/** Normaliza data para dd/MM/yyyy (com zero à esquerda) para comparação consistente. */
function normalizarDataStr(val, timezone) {
  if (!val) return '';
  if (typeof val === 'object' && val.getTime) {
    return Utilities.formatDate(val, timezone || Session.getScriptTimeZone(), 'dd/MM/yyyy');
  }
  var s = String(val).trim();
  var parts = s.split(/[\/\-\.]/);
  if (parts.length !== 3) return s;
  var d = parseInt(parts[0], 10);
  var m = parseInt(parts[1], 10);
  var y = parseInt(parts[2], 10);
  if (isNaN(d) || isNaN(m) || isNaN(y)) return s;
  return (d < 10 ? '0' + d : '' + d) + '/' + (m < 10 ? '0' + m : '' + m) + '/' + y;
}

function doPost(e) {
  try {
    const dados = JSON.parse(e.postData.contents);
    const matricula = (dados.matricula || '').toString().trim();
    const profissional = (dados.profissional || '').toString().trim();
    const tipo = (dados.tipo || '').toUpperCase();
    const data = dados.data || '';
    const hora = dados.hora || '';

    if (!matricula) {
      return ContentService
        .createTextOutput(JSON.stringify({ ok: false, erro: 'Matrícula obrigatória' }))
        .setMimeType(ContentService.MimeType.JSON);
    }

    // Nome da aba = nome_matricula (caracteres inválidos no nome são trocados por _; máx. 100 caracteres)
    const nomeSanitizado = (profissional || 'SemNome').replace(/[\\\/\?\*\[\]:]/g, '_').trim() || 'SemNome';
    const nomeAba = (nomeSanitizado + '_' + matricula).substring(0, 100);
    const ss = SpreadsheetApp.getActiveSpreadsheet();
    let sheet = ss.getSheetByName(nomeAba);

    if (!sheet) {
      sheet = ss.insertSheet(nomeAba);
      sheet.getRange(1, 1).setValue('Nome: ' + (profissional || '-'));
      sheet.getRange(2, 1, 2, NUM_COLUNAS).setValues([['Data', 'Entrada', 'Saída']]);
    }
    if (profissional) {
      sheet.getRange(1, 1).setValue('Nome: ' + profissional);
    }

    const dataCol = 1;
    const entradaCol = 2;
    const saidaCol = 3;
    const headerRow1 = sheet.getRange(1, 1).getValue();
    const isFormatoNovo = (typeof headerRow1 === 'string' && headerRow1.indexOf('Nome:') === 0);
    const primeiraLinhaDados = isFormatoNovo ? 3 : 2;

    const tz = Session.getScriptTimeZone();
    const dataNormalizada = normalizarDataStr(data, tz) || data;

    const ultimaLinha = sheet.getLastRow();
    let linhaData = -1;

    if (ultimaLinha >= primeiraLinhaDados) {
      const colData = sheet.getRange(primeiraLinhaDados, dataCol, ultimaLinha, dataCol).getValues();
      for (let i = 0; i < colData.length; i++) {
        const val = colData[i][0];
        const celulaStr = normalizarDataStr(val, tz);
        if (celulaStr && celulaStr === dataNormalizada) {
          linhaData = i + primeiraLinhaDados;
          break;
        }
      }
    }

    if (linhaData < 0) {
      linhaData = ultimaLinha < primeiraLinhaDados ? primeiraLinhaDados : ultimaLinha + 1;
      const celData = sheet.getRange(linhaData, dataCol);
      celData.setValue(dataNormalizada);
      celData.setNumberFormat('@'); // mantém como texto para não virar data em outro formato
    }

    if (tipo === 'ENTRAR') {
      sheet.getRange(linhaData, entradaCol).setValue(hora);
    } else if (tipo === 'SAIR') {
      sheet.getRange(linhaData, saidaCol).setValue(hora);
    }

    sheet.getRange(linhaData, 1, linhaData, NUM_COLUNAS)
      .setHorizontalAlignment(SpreadsheetApp.HorizontalAlignment.LEFT);

    formatarPlanilha(sheet);

    return ContentService
      .createTextOutput(JSON.stringify({ ok: true }))
      .setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService
      .createTextOutput(JSON.stringify({ ok: false, erro: err.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}
