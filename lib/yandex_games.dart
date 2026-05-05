@JS()
library;

import 'dart:async';
import 'package:js/js.dart';

// This is the main SDK object
@JS('YaGames.init')
external Future<YandexGamesSDK> init(InitOptions options);

@JS()
@anonymous
class InitOptions {
  external factory InitOptions({bool ssp});
}

// This represents the SDK instance returned by init()
@JS()
@anonymous
class YandexGamesSDK {
  // Method to get the player
  @JS()
  external Future<Player> getPlayer();
}

// This represents the Player object
@JS()
@anonymous
class Player {
  // Method to get the player's name
  @JS()
  external String getName();
}
