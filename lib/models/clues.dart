enum ClueType {
  person,
  room,
  weapon,
}

class ClueItem {
  const ClueItem({
    required this.type,
    required this.name,
    this.assetPath,
  });

  final ClueType type;

  final String name;

  final String? assetPath;


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClueItem &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          name == other.name &&
          assetPath == other.assetPath;

  @override
  String toString() {
    return name;
  }

  @override
  int get hashCode => type.hashCode ^ name.hashCode ^ assetPath.hashCode;
}

const originalDeck = [
  ClueItem(type: ClueType.person, name: "Mrs. White"),
  ClueItem(type: ClueType.person, name: "Professor Plum"),
  ClueItem(type: ClueType.person, name: "Miss Scarlett"),
  ClueItem(type: ClueType.person, name: "Colonel Mustard"),
  ClueItem(type: ClueType.person, name: "Mrs. Peacock"),
  ClueItem(type: ClueType.person, name: "Reverend Green"),
  ClueItem(type: ClueType.weapon, name: "Knife"),
  ClueItem(type: ClueType.weapon, name: "Wrench"),
  ClueItem(type: ClueType.weapon, name: "Rope"),
  ClueItem(type: ClueType.weapon, name: "Revolver"),
  ClueItem(type: ClueType.weapon, name: "Lead pipe"),
  ClueItem(type: ClueType.weapon, name: "CandleStick"),
  ClueItem(type: ClueType.room, name: 'Kitchen'),
  ClueItem(type: ClueType.room, name: 'Gallery'),
  ClueItem(type: ClueType.room, name: 'Dining Room'),
  ClueItem(type: ClueType.room, name: 'Billiard Room'),
  ClueItem(type: ClueType.room, name: 'Library'),
  ClueItem(type: ClueType.room, name: 'Study'),
  ClueItem(type: ClueType.room, name: 'Lounge'),
  ClueItem(type: ClueType.room, name: 'Ballroom'),
  ClueItem(type: ClueType.room, name: 'Hall'),
];
