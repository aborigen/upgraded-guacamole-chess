
import 'package:flutter/foundation.dart';
import 'package:myapp/yandex_games.dart' as yandex;
import 'dart:html' as html;

class YandexInitializer {
  Future<String> init() async {
    // A more reliable check: see if we are running on a Yandex domain.
    final bool isHostedOnYandex = html.window.location.hostname!.contains('yandex.');

    if (kIsWeb && isHostedOnYandex) {
      try {
        final sdk = await yandex.init(yandex.InitOptions(ssp: true));
        final player = await sdk.getPlayer();
        final playerName = player.getName();
        return 'SDK Initialized! Player: $playerName';
      } catch (e) {
        return 'SDK Initialization failed: $e';
      }
    } else {
      // Mock a successful initialization for local or non-Yandex environments
      await Future.delayed(const Duration(seconds: 1)); // Simulate async delay
      return 'SDK Mock Initialized! Player: LocalUser';
    }
  }
}
