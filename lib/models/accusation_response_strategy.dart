import 'package:clue/models/accusation.dart';
import 'package:clue/models/accusation_response.dart';
import 'package:clue/models/player.dart';
import 'package:collection/collection.dart';

abstract class AccusationResponseStrategy {
  AccusationResponse respond({
    required Accusation accusation,
    required Player responder,
  });
}

class RandomClueAccusationResponseStrategy
    implements AccusationResponseStrategy {
  @override
  AccusationResponse respond({
    required Accusation accusation,
    required Player responder,
  }) {
    final clues = [accusation.room, accusation.weapon, accusation.person];
    final randomHand = List.from(responder.hand)..shuffle();
    final responseClue = randomHand.firstWhereOrNull((c) => clues.contains(c));
    return AccusationResponse(
      hasEvidence: responseClue != null,
      evidence: responseClue,
    );
  }
}
