import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:squares/squares.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:myapp/yandex_initializer.dart';

class AppState extends ChangeNotifier {
  String _sdkStatus = 'Initializing...';
  String get sdkStatus => _sdkStatus;

  late bishop.Game game;
  late SquaresState state;
  int player = Squares.white;
  bool aiThinking = false;
  bool flipBoard = false;

  AppState() {
    _initSdk();
    _resetGame(false);
  }

  void onMove(Move move) async {
    bool result = game.makeSquaresMove(move);
    if (result) {
      state = game.squaresState(player);
      notifyListeners();
    }
    if (state.state == PlayState.theirTurn && !aiThinking) {
      aiThinking = true;
      notifyListeners();
      await Future.delayed(Duration(milliseconds: Random().nextInt(4750) + 250));
      game.makeRandomMove();
      aiThinking = false;
      state = game.squaresState(player);
      notifyListeners();
    }
  }

  Future<void> _initSdk() async {
    final initializer = YandexInitializer();
    _sdkStatus = await initializer.init();
    notifyListeners();
  }

  void _resetGame([bool ss = true]) {
    game = bishop.Game(variant: bishop.Variant.mini());
    state = game.squaresState(player);
    if (ss) notifyListeners();
  }
}
