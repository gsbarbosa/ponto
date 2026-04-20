import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

const _kBackground = Color(0xFF1e1e1e);
const _kGrayBorder = Color(0xFF9e9e9e);
const _kGrayText = Color(0xFFb0b0b0);
const _kButtonFill = Color(0xFF2d2d2d);
const _kSairBlue = Color(0xFF4285F4);
const _kSairBlueLight = Color(0xFF60B0FF);
const _minutosEntreRegistros = 10;
const _firestoreTimeout = Duration(seconds: 12);
const _registroTimeout = Duration(seconds: 20);
const _authTimeout = Duration(seconds: 12);

const _kPrefsLogado = 'ponto_logado';
const _kPrefsNome = 'ponto_nome';
const _kPrefsCodigo = 'ponto_codigo';
const _kPrefsAdmin = 'ponto_admin';
const _kPrefsTrocaSenha = 'ponto_troca_senha';
const _senhaInicialFuncionario = 'teatrofeluma';
const _senhaInicialAdmin = 'teatrofelumaadmin';
const _kColecaoSegurancaUsuarios = 'seguranca_usuarios';
// (Reservado) Se quiser reintroduzir fechamentos no futuro.
const _kColecaoFechamentos = 'fechamentos';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PontoApp());
}

class PontoApp extends StatelessWidget {
  const PontoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ponto',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _kBackground,
        colorScheme: const ColorScheme.dark(
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

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _sessaoCarregada = false;
  bool _logado = false;
  bool _admin = false;
  bool _precisaTrocarSenha = false;
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
    final admin = prefs.getBool(_kPrefsAdmin) ?? false;
    final precisaTrocarSenha = prefs.getBool(_kPrefsTrocaSenha) ?? false;

    if (!mounted) return;
    setState(() {
      _sessaoCarregada = true;
      _logado = logado && nome.isNotEmpty && codigo.isNotEmpty;
      _nome = nome;
      _codigo = codigo;
      _admin = admin;
      _precisaTrocarSenha = precisaTrocarSenha;
    });
  }

  Future<void> _onLogin({
    required String nome,
    required String codigo,
    required bool admin,
    required bool precisaTrocarSenha,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPrefsLogado, true);
    await prefs.setString(_kPrefsNome, nome.trim());
    await prefs.setString(_kPrefsCodigo, codigo.trim());
    await prefs.setBool(_kPrefsAdmin, admin);
    await prefs.setBool(_kPrefsTrocaSenha, precisaTrocarSenha);

    if (!mounted) return;
    setState(() {
      _logado = true;
      _nome = nome.trim();
      _codigo = codigo.trim();
      _admin = admin;
      _precisaTrocarSenha = precisaTrocarSenha;
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kPrefsLogado);
    await prefs.remove(_kPrefsNome);
    await prefs.remove(_kPrefsCodigo);
    await prefs.remove(_kPrefsAdmin);
    await prefs.remove(_kPrefsTrocaSenha);

    if (!mounted) return;
    setState(() {
      _logado = false;
      _nome = '';
      _codigo = '';
      _admin = false;
      _precisaTrocarSenha = false;
    });
  }

  Future<void> _marcarSenhaAtualizada() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPrefsTrocaSenha, false);
    if (!mounted) return;
    setState(() {
      _precisaTrocarSenha = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_sessaoCarregada) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (!_logado) {
      return LoginPage(onLogin: _onLogin);
    }
    if (_admin) {
      return AdminPage(nome: _nome, codigo: _codigo, onLogout: _logout);
    }
    if (_precisaTrocarSenha) {
      return ChangePasswordPage(
        onSenhaAtualizada: _marcarSenhaAtualizada,
        onLogout: _logout,
      );
    }
    return PontoPage(nome: _nome, codigo: _codigo, onLogout: _logout);
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLogin});

  final Future<void> Function({
    required String nome,
    required String codigo,
    required bool admin,
    required bool precisaTrocarSenha,
  }) onLogin;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nomeController = TextEditingController();
  final _codigoController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _entrando = false;

  @override
  void initState() {
    super.initState();
    _codigoController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _codigoController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (_entrando) return;

    final nome = _nomeController.text.trim();
    final codigo = _codigoController.text.trim();
    final senha = _senhaController.text;

    if (nome.isEmpty || codigo.isEmpty || senha.isEmpty) {
      _showMessage('Informe nome, matrícula e senha', Colors.orange);
      return;
    }

    setState(() => _entrando = true);
    try {
      final isAdmin = _isSenhaAdmin(senha);
      var precisaTrocarSenha = false;
      if (isAdmin) {
        await _loginAdminPorMatricula(codigo, senha);
        precisaTrocarSenha = senha == _senhaInicialAdmin;
      } else {
        await _loginFuncionario(codigo, senha);
        precisaTrocarSenha = senha == _senhaInicialFuncionario;
      }
      await widget.onLogin(
        nome: nome,
        codigo: codigo,
        admin: isAdmin,
        precisaTrocarSenha: precisaTrocarSenha,
      );
    } catch (e) {
      if (mounted) _showMessage(e.toString().replaceFirst('Exception: ', ''), Colors.red);
    } finally {
      if (mounted) setState(() => _entrando = false);
    }
  }

  bool _isSenhaAdmin(String senha) => senha.toLowerCase().endsWith('admin');

  Future<void> _loginFuncionario(String codigo, String senha) async {
    final email = _emailFuncionario(codigo);
    final local = email.split('@').first;
    if (local.isEmpty) {
      throw Exception('Matrícula inválida para gerar o login.');
    }

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: senha)
          .timeout(_authTimeout);
      return;
    } on TimeoutException {
      throw Exception('Tempo excedido no login.');
    } on FirebaseAuthException catch (e) {
      if (senha != _senhaInicialFuncionario) {
        throw Exception(_traduzErroAuth(e));
      }
      if (e.code == 'too-many-requests' ||
          e.code == 'invalid-email' ||
          e.code == 'operation-not-allowed' ||
          e.code == 'user-disabled') {
        throw Exception(_traduzErroAuth(e));
      }
      // Primeiro acesso: senha inicial — tenta criar o usuário automaticamente.
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: senha)
            .timeout(_authTimeout);
      } on FirebaseAuthException catch (e2) {
        if (e2.code == 'email-already-in-use') {
          throw Exception(
            'Senha incorreta. Se já alterou a senha no primeiro acesso, use a nova.',
          );
        }
        if (e2.code == 'weak-password') {
          throw Exception('A senha inicial não atende ao requisito mínimo do Firebase.');
        }
        throw Exception(_traduzErroAuth(e2));
      } on TimeoutException {
        throw Exception('Tempo excedido ao criar a conta.');
      }
    }
  }

  Future<void> _loginAdminPorMatricula(String codigo, String senha) async {
    final email = _emailFuncionario(codigo);
    try {
      final cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: senha)
          .timeout(_authTimeout);
      if (cred.user == null) throw Exception('Falha ao autenticar administrador.');
    } on FirebaseAuthException catch (e) {
      if (senha != _senhaInicialAdmin) {
        throw Exception(_traduzErroAuth(e));
      }
      if (e.code == 'too-many-requests' ||
          e.code == 'invalid-email' ||
          e.code == 'operation-not-allowed' ||
          e.code == 'user-disabled') {
        throw Exception(_traduzErroAuth(e));
      }
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: senha)
            .timeout(_authTimeout);
      } on FirebaseAuthException catch (e2) {
        if (e2.code == 'email-already-in-use') {
          throw Exception('Senha de administrador incorreta.');
        }
        throw Exception(_traduzErroAuth(e2));
      }
    } on TimeoutException {
      throw Exception('Tempo excedido no login do administrador.');
    }
  }

  Future<void> _abrirRecuperacaoSenha() async {
    final matriculaController = TextEditingController(
      text: _codigoController.text.trim(),
    );
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Recuperar senha'),
          content: TextField(
            controller: matriculaController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Matrícula',
              helperText: 'Usaremos o email interno gerado pela matrícula.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final matricula = matriculaController.text.trim();
                if (matricula.isEmpty) {
                  _showMessage('Informe a matrícula.', Colors.orange);
                  return;
                }
                final email = _emailFuncionario(matricula);
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: email)
                      .timeout(_authTimeout);
                  if (!dialogContext.mounted) return;
                  Navigator.of(dialogContext).pop();
                  _showMessage(
                    'Se a conta existir, o email de recuperação foi enviado.',
                    Colors.green,
                  );
                } on FirebaseAuthException catch (e) {
                  _showMessage(_traduzErroAuth(e), Colors.red);
                } on TimeoutException {
                  _showMessage('Tempo excedido ao solicitar recuperação.', Colors.red);
                }
              },
              child: const Text('Enviar recuperação'),
            ),
          ],
        );
      },
    );
    matriculaController.dispose();
  }

  String _traduzErroAuth(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Email inválido.';
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Credenciais inválidas.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente em instantes.';
      default:
        return 'Falha no login: ${e.message ?? e.code}';
    }
  }

  String _emailFuncionario(String matricula) {
    final clean = matricula.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '');
    // Domínio sintético com TLD reconhecido (evita falha de validação do Auth).
    return '${clean.toLowerCase()}@ponto.app';
  }

  void _showMessage(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nomeController,
                    style: GoogleFonts.dmSans(color: _kGrayText),
                    decoration: _inputDecoration('Nome'),
                    onSubmitted: (_) => _entrar(),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _codigoController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.dmSans(color: _kGrayText),
                    decoration: _inputDecoration('Matrícula'),
                    onSubmitted: (_) => _entrar(),
                  ),
                  if (_codigoController.text.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Conta Firebase: ${_emailFuncionario(_codigoController.text.trim())}',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: _kGrayText.withValues(alpha: 0.65),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _senhaController,
                    obscureText: true,
                    style: GoogleFonts.dmSans(color: _kGrayText),
                    decoration: _inputDecoration('Senha (termine com "admin" para perfil admin)'),
                    onSubmitted: (_) => _entrar(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _entrando ? null : _entrar,
                      style: FilledButton.styleFrom(
                        backgroundColor: _kButtonFill,
                        side: const BorderSide(color: _kGrayBorder, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: _entrando
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              'LOGIN',
                              style: GoogleFonts.dmSans(
                                fontSize: 18,
                                color: _kGrayText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _entrando ? null : _abrirRecuperacaoSenha,
                    child: const Text('Esqueci minha senha'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.dmSans(color: _kGrayText.withValues(alpha: 0.8)),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: _kGrayBorder.withValues(alpha: 0.5)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: _kGrayBorder),
      ),
    );
  }
}

class PontoPage extends StatefulWidget {
  const PontoPage({
    super.key,
    required this.nome,
    required this.codigo,
    required this.onLogout,
    this.apenasVolta = false,
  });

  final String nome;
  final String codigo;
  final Future<void> Function() onLogout;
  /// Quando true (ex.: admin abriu a partir do painel), o botão da AppBar só volta à tela anterior.
  final bool apenasVolta;

  @override
  State<PontoPage> createState() => _PontoPageState();
}

class _PontoPageState extends State<PontoPage> {
  bool _estaDentro = false;
  bool _carregando = false;
  DateTime? _ultimoTimestamp;
  String? _ultimoTipo;
  String? _ultimaData;

  @override
  void initState() {
    super.initState();
    _carregarUltimoPonto();
  }

  Future<void> _carregarUltimoPonto() async {
    try {
      // Só `where` em um campo: não exige índice composto. Ordenação no cliente.
      final snapshot = await FirebaseFirestore.instance
          .collection('pontos')
          .where('matricula', isEqualTo: widget.codigo)
          .get()
          .timeout(_firestoreTimeout);

      if (!mounted) return;
      if (snapshot.docs.isEmpty) {
        setState(() {});
        return;
      }

      QueryDocumentSnapshot<Map<String, dynamic>>? latestDoc;
      DateTime? latestDt;
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final ts = data['timestamp'];
        final dt = ts is Timestamp ? ts.toDate() : null;
        if (dt == null) continue;
        if (latestDt == null || dt.isAfter(latestDt)) {
          latestDt = dt;
          latestDoc = doc;
        }
      }
      if (latestDoc == null) {
        setState(() {});
        return;
      }

      final data = latestDoc.data();
      final ts = data['timestamp'];
      final tipo = data['tipo'] as String?;
      final dataStr = data['data'] as String?;
      final dt = ts is Timestamp ? ts.toDate() : null;

      setState(() {
        _ultimoTimestamp = dt;
        _ultimoTipo = tipo;
        _ultimaData = dataStr;
        _estaDentro = tipo == 'ENTRAR';
      });
    } catch (e) {
      if (!mounted) return;
      _showMessage('Falha ao carregar último ponto: $e', Colors.orange);
    }
  }

  Future<void> _registrar(String tipo) async {
    final agora = DateTime.now();
    if (_ultimoTimestamp != null) {
      final diff = agora.difference(_ultimoTimestamp!);
      if (diff.inMinutes < _minutosEntreRegistros) {
        final restante = _minutosEntreRegistros - diff.inMinutes;
        _showMessage(
          'Aguarde $restante minuto(s) entre entrada e saída.',
          Colors.orange,
        );
        return;
      }
    }

    final dataStr =
        '${agora.day.toString().padLeft(2, '0')}/${agora.month.toString().padLeft(2, '0')}/${agora.year}';
    final horaStr =
        '${agora.hour.toString().padLeft(2, '0')}:${agora.minute.toString().padLeft(2, '0')}:${agora.second.toString().padLeft(2, '0')}';

    setState(() {
      _carregando = true;
      _estaDentro = !_estaDentro;
    });

    try {
      await (() async {
        // Se virou o dia e havia entrada sem saída, cria saída automática.
        if (_ultimaData != null && _ultimaData != dataStr && _ultimoTipo == 'ENTRAR') {
          await _savePonto(
            tipo: 'SAIR',
            data: _ultimaData!,
            hora: 'Não informado',
            timestamp: agora.subtract(const Duration(days: 1)),
          );
        }

        await _savePonto(
          tipo: tipo,
          data: dataStr,
          hora: horaStr,
          timestamp: agora,
        );
      })().timeout(_registroTimeout);

      if (!mounted) return;
      setState(() {
        _ultimoTipo = tipo;
        _ultimaData = dataStr;
        _ultimoTimestamp = agora;
      });
      _showMessage('$tipo registrado às $horaStr', Colors.green);
    } on TimeoutException {
      if (!mounted) return;
      setState(() => _estaDentro = !_estaDentro);
      _showMessage(
        'Tempo excedido ao salvar no Firebase. Verifique regras/index/rede.',
        Colors.red,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _estaDentro = !_estaDentro);
      _showMessage('Erro ao registrar: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  Future<void> _savePonto({
    required String tipo,
    required String data,
    required String hora,
    required DateTime timestamp,
  }) async {
    await FirebaseFirestore.instance.collection('pontos').add({
      'nome': widget.nome,
      'matricula': widget.codigo,
      'tipo': tipo,
      'data': data,
      'hora': hora,
      'timestamp': Timestamp.fromDate(timestamp),
      'createdAt': FieldValue.serverTimestamp(),
    }).timeout(_firestoreTimeout);
  }

  Future<void> _abrirDialogSolicitacaoCorrecao() async {
    final dataController = TextEditingController(text: _ultimaData ?? '');
    final horaController = TextEditingController();
    final justificativaController = TextEditingController();
    String tipo = _ultimoTipo == 'SAIR' ? 'SAIR' : 'ENTRAR';

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Solicitar correção de ponto'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: tipo,
                      items: const [
                        DropdownMenuItem(value: 'ENTRAR', child: Text('ENTRAR')),
                        DropdownMenuItem(value: 'SAIR', child: Text('SAIR')),
                      ],
                      onChanged: (value) {
                        if (value != null) setStateDialog(() => tipo = value);
                      },
                      decoration: const InputDecoration(labelText: 'Tipo correto'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: dataController,
                      decoration: const InputDecoration(labelText: 'Data (dd/MM/yyyy)'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: horaController,
                      decoration: const InputDecoration(labelText: 'Hora (HH:mm:ss)'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: justificativaController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Justificativa (obrigatória)',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () async {
                    final justificativa = justificativaController.text.trim();
                    if (justificativa.isEmpty) {
                      _showMessage('A justificativa é obrigatória.', Colors.orange);
                      return;
                    }

                    try {
                      await FirebaseFirestore.instance.collection('solicitacoes_correcao').add({
                        'nome': widget.nome,
                        'matricula': widget.codigo,
                        'status': 'pendente',
                        'justificativa': justificativa,
                        'tipoSolicitado': tipo,
                        'dataSolicitada': dataController.text.trim(),
                        'horaSolicitada': horaController.text.trim(),
                        'ultimoTipoRegistrado': _ultimoTipo ?? '',
                        'ultimaDataRegistrada': _ultimaData ?? '',
                        'createdAt': FieldValue.serverTimestamp(),
                      }).timeout(_firestoreTimeout);

                      if (!mounted) return;
                      Navigator.of(context).pop();
                      _showMessage('Solicitação enviada para aprovação do admin.', Colors.green);
                    } catch (e) {
                      _showMessage('Falha ao enviar solicitação: $e', Colors.red);
                    }
                  },
                  child: const Text('Enviar solicitação'),
                ),
              ],
            );
          },
        );
      },
    );
    dataController.dispose();
    horaController.dispose();
    justificativaController.dispose();
  }

  void _showMessage(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSair = _estaDentro;
    final borderColor = isSair ? _kSairBlue : _kGrayBorder;
    final textColor = isSair ? _kSairBlueLight : _kGrayText;

    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        title: const Text('Registro de Ponto'),
        leading: widget.apenasVolta
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Voltar ao painel',
                onPressed: _carregando ? null : () => widget.onLogout(),
              )
            : null,
        automaticallyImplyLeading: !widget.apenasVolta,
        actions: [
          if (!widget.apenasVolta)
            IconButton(
              onPressed: _carregando ? null : widget.onLogout,
              icon: const Icon(Icons.logout),
              tooltip: 'Sair',
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Center(
              child: GestureDetector(
                onTap: _carregando ? null : () => _registrar(_estaDentro ? 'SAIR' : 'ENTRAR'),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _kBackground,
                    border: Border.all(
                      color: _carregando ? _kGrayBorder : borderColor,
                      width: isSair ? 2.5 : 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: _carregando
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _carregando ? null : _abrirDialogSolicitacaoCorrecao,
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Solicitar correção de ponto'),
                ),
              ),
            ),
            const SizedBox(height: 12),
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

/// Uma linha na visão admin: todos os pontos do período/filtro agrupados por matrícula.
class _ResumoPontoProfissional {
  _ResumoPontoProfissional({
    required this.matricula,
    required this.nome,
    required this.documentosRecentesPrimeiro,
  });

  final String matricula;
  final String nome;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> documentosRecentesPrimeiro;

  int get total => documentosRecentesPrimeiro.length;

  Map<String, dynamic>? get _ultimo =>
      documentosRecentesPrimeiro.isEmpty ? null : documentosRecentesPrimeiro.first.data();

  DateTime? get ultimoTimestamp {
    final ts = _ultimo?['timestamp'];
    return ts is Timestamp ? ts.toDate() : null;
  }

  String get ultimoResumo {
    final d = _ultimo;
    if (d == null) return '—';
    final tipo = d['tipo'] ?? '';
    final data = d['data'] ?? '';
    final hora = d['hora'] ?? '';
    return '$tipo · $data $hora'.trim();
  }
}

class AdminPage extends StatefulWidget {
  const AdminPage({
    super.key,
    required this.nome,
    required this.codigo,
    required this.onLogout,
  });

  final String nome;
  final String codigo;
  final Future<void> Function() onLogout;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _buscaController = TextEditingController();
  String _busca = '';
  String _filtroTipo = 'TODOS';
  String _filtroPeriodo = 'MES';
  String _filtroFuncionario = 'TODOS';
  String _filtroStatusSolicitacao = 'PENDENTE';
  String _competencia = '';

  @override
  void initState() {
    super.initState();
    _competencia = _competenciaDeDateTime(DateTime.now());
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  String _competenciaDeDateTime(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    return '$y-$m';
  }

  DateTime _inicioCompetencia(String competencia) {
    final parts = competencia.split('-');
    final y = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    return DateTime(y, m, 1);
  }

  DateTime _fimCompetenciaExclusivo(String competencia) {
    final start = _inicioCompetencia(competencia);
    return DateTime(start.year, start.month + 1, 1);
  }

  DateTime _fimCompetenciaEfetivoExclusivo(String competencia) {
    // Se for a competência do mês atual, recorta até "amanhã 00:00" (inclui o dia de hoje).
    final now = DateTime.now();
    final atual = _competenciaDeDateTime(now);
    if (competencia == atual) {
      return DateTime(now.year, now.month, now.day + 1);
    }
    return _fimCompetenciaExclusivo(competencia);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _streamPontos() {
    return FirebaseFirestore.instance
        .collection('pontos')
        .limit(1200)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _streamSolicitacoes() {
    return FirebaseFirestore.instance
        .collection('solicitacoes_correcao')
        .limit(800)
        .snapshots();
  }

  DateTime? _parseDataHoraPtBr(String data, String hora) {
    // data: dd/MM/yyyy
    // hora: HH:mm:ss (ou HH:mm)
    try {
      final parts = data.split('/');
      if (parts.length != 3) return null;
      final d = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final y = int.parse(parts[2]);

      final hParts = hora.split(':');
      if (hParts.length < 2) return null;
      final hh = int.parse(hParts[0]);
      final mm = int.parse(hParts[1]);
      final ss = hParts.length >= 3 ? int.tryParse(hParts[2]) ?? 0 : 0;
      return DateTime(y, m, d, hh, mm, ss);
    } catch (_) {
      return null;
    }
  }

  Future<String?> _aplicarCorrecaoEmPontos(Map<String, dynamic> s) async {
    final matricula = (s['matricula'] ?? '').toString().trim();
    final nome = (s['nome'] ?? '').toString().trim();
    final tipo = (s['tipoSolicitado'] ?? '').toString().trim();
    final data = (s['dataSolicitada'] ?? '').toString().trim();
    final hora = (s['horaSolicitada'] ?? '').toString().trim();

    if (matricula.isEmpty || tipo.isEmpty || data.isEmpty || hora.isEmpty) return null;
    if (tipo != 'ENTRAR' && tipo != 'SAIR') return null;

    // Se já existe marcação desse tipo no dia, não duplica.
    final existentes = await FirebaseFirestore.instance
        .collection('pontos')
        .where('matricula', isEqualTo: matricula)
        .where('data', isEqualTo: data)
        .where('tipo', isEqualTo: tipo)
        .get()
        .timeout(_firestoreTimeout);
    if (existentes.docs.isNotEmpty) {
      return existentes.docs.first.id;
    }

    final dt = _parseDataHoraPtBr(data, hora) ?? DateTime.now();
    final doc = await FirebaseFirestore.instance.collection('pontos').add({
      'nome': nome,
      'matricula': matricula,
      'tipo': tipo,
      'data': data,
      'hora': hora,
      'timestamp': Timestamp.fromDate(dt),
      'createdAt': FieldValue.serverTimestamp(),
      'origem': 'correcao_aprovada',
    }).timeout(_firestoreTimeout);
    return doc.id;
  }

  Future<void> _aprovarSolicitacao({
    required BuildContext context,
    required String solicitacaoId,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('solicitacoes_correcao')
          .doc(solicitacaoId);
      final snap = await docRef.get().timeout(_firestoreTimeout);
      final s = snap.data();
      if (s == null) throw Exception('Solicitação não encontrada.');

      final pontoId = await _aplicarCorrecaoEmPontos(s);

      await FirebaseFirestore.instance
          .collection('solicitacoes_correcao')
          .doc(solicitacaoId)
          .update({
            'status': 'aprovada',
            'decisaoPor': '${widget.nome} (${widget.codigo})',
            'decisaoEm': FieldValue.serverTimestamp(),
            'pontoAplicadoId': pontoId ?? '',
          })
          .timeout(_firestoreTimeout);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitação aprovada e aplicada no ponto.')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao aprovar: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _rejeitarSolicitacao({
    required BuildContext context,
    required String solicitacaoId,
  }) async {
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Rejeitar solicitação'),
          content: TextField(
            controller: controller,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Motivo da rejeição (obrigatório)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final motivo = controller.text.trim();
                if (motivo.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Informe o motivo da rejeição.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }
                try {
                  await FirebaseFirestore.instance
                      .collection('solicitacoes_correcao')
                      .doc(solicitacaoId)
                      .update({
                        'status': 'rejeitada',
                        'motivoRejeicao': motivo,
                        'decisaoPor': '${widget.nome} (${widget.codigo})',
                        'decisaoEm': FieldValue.serverTimestamp(),
                      })
                      .timeout(_firestoreTimeout);
                  if (!dialogContext.mounted) return;
                  Navigator.of(dialogContext).pop();
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Falha ao rejeitar: $e'), backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text('Rejeitar'),
            ),
          ],
        );
      },
    );
    controller.dispose();
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _filtrarPontos(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final agora = DateTime.now();
    DateTime? inicio;
    if (_filtroPeriodo == 'HOJE') {
      inicio = DateTime(agora.year, agora.month, agora.day);
    } else if (_filtroPeriodo == '7D') {
      inicio = agora.subtract(const Duration(days: 7));
    } else if (_filtroPeriodo == '30D') {
      inicio = agora.subtract(const Duration(days: 30));
    } else if (_filtroPeriodo == 'MES' && _competencia.isNotEmpty) {
      inicio = _inicioCompetencia(_competencia);
    }
    DateTime? fim;
    if (_filtroPeriodo == 'MES' && _competencia.isNotEmpty) {
      fim = _fimCompetenciaEfetivoExclusivo(_competencia);
    }

    final busca = _busca.trim().toLowerCase();
    final filtrados = docs.where((doc) {
      final d = doc.data();
      final nome = (d['nome'] ?? '').toString();
      final matricula = (d['matricula'] ?? '').toString();
      final tipo = (d['tipo'] ?? '').toString();
      final ts = d['timestamp'];
      final dt = ts is Timestamp ? ts.toDate() : null;

      final okBusca = busca.isEmpty ||
          nome.toLowerCase().contains(busca) ||
          matricula.toLowerCase().contains(busca);
      final okTipo = _filtroTipo == 'TODOS' || tipo == _filtroTipo;
      final okFuncionario = _filtroFuncionario == 'TODOS' || matricula == _filtroFuncionario;
      final okPeriodoInicio = inicio == null || (dt != null && !dt.isBefore(inicio));
      final okPeriodoFim = fim == null || (dt != null && dt.isBefore(fim));
      final okPeriodo = okPeriodoInicio && okPeriodoFim;
      return okBusca && okTipo && okFuncionario && okPeriodo;
    }).toList();

    filtrados.sort((a, b) {
      final aTs = a.data()['timestamp'];
      final bTs = b.data()['timestamp'];
      final aDt = aTs is Timestamp ? aTs.toDate() : DateTime.fromMillisecondsSinceEpoch(0);
      final bDt = bTs is Timestamp ? bTs.toDate() : DateTime.fromMillisecondsSinceEpoch(0);
      return bDt.compareTo(aDt);
    });
    return filtrados;
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _filtrarSolicitacoes(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final busca = _busca.trim().toLowerCase();
    final filtrados = docs.where((doc) {
      final d = doc.data();
      final nome = (d['nome'] ?? '').toString();
      final matricula = (d['matricula'] ?? '').toString();
      final justificativa = (d['justificativa'] ?? '').toString();
      final status = (d['status'] ?? '').toString().toUpperCase();
      final okBusca = busca.isEmpty ||
          nome.toLowerCase().contains(busca) ||
          matricula.toLowerCase().contains(busca) ||
          justificativa.toLowerCase().contains(busca);
      final okStatus = _filtroStatusSolicitacao == 'TODOS' || status == _filtroStatusSolicitacao;
      return okBusca && okStatus;
    }).toList();

    filtrados.sort((a, b) {
      final aTs = a.data()['createdAt'];
      final bTs = b.data()['createdAt'];
      final aDt = aTs is Timestamp ? aTs.toDate() : DateTime.fromMillisecondsSinceEpoch(0);
      final bDt = bTs is Timestamp ? bTs.toDate() : DateTime.fromMillisecondsSinceEpoch(0);
      return bDt.compareTo(aDt);
    });
    return filtrados;
  }

  List<_ResumoPontoProfissional> _resumosPorProfissional(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> pontosFiltrados,
  ) {
    final map = <String, List<QueryDocumentSnapshot<Map<String, dynamic>>>>{};
    for (final doc in pontosFiltrados) {
      final m = (doc.data()['matricula'] ?? '').toString().trim();
      if (m.isEmpty) continue;
      map.putIfAbsent(m, () => []).add(doc);
    }
    final list = <_ResumoPontoProfissional>[];
    for (final e in map.entries) {
      final docs = [...e.value];
      docs.sort((a, b) {
        final at = a.data()['timestamp'];
        final bt = b.data()['timestamp'];
        final ad = at is Timestamp ? at.toDate() : DateTime.fromMillisecondsSinceEpoch(0);
        final bd = bt is Timestamp ? bt.toDate() : DateTime.fromMillisecondsSinceEpoch(0);
        return bd.compareTo(ad);
      });
      final nome = (docs.first.data()['nome'] ?? '').toString();
      list.add(
        _ResumoPontoProfissional(
          matricula: e.key,
          nome: nome,
          documentosRecentesPrimeiro: docs,
        ),
      );
    }
    list.sort((a, b) {
      final at = a.ultimoTimestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bt = b.ultimoTimestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bt.compareTo(at);
    });
    return list;
  }

  Widget _tabelaPontosPorProfissional(List<_ResumoPontoProfissional> resumos) {
    const minWidth = 640.0;
    TextStyle cellStyle({bool header = false}) => GoogleFonts.dmSans(
          fontSize: header ? 12 : 13,
          fontWeight: header ? FontWeight.w700 : FontWeight.w500,
          color: header ? _kGrayText : Colors.white,
        );

    Widget cell(String text, {bool header = false, int flex = 1}) {
      return Expanded(
        flex: flex,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Text(
            text,
            style: cellStyle(header: header),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final viewport = w.isFinite ? w : MediaQuery.sizeOf(context).width;
        final tableWidth = viewport < minWidth ? minWidth : viewport;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: minWidth, maxWidth: tableWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: _kGrayBorder.withValues(alpha: 0.4)),
                    ),
                  ),
                  child: Row(
                    children: [
                      cell('Profissional', header: true, flex: 3),
                      cell('Matrícula', header: true, flex: 2),
                      cell('Última marcação', header: true, flex: 3),
                      cell('Qtd', header: true, flex: 1),
                    ],
                  ),
                ),
                ...resumos.map(
                  (r) => InkWell(
                    onTap: () => _mostrarDetalheProfissional(context, r),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: _kGrayBorder.withValues(alpha: 0.15)),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cell(r.nome.isEmpty ? '—' : r.nome, flex: 3),
                          cell(r.matricula, flex: 2),
                          cell(r.ultimoResumo, flex: 3),
                          cell('${r.total}', flex: 1),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarDetalheProfissional(BuildContext context, _ResumoPontoProfissional r) {
    final linhas = r.documentosRecentesPrimeiro.take(50).map((doc) {
      final d = doc.data();
      return '${d['tipo'] ?? ''} · ${d['data'] ?? ''} ${d['hora'] ?? ''}';
    }).join('\n');

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${r.nome.isEmpty ? r.matricula : r.nome} (${r.matricula})'),
        content: SingleChildScrollView(
          child: SelectableText(
            linhas.isEmpty ? 'Sem registros.' : linhas,
            style: GoogleFonts.dmSans(fontSize: 13, color: _kGrayText),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Fechar')),
        ],
      ),
    );
  }

  Future<void> _exportarCsv(BuildContext context, String nomeArquivo) async {
    var ref = FirebaseFirestore.instance.collection('pontos').orderBy('timestamp');
    if (_competencia.isNotEmpty) {
      final start = _inicioCompetencia(_competencia);
      final end = _fimCompetenciaEfetivoExclusivo(_competencia);
      ref = ref
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('timestamp', isLessThan: Timestamp.fromDate(end));
    }
    final query = await ref.get().timeout(_firestoreTimeout);

    final buffer = StringBuffer()
      ..writeln('nome,matricula,tipo,data,hora');
    for (final doc in query.docs) {
      final d = doc.data();
      buffer.writeln(
        '${_csv(d['nome'])},${_csv(d['matricula'])},${_csv(d['tipo'])},${_csv(d['data'])},${_csv(d['hora'])}',
      );
    }

    final bytes = Uint8List.fromList(buffer.toString().codeUnits);
    final params = ShareParams(
      files: [XFile.fromData(bytes, mimeType: 'text/csv', name: nomeArquivo)],
      text: 'Exportação de pontos',
      subject: 'Pontos',
    );
    await SharePlus.instance.share(params);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Arquivo CSV gerado com sucesso.')),
    );
  }

  Future<void> _exportarCsvPorDia(BuildContext context, String nomeArquivo) async {
    var ref = FirebaseFirestore.instance.collection('pontos').orderBy('timestamp');
    if (_competencia.isNotEmpty) {
      final start = _inicioCompetencia(_competencia);
      final end = _fimCompetenciaEfetivoExclusivo(_competencia);
      ref = ref
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('timestamp', isLessThan: Timestamp.fromDate(end));
    }
    final query = await ref.get().timeout(_firestoreTimeout);

    // chave: matricula|data
    final map = <String, Map<String, dynamic>>{};
    for (final doc in query.docs) {
      final d = doc.data();
      final nome = (d['nome'] ?? '').toString();
      final matricula = (d['matricula'] ?? '').toString();
      final tipo = (d['tipo'] ?? '').toString();
      final data = (d['data'] ?? '').toString();
      final hora = (d['hora'] ?? '').toString();
      final ts = d['timestamp'];
      final dt = ts is Timestamp ? ts.toDate() : null;
      if (matricula.isEmpty || data.isEmpty) continue;

      final key = '$matricula|$data';
      map.putIfAbsent(key, () {
        return {
          'nome': nome,
          'matricula': matricula,
          'data': data,
          'entrada': '',
          'saida': '',
          '_entradaDt': null,
          '_saidaDt': null,
        };
      });

      final row = map[key]!;
      // Mantém nome mais recente que aparecer.
      if (nome.isNotEmpty) row['nome'] = nome;

      if (tipo == 'ENTRAR') {
        final current = row['_entradaDt'] as DateTime?;
        if (current == null || (dt != null && dt.isBefore(current))) {
          row['_entradaDt'] = dt ?? current;
          row['entrada'] = hora;
        }
      } else if (tipo == 'SAIR') {
        final current = row['_saidaDt'] as DateTime?;
        if (current == null || (dt != null && dt.isAfter(current))) {
          row['_saidaDt'] = dt ?? current;
          row['saida'] = hora;
        }
      }
    }

    final rows = map.values.toList();
    rows.sort((a, b) {
      final aData = (a['data'] ?? '').toString();
      final bData = (b['data'] ?? '').toString();
      final aMat = (a['matricula'] ?? '').toString();
      final bMat = (b['matricula'] ?? '').toString();
      final aDt = _parseDataHoraPtBr(aData, '00:00:00') ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDt = _parseDataHoraPtBr(bData, '00:00:00') ?? DateTime.fromMillisecondsSinceEpoch(0);
      final cmp = aDt.compareTo(bDt);
      return cmp != 0 ? cmp : aMat.compareTo(bMat);
    });

    final buffer = StringBuffer()..writeln('nome,matricula,data,entrada,saida');
    for (final r in rows) {
      buffer.writeln(
        '${_csv(r['nome'])},${_csv(r['matricula'])},${_csv(r['data'])},${_csv(r['entrada'])},${_csv(r['saida'])}',
      );
    }

    final bytes = Uint8List.fromList(buffer.toString().codeUnits);
    final params = ShareParams(
      files: [XFile.fromData(bytes, mimeType: 'text/csv', name: nomeArquivo)],
      text: 'Exportação de pontos (por dia)',
      subject: 'Pontos (por dia)',
    );
    await SharePlus.instance.share(params);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Arquivo CSV (por dia) gerado com sucesso.')),
    );
  }

  String _csv(dynamic value) {
    final raw = (value ?? '').toString().replaceAll('"', '""');
    return '"$raw"';
  }

  void _abrirMeuPonto() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (ctx) => PontoPage(
          nome: widget.nome,
          codigo: widget.codigo,
          apenasVolta: true,
          onLogout: () async {
            if (ctx.mounted) Navigator.of(ctx).pop();
          },
        ),
      ),
    );
  }

  Widget _kpiCard(String titulo, String valor, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: _kGrayBorder.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: GoogleFonts.dmSans(fontSize: 11, color: _kGrayText),
          ),
          const SizedBox(height: 4),
          Text(
            valor,
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        title: const Text('Administrador'),
        actions: [
          IconButton(
            onPressed: _abrirMeuPonto,
            icon: const Icon(Icons.fingerprint),
            tooltip: 'Bater meu ponto',
          ),
          IconButton(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _streamPontos(),
        builder: (context, pontosSnap) {
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _streamSolicitacoes(),
            builder: (context, solicitacoesSnap) {
              if (pontosSnap.connectionState == ConnectionState.waiting ||
                  solicitacoesSnap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (pontosSnap.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar pontos: ${pontosSnap.error}',
                    style: GoogleFonts.dmSans(color: Colors.red),
                  ),
                );
              }
              if (solicitacoesSnap.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar solicitações: ${solicitacoesSnap.error}',
                    style: GoogleFonts.dmSans(color: Colors.red),
                  ),
                );
              }

              final pontosDocs = pontosSnap.data?.docs ?? [];
              final solicitacoesDocs = solicitacoesSnap.data?.docs ?? [];
              final pontosFiltrados = _filtrarPontos(pontosDocs);
              final resumosProfissionais = _resumosPorProfissional(pontosFiltrados);
              final solicitacoesFiltradas = _filtrarSolicitacoes(solicitacoesDocs);

              final funcionarios = <String>{};
              for (final p in pontosDocs) {
                final m = (p.data()['matricula'] ?? '').toString().trim();
                if (m.isNotEmpty) funcionarios.add(m);
              }
              final funcionariosOrdenados = funcionarios.toList()..sort();

              // Competências disponíveis a partir dos timestamps existentes.
              final competenciasSet = <String>{};
              for (final p in pontosDocs) {
                final ts = p.data()['timestamp'];
                final dt = ts is Timestamp ? ts.toDate() : null;
                if (dt != null) competenciasSet.add(_competenciaDeDateTime(dt));
              }
              final competencias = competenciasSet.toList()..sort();
              final competenciaAtual = _competenciaDeDateTime(DateTime.now());
              final competenciaDefault = competencias.contains(competenciaAtual)
                  ? competenciaAtual
                  : (competencias.isNotEmpty ? competencias.last : competenciaAtual);
              final competenciaEfetiva =
                  competencias.contains(_competencia) ? _competencia : competenciaDefault;

              final pendentes = solicitacoesDocs
                  .where((d) => (d.data()['status'] ?? '').toString() == 'pendente')
                  .length;
              final totalEntradas = pontosDocs
                  .where((d) => (d.data()['tipo'] ?? '').toString() == 'ENTRAR')
                  .length;
              final totalSaidas = pontosDocs
                  .where((d) => (d.data()['tipo'] ?? '').toString() == 'SAIR')
                  .length;

              final isMesAtual = competenciaEfetiva == _competenciaDeDateTime(DateTime.now());

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    '${widget.nome} (${widget.codigo})',
                    style: GoogleFonts.dmSans(fontSize: 14, color: _kGrayText),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _exportarCsv(
                            context,
                            'pontos_${competenciaEfetiva}_marcacoes.csv',
                          ),
                          icon: const Icon(Icons.table_chart),
                          label: const Text('Exportar marcações'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _exportarCsvPorDia(
                            context,
                            'pontos_${competenciaEfetiva}_por_dia.csv',
                          ),
                          icon: const Icon(Icons.cloud_upload),
                          label: const Text('Exportar por dia'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownMenu<String>(
                          initialSelection: competenciaEfetiva,
                          label: const Text('Competência'),
                          onSelected: (v) => setState(() {
                            _competencia = v ?? competenciaDefault;
                            _filtroPeriodo = 'MES';
                          }),
                          dropdownMenuEntries: [
                            if (competencias.isEmpty)
                              DropdownMenuEntry(value: competenciaEfetiva, label: competenciaEfetiva),
                            ...competencias.reversed.map(
                              (c) => DropdownMenuEntry(value: c, label: c),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isMesAtual
                        ? 'Recorte automático: do dia 1 até hoje.'
                        : 'Recorte automático: mês completo.',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: _kGrayText.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 14),
                  GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 2.4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: [
                      _kpiCard('Funcionários', '${funcionarios.length}'),
                      _kpiCard('Pendências', '$pendentes', color: Colors.orangeAccent),
                      _kpiCard('Entradas', '$totalEntradas', color: Colors.greenAccent),
                      _kpiCard('Saídas', '$totalSaidas', color: Colors.lightBlueAccent),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _buscaController,
                    onChanged: (v) => setState(() => _busca = v),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: 'Buscar por nome, matrícula ou justificativa',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      DropdownMenu<String>(
                        initialSelection: _filtroTipo,
                        label: const Text('Tipo'),
                        onSelected: (v) => setState(() => _filtroTipo = v ?? 'TODOS'),
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: 'TODOS', label: 'Todos'),
                          DropdownMenuEntry(value: 'ENTRAR', label: 'Entradas'),
                          DropdownMenuEntry(value: 'SAIR', label: 'Saídas'),
                        ],
                      ),
                      DropdownMenu<String>(
                        initialSelection: _filtroPeriodo,
                        label: const Text('Período'),
                        onSelected: (v) => setState(() => _filtroPeriodo = v ?? '30D'),
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: 'HOJE', label: 'Hoje'),
                          DropdownMenuEntry(value: '7D', label: '7 dias'),
                          DropdownMenuEntry(value: '30D', label: '30 dias'),
                          DropdownMenuEntry(value: 'MES', label: 'Competência'),
                          DropdownMenuEntry(value: 'TODOS', label: 'Tudo'),
                        ],
                      ),
                      DropdownMenu<String>(
                        initialSelection: _filtroStatusSolicitacao,
                        label: const Text('Solicitações'),
                        onSelected: (v) =>
                            setState(() => _filtroStatusSolicitacao = v ?? 'PENDENTE'),
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: 'PENDENTE', label: 'Pendentes'),
                          DropdownMenuEntry(value: 'APROVADA', label: 'Aprovadas'),
                          DropdownMenuEntry(value: 'REJEITADA', label: 'Rejeitadas'),
                          DropdownMenuEntry(value: 'TODOS', label: 'Todas'),
                        ],
                      ),
                      DropdownMenu<String>(
                        initialSelection: _filtroFuncionario,
                        label: const Text('Funcionário'),
                        onSelected: (v) => setState(() => _filtroFuncionario = v ?? 'TODOS'),
                        dropdownMenuEntries: [
                          const DropdownMenuEntry(value: 'TODOS', label: 'Todos'),
                          ...funcionariosOrdenados.map(
                            (m) => DropdownMenuEntry(value: m, label: m),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Solicitações (${solicitacoesFiltradas.length})',
                    style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  if (solicitacoesFiltradas.isEmpty)
                    Text(
                      'Nenhuma solicitação para os filtros atuais.',
                      style: GoogleFonts.dmSans(color: _kGrayText),
                    )
                  else
                    ...solicitacoesFiltradas.map((doc) {
                      final d = doc.data();
                      final status = (d['status'] ?? '').toString();
                      final isPendente = status == 'pendente';
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${d['nome'] ?? ''} (${d['matricula'] ?? ''})',
                                style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Status: ${status.toUpperCase()}',
                                style: GoogleFonts.dmSans(
                                  color: isPendente
                                      ? Colors.orangeAccent
                                      : (status == 'aprovada' ? Colors.green : Colors.redAccent),
                                ),
                              ),
                              Text(
                                'Solicitado: ${d['tipoSolicitado'] ?? '-'} '
                                '${d['dataSolicitada'] ?? ''} ${d['horaSolicitada'] ?? ''}',
                                style: GoogleFonts.dmSans(color: _kGrayText),
                              ),
                              Text(
                                'Justificativa: ${d['justificativa'] ?? ''}',
                                style: GoogleFonts.dmSans(color: _kGrayText),
                              ),
                              if (!isPendente && (d['motivoRejeicao'] ?? '').toString().isNotEmpty)
                                Text(
                                  'Motivo rejeição: ${d['motivoRejeicao']}',
                                  style: GoogleFonts.dmSans(color: Colors.redAccent),
                                ),
                              if (isPendente)
                                Row(
                                  children: [
                                    TextButton.icon(
                                      onPressed: () => _aprovarSolicitacao(
                                        context: context,
                                        solicitacaoId: doc.id,
                                      ),
                                      icon: const Icon(Icons.check_circle, color: Colors.green),
                                      label: const Text('Aprovar'),
                                    ),
                                    TextButton.icon(
                                      onPressed: () => _rejeitarSolicitacao(
                                        context: context,
                                        solicitacaoId: doc.id,
                                      ),
                                      icon: const Icon(Icons.cancel, color: Colors.red),
                                      label: const Text('Rejeitar'),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 16),
                  Text(
                    'Pontos por profissional (${resumosProfissionais.length}) — '
                    '${pontosFiltrados.length} marcações no filtro',
                    style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Uma linha por profissional. Toque na linha para ver até 50 marcações.',
                    style: GoogleFonts.dmSans(fontSize: 11, color: _kGrayText.withValues(alpha: 0.8)),
                  ),
                  const SizedBox(height: 8),
                  if (resumosProfissionais.isEmpty)
                    Text(
                      'Nenhum registro para os filtros atuais.',
                      style: GoogleFonts.dmSans(color: _kGrayText),
                    )
                  else
                    _tabelaPontosPorProfissional(resumosProfissionais.take(200).toList()),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({
    super.key,
    required this.onSenhaAtualizada,
    required this.onLogout,
  });

  final Future<void> Function() onSenhaAtualizada;
  final Future<void> Function() onLogout;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _salvando = false;

  @override
  void dispose() {
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _salvarNovaSenha() async {
    if (_salvando) return;
    final novaSenha = _novaSenhaController.text;
    final confirmar = _confirmarSenhaController.text;

    if (novaSenha.length < 6) {
      _showMessage('A nova senha deve ter no mínimo 6 caracteres.', Colors.orange);
      return;
    }
    if (novaSenha != confirmar) {
      _showMessage('As senhas não conferem.', Colors.orange);
      return;
    }
    if (novaSenha == _senhaInicialFuncionario || novaSenha == _senhaInicialAdmin) {
      _showMessage('Escolha uma senha diferente da senha inicial.', Colors.orange);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showMessage('Sessão inválida. Faça login novamente.', Colors.red);
      await widget.onLogout();
      return;
    }

    setState(() => _salvando = true);
    try {
      await user.updatePassword(novaSenha).timeout(_authTimeout);
      final email = (user.email ?? '').toLowerCase();
      if (email.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection(_kColecaoSegurancaUsuarios)
            .doc(email)
            .set({
              'senhaInicialBloqueada': true,
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true))
            .timeout(_firestoreTimeout);
      }
      await widget.onSenhaAtualizada();
      if (!mounted) return;
      _showMessage('Senha atualizada com sucesso.', Colors.green);
    } on FirebaseAuthException catch (e) {
      _showMessage('Falha ao atualizar senha: ${e.message ?? e.code}', Colors.red);
    } on TimeoutException {
      _showMessage('Tempo excedido ao atualizar senha.', Colors.red);
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  void _showMessage(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        title: const Text('Troca de senha obrigatória'),
        actions: [
          IconButton(
            onPressed: _salvando ? null : widget.onLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'No primeiro acesso, troque a senha padrão para continuar.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(color: _kGrayText),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _novaSenhaController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Nova senha'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _confirmarSenhaController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Confirmar nova senha'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _salvando ? null : _salvarNovaSenha,
                    child: _salvando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Salvar nova senha'),
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
