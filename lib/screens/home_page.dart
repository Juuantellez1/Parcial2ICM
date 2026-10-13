import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _startGame() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe tu nombre para jugar.')),
      );
      return;
    }

    final gp = context.read<GameProvider>();

    if (gp.gameActive) {
      gp.abortAndSave();
    }

    gp.startNewGame(name);
    Navigator.pushNamed(context, "/P1");
  }

  void _openBest() {
    final gp = context.read<GameProvider>();
    if (gp.gameActive) {
      gp.abortAndSave();
    }
    Navigator.pushNamed(context, "/BEST");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'CONCENTRESE',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: Image.asset('assets/images/cerebro.png', fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 16),

                  // === Campo de nombre con estilo de línea (sin caja) ===
                  TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: UnderlineInputBorder(), // <--- Línea en vez de caja
                    ),
                    onSubmitted: (_) => _startGame(),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _startGame,
                    child: const Text('JUGAR'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _openBest,
                    child: const Text('VER MEJOR JUGADOR'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
