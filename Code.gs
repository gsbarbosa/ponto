/**
 * Script do Google Apps Script para receber registros de ponto.
 * Cada profissional tem sua própria aba; cada linha é um dia.
 * Colunas: Data | Entrada | Saída | Observação
 *
 * Como configurar:
 * 1. Crie uma planilha no Google Sheets
 * 2. Extensões > Apps Script
 * 3. Cole este código, salve e execute uma vez para autorizar
 * 4. Implantar > Nova implantação > Aplicativo da Web
 * 5. Use a URL gerada no app Flutter
 */

function doGet() {
  return ContentService
    .createTextOutput(JSON.stringify({ ok: true, mensagem: 'Script Ponto ativo. Use POST para registrar.' }))
    .setMimeType(ContentService.MimeType.JSON);
}

function doPost(e) {
  try {
    const dados = JSON.parse(e.postData.contents);
    const profissional = (dados.profissional || '').toString().trim();
    const tipo = (dados.tipo || '').toUpperCase();
    const data = dados.data || '';
    const hora = dados.hora || '';

    if (!profissional) {
      return ContentService
        .createTextOutput(JSON.stringify({ ok: false, erro: 'Profissional obrigatório' }))
        .setMimeType(ContentService.MimeType.JSON);
    }

    const ss = SpreadsheetApp.getActiveSpreadsheet();
    let sheet = ss.getSheetByName(profissional);

    if (!sheet) {
      sheet = ss.insertSheet(profissional);
      sheet.getRange(1, 1, 1, 4).setValues([['Data', 'Entrada', 'Saída', 'Observação']]);
      sheet.getRange(1, 1, 1, 4).setFontWeight('bold');
    }

    const dataCol = 1;
    const entradaCol = 2;
    const saidaCol = 3;

    const ultimaLinha = sheet.getLastRow();
    let linhaData = -1;

    if (ultimaLinha >= 1) {
      const colData = sheet.getRange(2, dataCol, ultimaLinha + 1, dataCol).getValues();
      for (let i = 0; i < colData.length; i++) {
        const val = colData[i][0];
        const celulaStr = val ? (typeof val === 'object' && val.getTime ? Utilities.formatDate(val, Session.getScriptTimeZone(), 'dd/MM/yyyy') : String(val)) : '';
        if (celulaStr === data) {
          linhaData = i + 2;
          break;
        }
      }
    }

    if (linhaData < 0) {
      linhaData = (ultimaLinha || 1) + 1;
      sheet.getRange(linhaData, dataCol).setValue(data);
    }

    if (tipo === 'ENTRAR') {
      sheet.getRange(linhaData, entradaCol).setValue(hora);
    } else if (tipo === 'SAIR') {
      sheet.getRange(linhaData, saidaCol).setValue(hora);
    }

    return ContentService
      .createTextOutput(JSON.stringify({ ok: true }))
      .setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService
      .createTextOutput(JSON.stringify({ ok: false, erro: err.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}
