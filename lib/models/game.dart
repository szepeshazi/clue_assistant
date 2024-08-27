import 'package:clue/core/list_utils.dart';
import 'package:clue/models/accusation.dart';
import 'package:clue/models/accusation_response.dart';
import 'package:clue/models/accusation_response_strategy.dart';
import 'package:clue/models/accusation_strategy.dart';
import 'package:clue/models/clues.dart';
import 'package:clue/models/player.dart';

class Game {
  var _deck = <ClueItem>[];
  final  _murderCards = <ClueItem>[];
  final _defaultAccusationStrategy = RandomUnknownAccusationStrategy();
  final _defaultResponseStrategy = RandomClueAccusationResponseStrategy();
  final _players = <Player>[];

  void start() {
    _addPlayers();
    _shuffleDeck();
    _selectMurderCards();
    _dealCards();

    print(_players);
    print('Mystery clues: $_murderCards');

    int round = 0;
    Player? winner;

    while (round < 100 && winner == null) {
      winner = doTurn(round);
      round++;
    }

    if (winner != null) {
      print('*** Winner: $winner');
    } else {
      print('*** Unable to solve mystery in 100 rounds');
    }
  }

  void _addPlayers() {
    _players.addAll(
      [
        Player(
          name: 'Rozi',
          accusationStrategy: _defaultAccusationStrategy,
          responseStrategy: _defaultResponseStrategy,
        ),
        Player(
          name: 'Barbara',
          accusationStrategy: _defaultAccusationStrategy,
          responseStrategy: _defaultResponseStrategy,
        ),
        Player(
          name: 'Szepi',
          accusationStrategy: _defaultAccusationStrategy,
          responseStrategy: _defaultResponseStrategy,
        ),
      ],
    );
  }

  Player? doTurn(int round) {
    final playerIndex = round % _players.length;
    final currentRound = _players.loopedFromIndex(playerIndex);
    final accuser = currentRound.first;
    final accusation = accuser.accuse();
    print('Round $round, Player ${accuser.name} created accusation: $accusation');
    if (_isWinningAccusation(accuser: accuser, accusation: accusation)) {
      return accuser;
    }

    int responderIndex = 1;
    AccusationResponse response = AccusationResponse(hasEvidence: false);
    while (responderIndex < currentRound.length && !response.hasEvidence) {
      final responder = currentRound[responderIndex];
      response = responder.respondTo(accusation);
      print('        $responder\'s response to accusation: $response');
      accuser.processResponse(
        response: response,
        responder: responder,
      );
      // TODO: Other players processResponse

      responderIndex++;
    }
    if (!response.hasEvidence) {
        accuser.notify(accusation: accusation);
    }

    return null;
  }

  bool _isWinningAccusation({
    required Player accuser,
    required Accusation accusation,
  }) {
    if (!accusation.isFinal) {
      return false;
    }
    final clueCards = [accusation.person, accusation.weapon, accusation.room];
    if (_murderCards.every(clueCards.contains)) {
      return true;
    }
    return false;
  }

  void _shuffleDeck() {
    _deck = List.from(originalDeck);
    _deck.shuffle();
  }

  void _selectMurderCards() {
    for (final cType in ClueType.values) {
      final cardIndex = _deck.indexWhere((card) => card.type == cType);
      _murderCards.add(_deck.elementAt(cardIndex));
      _deck.removeAt(cardIndex);
    }
  }

  void _dealCards() {
    while (_deck.length >= _players.length) {
      for (final player in _players) {
        player.deal(_deck.removeAt(0));
      }
    }
  }
}
