import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const PontoApp());

// Cores do tema escuro (conforme layout)
const _kBackground = Color(0xFF1e1e1e);
const _kGrayBorder = Color(0xFF9e9e9e);
const _kGrayText = Color(0xFFb0b0b0);
const _kButtonFill = Color(0xFF2d2d2d);
const _kSairBlue = Color(0xFF4285F4);
const _kSairBlueLight = Color(0xFF60B0FF);

class PontoApp extends StatelessWidget {
  const PontoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ponto',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _kBackground,
        colorScheme: ColorScheme.dark(
          surface: _kBackground,
          primary: _kSairBlue,
          onSurface: _kGrayText,
        ),
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}

// Chaves para persistir sessão de login (sobrevive a F5 / reabrir app)
const _kPrefsLogado = 'ponto_logado';
const _kPrefsNome = 'ponto_nome';
const _kPrefsCodigo = 'ponto_codigo';

/// Controla a navegação: tela de login ou tela de ponto.
/// Sessão é salva em SharedPreferences para persistir ao recarregar (F5).
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _sessaoCarregada = false;
  bool _logado = false;
  String _nome = '';
  String _codigo = '';

  @override
  void initState() {
    super.initState();
    _carregarSessao();
  }

  Future<void> _carregarSessao() async {
    final prefs = await SharedPreferences.getInstance();
    final logado = prefs.getBool(_kPrefsLogado) ?? false;
    final nome = prefs.getString(_kPrefsNome) ?? '';
    final codigo = prefs.getString(_kPrefsCodigo) ?? '';
    if (mounted) {
      setState(() {
        _sessaoCarregada = true;
        _logado = logado && nome.isNotEmpty && codigo.isNotEmpty;
        _nome = nome;
        _codigo = codigo;
      });
    }
  }

  Future<void> _onLogin(String nome, String codigo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPrefsLogado, true);
    await prefs.setString(_kPrefsNome, nome.trim());
    await prefs.setString(_kPrefsCodigo, codigo.trim());
    if (mounted) {
      setState(() {
        _logado = true;
        _nome = nome.trim();
        _codigo = codigo.trim();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_sessaoCarregada) {
      return Scaffold(
        backgroundColor: _kBackground,
        body: Center(
          child: SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _kGrayText,
            ),
          ),
        ),
      );
    }
    if (_logado) {
      return PontoPage(nome: _nome, codigo: _codigo);
    }
    return LoginPage(onLogin: _onLogin);
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLogin});

  final Future<void> Function(String nome, String codigo) onLogin;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nomeController = TextEditingController();
  final _codigoController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  void _entrar() {
    final nome = _nomeController.text.trim();
    final codigo = _codigoController.text.trim();
    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe o nome'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (codigo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe o código de matrícula'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    widget.onLogin(nome, codigo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Campos Nome e Matrícula centralizados
                SizedBox(
                  width: 280,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _nomeController,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          color: _kGrayText,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          labelStyle: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w600,
                            color: _kGrayText.withValues(alpha: 0.8),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: _kGrayBorder.withValues(alpha: 0.5)),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: _kGrayBorder),
                          ),
                        ),
                        textCapitalization: TextCapitalization.words,
                        onSubmitted: (_) => _entrar(),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _codigoController,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          color: _kGrayText,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Matrícula',
                          labelStyle: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w600,
                            color: _kGrayText.withValues(alpha: 0.8),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: _kGrayBorder.withValues(alpha: 0.5)),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: _kGrayBorder),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) => _entrar(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Botão "LOGIN" quadrado, mesma largura dos campos
                SizedBox(
                  width: 280,
                  height: 52,
                  child: GestureDetector(
                    onTap: _entrar,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _kButtonFill,
                        border: Border.all(color: _kGrayBorder, width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'LOGIN',
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _kGrayText,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PontoPage extends StatefulWidget {
  const PontoPage({super.key, required this.nome, required this.codigo});

  final String nome;
  final String codigo;

  @override
  State<PontoPage> createState() => _PontoPageState();
}

/// Intervalo mínimo entre ENTRAR e SAIR (e vice-versa).
const _minutosEntreRegistros = 10;

class _PontoPageState extends State<PontoPage> {
  bool _estaDentro = false;
  bool _carregando = false;
  bool _carregandoInicial = true; // evita mostrar estado errado antes de carregar prefs
  String? _ultimaData;
  String? _ultimoTipo;
  DateTime? _ultimoTimestamp;

  // Cole aqui a URL do seu Google Apps Script (veja SETUP.md)
  static const _urlScript =
      'https://script.google.com/macros/s/AKfycbyBnoTlBRNmztTkeq_k-tBRH6xVyEiT5k_eeCUQgenFgto-3wVCJhIwBP4OhF2m30bA/exec';

  /// Chave de preferências por matrícula (identificador único). A planilha continua recebendo o nome em 'profissional'.
  String get _prefsKey => 'ponto_${widget.codigo}';

  @override
  void initState() {
    super.initState();
    _carregarUltimoPonto();
  }

  Future<void> _carregarUltimoPonto() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('${_prefsKey}_lastDate');
    final tipo = prefs.getString('${_prefsKey}_lastType');
    final ts = prefs.getInt('${_prefsKey}_lastTimestamp');
    if (mounted) {
      setState(() {
        _ultimaData = data;
        _ultimoTipo = tipo;
        _ultimoTimestamp = ts != null ? DateTime.fromMillisecondsSinceEpoch(ts) : null;
        _estaDentro = tipo == 'ENTRAR';
        _carregandoInicial = false;
      });
    }
  }

  Future<void> _salvarUltimoPonto(String data, String tipo, DateTime timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_prefsKey}_lastDate', data);
    await prefs.setString('${_prefsKey}_lastType', tipo);
    await prefs.setInt('${_prefsKey}_lastTimestamp', timestamp.millisecondsSinceEpoch);
  }

  /// Retorna (sucesso, mensagemDeErro). O script da planilha devolve HTTP 200 mesmo quando falha; é preciso checar o body.
  Future<(bool, String?)> _enviarParaPlanilha(String tipo, String dataStr, String horaStr) async {
    final body = jsonEncode({
      'matricula': widget.codigo,
      'profissional': widget.nome,
      'tipo': tipo,
      'data': dataStr,
      'hora': horaStr,
    });
    final response = await http.post(
      Uri.parse(_urlScript),
      headers: {'Content-Type': 'text/plain'},
      body: body,
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode < 200 || response.statusCode >= 400) {
      return (false, 'HTTP ${response.statusCode}');
    }
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>?;
      final ok = json?['ok'] == true;
      final erro = json?['erro']?.toString();
      return (ok, ok ? null : (erro ?? 'Resposta inválida da planilha'));
    } catch (_) {
      return (false, 'Resposta inválida da planilha');
    }
  }

  Future<void> _registrar(String tipo) async {
    final agora = DateTime.now();

    // Só pode dar saída 10 min depois da entrada, e vice-versa
    if (_ultimoTimestamp != null) {
      final diff = agora.difference(_ultimoTimestamp!);
      if (diff.inMinutes < _minutosEntreRegistros) {
        final restante = _minutosEntreRegistros - diff.inMinutes;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Aguarde $restante minuto(s) entre entrada e saída.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }
    }

    setState(() {
      _carregando = true;
      _estaDentro = !_estaDentro;
    });

    final dataStr = '${agora.day.toString().padLeft(2, '0')}/${agora.month.toString().padLeft(2, '0')}/${agora.year}';
    final horaStr = '${agora.hour.toString().padLeft(2, '0')}:${agora.minute.toString().padLeft(2, '0')}:${agora.second.toString().padLeft(2, '0')}';

    try {
      // Se virou o dia e o último foi ENTRAR sem SAIR, registra SAIR "Não informado" no dia anterior
      if (_ultimaData != null &&
          _ultimaData != dataStr &&
          _ultimoTipo == 'ENTRAR') {
        final (okSairAnterior, msgSair) = await _enviarParaPlanilha('SAIR', _ultimaData!, 'Não informado');
        if (!okSairAnterior) {
          setState(() => _estaDentro = !_estaDentro);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msgSair ?? 'Erro ao registrar saída do dia anterior.'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      final (sucesso, msgErro) = await _enviarParaPlanilha(tipo, dataStr, horaStr);

      if (sucesso) {
        await _salvarUltimoPonto(dataStr, tipo, agora);
        if (mounted) {
          setState(() {
            _ultimaData = dataStr;
            _ultimoTipo = tipo;
            _ultimoTimestamp = agora;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$tipo registrado às $horaStr')),
          );
        }
      } else {
        setState(() => _estaDentro = !_estaDentro);
        debugPrint('Planilha: $msgErro');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msgErro ?? 'Erro ao enviar. Verifique a URL do script no SETUP.md.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e, stack) {
      setState(() => _estaDentro = !_estaDentro);
      debugPrint('Erro ao enviar: $e');
      debugPrint(stack.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _aoClicar() {
    if (_carregando) return;
    _registrar(_estaDentro ? 'SAIR' : 'ENTRAR');
  }

  @override
  Widget build(BuildContext context) {
    final isSair = _estaDentro;
    final borderColor = isSair ? _kSairBlue : _kGrayBorder;
    final textColor = isSair ? _kSairBlueLight : _kGrayText;

    return Scaffold(
      backgroundColor: _kBackground,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Botão circular central (Entrar = cinza, Sair = azul)
            Center(
              child: GestureDetector(
                onTap: (_carregando || _carregandoInicial) ? null : _aoClicar,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _kBackground,
                    border: Border.all(
                      color: (_carregando || _carregandoInicial) ? _kGrayBorder : borderColor,
                      width: isSair ? 2.5 : 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: (_carregando || _carregandoInicial)
                      ? SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: textColor,
                          ),
                        )
                      : Text(
                          isSair ? 'Sair' : 'Entrar',
                          style: GoogleFonts.dmSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                ),
              ),
            ),
            const Spacer(flex: 2),
            // Nome e Matrícula na parte inferior
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                children: [
                  Text(
                    widget.nome,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _kGrayText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.codigo,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _kGrayText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
