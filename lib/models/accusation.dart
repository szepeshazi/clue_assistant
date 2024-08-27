import 'package:clue/models/clues.dart';
import 'package:clue/models/player.dart';

class Accusation {
  Accusation({
    required this.person,
    required this.weapon,
    required this.room,
    required this.accuser,
    this.isFinal = false,
  })  : assert(person.type == ClueType.person),
        assert(weapon.type == ClueType.weapon),
        assert(room.type == ClueType.room);

  final ClueItem person;
  final ClueItem weapon;
  final ClueItem room;
  final Player accuser;
  final bool isFinal;

  List<ClueItem> get clues => [person, weapon, room];

  @override
  String toString() {
    return 'Accusation{clues: $clues, isFinal: $isFinal}';
  }
}
