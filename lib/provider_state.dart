import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class PlayerScore {
  final String name;
  final int score;
  final DateTime dateTime;
  const PlayerScore({required this.name, required this.score, required this.dateTime});
}

class GameProvider extends ChangeNotifier {
  // Estado del juego
  String _playerName = '';
  int _score = 0;
  int _lives = 5;
  final List<int> _sequence = [];

  // Control de UI o del los contadores
  bool _showSequence = false;
  bool _inputEnabled = false;
  bool _validateEnabled = false;
  int _countdown = 3;
  Timer? _timer;
  final Random _rand = Random();
  bool _gameActive = false;

  // Puntajes en memoria (sesión)
  final List<PlayerScore> _scores = [];

  // Getters
  String get playerName => _playerName;
  int get score => _score;
  int get lives => _lives;
  List<int> get sequence => List.unmodifiable(_sequence);
  bool get showSequence => _showSequence;
  bool get inputEnabled => _inputEnabled;
  bool get validateEnabled => _validateEnabled && _lives > 0;
  int get countdown => _countdown;
  bool get gameActive => _gameActive;

  // Iniciar juego (permite mismo nombre; actualiza récord si supera)
  void startNewGame(String name) {
    _timer?.cancel();
    _playerName = name.trim();
    _score = 0;
    _lives = 5;
    _sequence.clear();
    _gameActive = true;
    _addNextNumber();
    _startShowSequencePhase();
    notifyListeners();
  }

  // Validar SOLO el último número de la secuencia
  void validateAnswer(String userText) {
    if (!_gameActive || !_validateEnabled || _lives == 0) return;

    final last = _parseLastNumber(userText);
    if (last == null) {
      // entrada inválida; no consumimos vida aquí
      notifyListeners();
      return;
    }

    final expected = _sequence.isNotEmpty ? _sequence.last : null;
    final isCorrect = expected != null && last == expected;

    if (isCorrect) {
      _score += 1;
    } else {
      _lives -= 1;
    }

    if (_lives <= 0) {
      _finalizeAndSave();
      return;
    }

    // Agrega nuevo número y reinicia fases
    _addNextNumber();
    _startShowSequencePhase();
    notifyListeners();
  }

  // Guardar y reiniciar si se abandona
  void abortAndSave() {
    if (_playerName.isNotEmpty) {
      _saveScore();
    }
    _resetGameState();
    notifyListeners();
  }

  PlayerScore? get bestPlayer {
    if (_scores.isEmpty) return null;
    _scores.sort((a, b) => b.score.compareTo(a.score));
    return _scores.first;
  }

  // ----- Internos -----
  void _startShowSequencePhase() {
    _showSequence = true;
    _inputEnabled = false;
    _validateEnabled = false;
    _countdown = 5;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      _countdown -= 1;
      if (_countdown <= 0) {
        t.cancel();
        _startInputPhase();
      }
      notifyListeners();
    });
  }

  void _startInputPhase() {
    _showSequence = false;
    _inputEnabled = true;
    _validateEnabled = true;
    notifyListeners();
  }
//rango de nuemeros
  void _addNextNumber() {
    final next = _rand.nextInt(101); // 0..100
    _sequence.add(next);
  }

  int? _parseLastNumber(String text) {
    if (text.trim().isEmpty) return null;
    final parts = text.split(',');
    for (int i = parts.length - 1; i >= 0; i--) {
      final s = parts[i].trim();
      if (s.isEmpty) continue;
      final n = int.tryParse(s);
      if (n != null) return n;
    }
    return null;
  }

  void _finalizeAndSave() {
    _validateEnabled = false;
    _inputEnabled = false;
    _showSequence = false;
    _gameActive = false;
    _saveScore();
    notifyListeners();
  }

  void _saveScore() {
    if (_playerName.isEmpty) return;
    final now = DateTime.now();

    final idx = _scores.indexWhere(
          (s) => s.name.toLowerCase() == _playerName.toLowerCase(),
    );
    if (idx >= 0) {
      final existing = _scores[idx];
      if (_score > existing.score) {
        _scores[idx] = PlayerScore(name: _playerName, score: _score, dateTime: now);
      }
    } else {
      _scores.add(PlayerScore(name: _playerName, score: _score, dateTime: now));
    }
  }

  void _resetGameState() {
    _timer?.cancel();
    _showSequence = false;
    _inputEnabled = false;
    _validateEnabled = false;
    _countdown = 5;
    _sequence.clear();
    _playerName = '';
    _score = 0;
    _lives = 3;
    _gameActive = false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
