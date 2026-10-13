import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider_state.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final TextEditingController _answerCtrl = TextEditingController();
//limpia el controlador cuando la pantalla se cierra
  @override
  void dispose() {
    _answerCtrl.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final gp = context.read<GameProvider>();
    if (gp.gameActive) {
      gp.abortAndSave();
    }
    return true;
  }
//Guarda y regresa a la pantalla anterior.
  void _goBack() {
    final gp = context.read<GameProvider>();
    if (gp.gameActive) {
      gp.abortAndSave();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CONSENTRATE', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _goBack,
            tooltip: 'Volver',
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Temporizador rojo
                Text(
                  'Tiempo: ${gp.countdown}s',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),

                // Secuencia mostrada
                Expanded(
                  child: Center(
                    child: gp.showSequence
                        ? Text(
                      gp.sequence.join(', '),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    )
                        : const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(height: 16),

                // Campo de texto con línea (sin recuadro)
                TextField(
                  controller: _answerCtrl,
                  enabled: gp.inputEnabled,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Respuesta',
                    border: UnderlineInputBorder(), // solo línea
                  ),
                ),
                const SizedBox(height: 16),

                // Info de jugador
                _InfoLine(label: 'Competidor', value: gp.playerName),
                const SizedBox(height: 8),
                _InfoLine(label: 'Puntaje', value: gp.score.toString()),
                const SizedBox(height: 8),
                _InfoLine(label: 'Vidas restantes', value: gp.lives.toString()),
                const SizedBox(height: 16),

                // Botón VALIDAR
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: gp.validateEnabled
                        ? () {
                      final text = _answerCtrl.text.trim();
                      if (text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Debes escribir tu respuesta.')),
                        );
                        return;
                      }
                      context.read<GameProvider>().validateAnswer(text);
                      _answerCtrl.clear();

                      if (context.read<GameProvider>().lives == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Juego terminado. Sin vidas.')),
                        );
                      }
                    }
                        : null,
                    child: const Text('VALIDAR'),
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
//mostrar una línea de información con una parte en negrilla y otra normal.
class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value),
        ],
      ),
      textAlign: TextAlign.start,
      style: const TextStyle(fontSize: 16),
    );
  }
}
