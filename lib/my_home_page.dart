import 'package:flutter/material.dart';
import 'package:myapp/app_state.dart';
import 'package:provider/provider.dart';
import 'package:squares/squares.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Yandex Games SDK Demo')),
      body: Column(
        children: [
          Center(child: Text(appState.sdkStatus)),
          Expanded(
            child: Center(
              child: BoardController(
                state: appState.state.board,
                playState: appState.state.state,
                moves: appState.state.moves,
                pieceSet: PieceSet.merida(),
                theme: BoardTheme.brown,
                size: appState.state.size,
                onMove: appState.onMove,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
