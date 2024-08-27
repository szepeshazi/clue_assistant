import 'package:clue/core/list_utils.dart';
import 'package:clue/models/accusation.dart';
import 'package:clue/models/clues.dart';
import 'package:clue/models/player.dart';
import 'package:collection/collection.dart';

import 'dart:math' as math;

abstract class AccusationStrategy {
  Accusation accuse({
    required Player player,
    required Map<ClueType, ClueItem> winningClues,
  });
}

class RandomUnknownAccusationStrategy implements AccusationStrategy {
  @override
  Accusation accuse({
    required Player player,
    required Map<ClueType, ClueItem> winningClues,
  }) {
    final knownCards = [...player.hand, ...player.knownItems.keys];

    final p = winningClues[ClueType.person];
    final w = winningClues[ClueType.weapon];
    final r = winningClues[ClueType.room];
    final persons = p != null
        ? [p]
        : _unknownClues(knownCards: knownCards, type: ClueType.person);
    final weapons = w != null
        ? [w]
        : _unknownClues(knownCards: knownCards, type: ClueType.weapon);
    final rooms = r != null
        ? [r]
        : _unknownClues(knownCards: knownCards, type: ClueType.room);

    final singleCluePerType =
        persons.length == 1 && weapons.length == 1 && rooms.length == 1;
    if (singleCluePerType) {
      return Accusation(
        person: persons.first,
        weapon: weapons.first,
        room: rooms.first,
        accuser: player,
        isFinal: true,
      );
    }

    final personCandidate = persons.firstOrNull ??
        _backupCandidate(player: player, type: ClueType.person);
    final weaponCandidate = weapons.firstOrNull ??
        _backupCandidate(player: player, type: ClueType.weapon);
    final roomCandidate = rooms.firstOrNull ??
        _backupCandidate(player: player, type: ClueType.room);

    return Accusation(
      person: personCandidate,
      weapon: weaponCandidate,
      room: roomCandidate,
      accuser: player,
    );
  }

  List<ClueItem> _unknownClues({
    required List<ClueItem> knownCards,
    required ClueType type,
  }) {
    var response = originalDeck
        .where(
          (c) => c.type == type && !knownCards.contains(c),
        )
        .toList();
    response.shuffle();
    return response;
  }

  ClueItem _backupCandidate({required Player player, required ClueType type}) {
    final firstOwn = player.hand.firstWhereOrNull((c) => c.type == type);
    if (firstOwn != null) {
      return firstOwn;
    }

    final random = math.Random().nextInt(originalDeck.length);
    final anyOfGivenType = originalDeck
        .loopedFromIndex(random)
        .firstWhere((card) => card.type == type);
    return anyOfGivenType;
  }
}
