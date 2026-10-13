import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider_state.dart';

class BestPlayerPage extends StatelessWidget {
  const BestPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final best = context.watch<GameProvider>().bestPlayer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mejor jugador'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: best == null
                ? const Text(
              'Sin registros aún.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Nombre del jugador
                Text(
                  best.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Fecha y hora con microsegundos
                Text(
                  _formatDate(best.dateTime),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Puntaje (mismo estilo que la fecha)
                Text(
                  best.score.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Formato: dd/mm/yyyy hh:mm:microsegundos
  static String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    final us = dt.microsecond.toString().padLeft(6, '0');
    return '$d/$m/$y $hh:$mm:$us';
  }
}
