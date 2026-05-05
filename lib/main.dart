import 'package:flutter/material.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:squares/squares.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:myapp/yandex_initializer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yandex Games SDK Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _sdkStatus = 'Initializing...';
  late bishop.Game game;
  late SquaresState state;
  int player = Squares.white;
  bool aiThinking = false;
  bool flipBoard = false;
  
  void _onMove(Move move) async {
    
  }

  @override
  void initState() {
    super.initState();
    _initSdk();
    _resetGame();
  }

  Future<void> _initSdk() async {
    final initializer = YandexInitializer();
    final status = await initializer.init();
    setState(() {
      _sdkStatus = status;
    });
  }

  void _resetGame([bool ss = true]) {
    game = bishop.Game(variant: bishop.Variant.standard());
    state = game.squaresState(player);
    if (ss) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yandex Games SDK Demo')),
      body: Column(
        children: [
          Center(child: Text(_sdkStatus)),
          Expanded(
            child: Center(
              child: BoardController(
                state: state.board,
                playState: state.state,
                pieceSet: PieceSet.merida(),
                theme: BoardTheme.brown,
                onMove: _onMove
              ),
            ),
          ),
        ],
      ),
    );
  }
}
