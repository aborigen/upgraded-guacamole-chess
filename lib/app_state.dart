import 'dart:math';

import 'package:bishop/bishop.dart' as bishop;
import 'package:flutter/material.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';

// Piece type constants
const int PAWN = 1;
const int KNIGHT = 2;
const int BISHOP = 3;
const int ROOK = 4;
const int QUEEN = 5;
const int KING = 6;

// Colour constants used for bitwise operations on pieces
const int WHITE_PIECE_COLOUR = 0;

class AppState extends ChangeNotifier {
  String _sdkStatus;
  String get sdkStatus => _sdkStatus;

  late bishop.Game game;
  late SquaresState state;
  int player = Squares.white;
  bool aiThinking = false;
  bool flipBoard = false;

  AppState({required String sdkStatus}) : _sdkStatus = sdkStatus {
    _resetGame(false);
  }

  final Map<int, int> _pieceValues = {
    PAWN: 100,
    KNIGHT: 320,
    BISHOP: 330,
    ROOK: 500,
    QUEEN: 900,
    KING: 20000,
  };

  void onMove(Move move) async {
    bool result = game.makeSquaresMove(move);
    if (result) {
      state = game.squaresState(player);
      notifyListeners();
      if (game.gameOver) {
        return;
      }
    }

    if (state.state == PlayState.theirTurn && !aiThinking) {
      aiThinking = true;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 100));

      final bestMove = _findBestMove();
      game.makeMove(bestMove);

      aiThinking = false;
      state = game.squaresState(player);
      notifyListeners();
    }
  }

  void _resetGame([bool ss = true]) {
    game = bishop.Game(variant: bishop.Variant.mini());
    state = game.squaresState(player);
    if (ss) notifyListeners();
  }

  bishop.Move _findBestMove({int depth = 3}) {
    int bestScore = -99999;
    bishop.Move? bestMove;
    final moves = game.generateLegalMoves();

    for (final move in moves) {
      game.makeMove(move);
      final score = -_search(game, depth - 1, -100000, 100000);
      game.undo();
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    return bestMove ?? (moves.toList()..shuffle()).first;
  }

  int _search(bishop.Game game, int depth, int alpha, int beta) {
    if (depth == 0 || game.gameOver) {
      return _evaluateBoardForGame(game);
    }

    int bestScore = -99999;
    final moves = game.generateLegalMoves();
    if (moves.isEmpty) {
      if (game.inCheck) return -99999; // checkmate
      return 0; // stalemate
    }

    for (final move in moves) {
      game.makeMove(move);
      final score = -_search(game, depth - 1, -beta, -alpha);
      game.undo();
      bestScore = max(bestScore, score);
      alpha = max(alpha, score);
      if (alpha >= beta) {
        break;
      }
    }
    return bestScore;
  }

  int _evaluateBoardForGame(bishop.Game forGame) {
    int whiteScore = 0;
    int blackScore = 0;
    for (int i = 0; i < forGame.board.length; i++) {
      final pieceInt = forGame.board[i];
      if (pieceInt == 0) continue;

      final int type = pieceInt & 7;
      final int colour = pieceInt & 8;

      int value = _pieceValues[type] ?? 0;
      if (colour == WHITE_PIECE_COLOUR) {
        whiteScore += value;
      } else {
        blackScore += value;
      }
    }
    int material = whiteScore - blackScore;

    int perspective = (forGame.turn == Squares.white) ? 1 : -1;
    return material * perspective;
  }
}
