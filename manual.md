# How to Integrate Yandex Games SDK Leaderboards

This document provides a step-by-step guide on how to integrate the Yandex Games SDK leaderboards feature into your Flutter application.

## Prerequisites

*   A Flutter project with the Yandex Games SDK already initialized.
*   A Yandex Games developer account.
*   A configured game in the Yandex Games console.

## Integration Steps

### 1. Create a Leaderboard in the Yandex Games Console

1.  Go to the Yandex Games console and select your game.
2.  Navigate to the "Leaderboards" section.
3.  Click "Create Leaderboard" and fill in the required fields:
    *   **ID:** A unique identifier for your leaderboard (e.g., `main_leaderboard`).
    *   **Name:** A user-friendly name for the leaderboard.
    *   **Type:** The type of leaderboard (e.g., `numeric`, `time`).
    *   **Sort Order:** The order in which scores are sorted (e.g., `descending`).

### 2. Update the Dart Wrapper for Leaderboards

Open the `lib/yandex_games.dart` file and add the following methods to the `YandexGames` class to interact with the leaderboards API:

```dart
@JS('ysdk.getLeaderboards')
external Future<Leaderboards> getLeaderboards();
```

You will also need to define the `Leaderboards` class and other related classes:

```dart
@JS()
@anonymous
class Leaderboards {
  external factory Leaderboards();

  external Future<void> setLeaderboardScore(String leaderboardName, int score);
  external Future<LeaderboardGetEntriesResult> getLeaderboardEntries(String leaderboardName, LeaderboardGetEntriesOptions options);
}

@JS()
@anonymous
class LeaderboardGetEntriesOptions {
  external factory LeaderboardGetEntriesOptions({
    bool includeUser,
    int quantityAround,
    int quantityTop,
  });
}

@JS()
@anonymous
class LeaderboardGetEntriesResult {
  external factory LeaderboardGetEntriesResult();

  external Leaderboard get leaderboard;
  external List<LeaderboardEntry> get entries;
}

@JS()
@anonymous
class Leaderboard {
  external factory Leaderboard();

  external String get name;
  external String get description;
}

@JS()
@anonymous
class LeaderboardEntry {
  external factory LeaderboardEntry();

  external int get score;
  external String get formattedScore;
  external int get rank;
  external Player get player;
}

@JS()
@anonymous
class Player {
  external factory Player();

  external String get publicName;
  external String get getAvatarSrc;
  external String get getAvatarSrcset;
}
```

### 3. Implement Leaderboard Functionality in Your App

Now you can use the new methods in your Flutter code to interact with the leaderboards.

#### Setting a Score

```dart
import 'package:js/js.dart';
import 'yandex_games.dart';

Future<void> submitScore(int score) async {
  final ysdk = await YandexGames.init();
  final leaderboards = await ysdk.getLeaderboards();
  await leaderboards.setLeaderboardScore('main_leaderboard', score);
}
```

#### Displaying the Leaderboard

You can fetch and display the leaderboard entries in your UI.

```dart
Future<void> showLeaderboard() async {
  final ysdk = await YandexGames.init();
  final leaderboards = await ysdk.getLeaderboards();
  final result = await leaderboards.getLeaderboardEntries('main_leaderboard', LeaderboardGetEntriesOptions(
    includeUser: true,
    quantityAround: 5,
    quantityTop: 5,
  ));

  for (final entry in result.entries) {
    print('Rank: ${entry.rank}, Score: ${entry.score}, Player: ${entry.player.publicName}');
  }
}
```
