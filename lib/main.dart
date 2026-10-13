import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider_state.dart'; //
import 'screens/home_page.dart';
import 'screens/game_page.dart';
import 'screens/best_player_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Concentrese',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: "/HOME",
        routes: {
          "/HOME": (context) => const HomePage(),
          "/P1": (context) => const GamePage(),
          "/BEST": (context) => const BestPlayerPage(),
        },
      ),
    ),
  );
}
