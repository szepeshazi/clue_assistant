import 'package:clue/models/accusation.dart';
import 'package:clue/models/accusation_response.dart';
import 'package:clue/models/accusation_response_strategy.dart';
import 'package:clue/models/accusation_strategy.dart';

import 'clues.dart';

class Player {
  Player({
    required this.name,
    required this.accusationStrategy,
    required this.responseStrategy,
  });

  final String name;
  final AccusationStrategy accusationStrategy;
  final AccusationResponseStrategy responseStrategy;

  final hand = <ClueItem>[];
  final knownItems = <ClueItem, Player>{};
  final winningClues = <ClueType, ClueItem>{};

  void deal(ClueItem card) => hand.add(card);

  Accusation accuse() {
    if (winningClues.length == 3) {
      return Accusation(
        person: winningClues[ClueType.person]!,
        weapon: winningClues[ClueType.weapon]!,
        room: winningClues[ClueType.room]!,
        accuser: this,
        isFinal: true,
      );
    }
    return accusationStrategy.accuse(player: this, winningClues: winningClues);
  }

  AccusationResponse respondTo(Accusation accusation) =>
      responseStrategy.respond(
        accusation: accusation,
        responder: this,
      );

  void processResponse({
    required AccusationResponse response,
    required Player responder,
  }) {
    if (response.evidence != null) {
      knownItems[response.evidence!] = responder;
      print(
          '         $name added ${response.evidence} as being at ${responder.name}');
    } else {
      // more stuff
    }
  }

  void notify({required Accusation accusation}) {
    final clues = accusation.clues.where((clue) => !hand.contains(clue));
    for (final clue in clues) {
      print('        $name added $clue to winning clues');
      winningClues[clue.type] = clue;
    }
  }

  @override
  String toString() => '$name $hand, known: ${knownItems.keys}, winning: ${winningClues.values}';
}
