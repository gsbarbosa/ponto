import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const PontoApp());

class PontoApp extends StatelessWidget {
  const PontoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ponto',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}

/// Controla a navegação: tela de login ou tela de ponto.
/// Uma vez logado, não há opção de deslogar.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _logado = false;
  String _nome = '';
  String _codigo = '';

  void _onLogin(String nome, String codigo) {
    setState(() {
      _logado = true;
      _nome = nome.trim();
      _codigo = codigo.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_logado) {
      return PontoPage(nome: _nome, codigo: _codigo);
    }
    return LoginPage(onLogin: _onLogin);
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLogin});

  final void Function(String nome, String codigo) onLogin;

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
      appBar: AppBar(
        title: const Text('Ponto - Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    hintText: 'Seu nome',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  onSubmitted: (_) => _entrar(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _codigoController,
                  decoration: const InputDecoration(
                    labelText: 'Código de matrícula',
                    hintText: 'Sua matrícula',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _entrar(),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _entrar,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(200, 48),
                  ),
                  child: const Text('Entrar'),
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

class _PontoPageState extends State<PontoPage> {
  bool _estaDentro = false;
  bool _carregando = false;

  // Cole aqui a URL do seu Google Apps Script (veja SETUP.md)
  static const _urlScript =
      'https://script.google.com/macros/s/AKfycbyJ_4bS7Mrb5vbea0MPaPj0wq9L83bOTUNFgbYoe_GLEYAhFLZSoIzg12UfhlM14FbD/exec';

  Future<void> _registrar(String tipo) async {
    setState(() => _carregando = true);
    setState(() => _estaDentro = !_estaDentro);

    final agora = DateTime.now();
    final dataStr = '${agora.day.toString().padLeft(2, '0')}/${agora.month.toString().padLeft(2, '0')}/${agora.year}';
    final horaStr = '${agora.hour.toString().padLeft(2, '0')}:${agora.minute.toString().padLeft(2, '0')}:${agora.second.toString().padLeft(2, '0')}';

    try {
      // Usa text/plain para evitar preflight CORS no web (Apps Script não envia headers CORS)
      final body = jsonEncode({
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

      final sucesso = response.statusCode >= 200 && response.statusCode < 400;

      if (sucesso) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$tipo registrado às $horaStr')),
          );
        }
      } else {
        setState(() => _estaDentro = !_estaDentro);
        debugPrint('HTTP ${response.statusCode}: ${response.body}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro HTTP ${response.statusCode}. Verifique a URL do script no SETUP.md.'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Ponto - ${widget.nome}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _estaDentro ? 'Você está dentro' : 'Você está fora',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _carregando ? null : _aoClicar,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(200, 60),
                    backgroundColor: _estaDentro ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: _carregando
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _estaDentro ? 'SAIR' : 'ENTRAR',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
