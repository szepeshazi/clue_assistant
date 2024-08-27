import 'package:clue/core/notifier.dart';
import 'package:flutter_test/flutter_test.dart';

class Counter extends Notifier<int> {
  Counter(super.state);

  void inc() {
    emit(state + 1);
  }

  void set(int value) {
    emit(value);
  }
}

class Person {
  final String name;
  final int steps;
  String? badge;

  Person({
    required this.name,
    this.steps = 0,
    this.badge,
  });

  String get decoratedName => badge == null ? name : '$badge $name';

  @override
  String toString() => '$decoratedName ($steps steps today)';
}

class PersonNotifier extends Notifier<Person> {
  PersonNotifier(super.state);

  void walk([int steps = 1]) {
    final updatedSteps = state.steps + steps;
    final badge = updatedSteps > 10000 ? 'HERO' : null;
    emit(
      Person(
        name: state.name,
        steps: updatedSteps,
        badge: badge,
      ),
    );
  }
}

void main() {
  test('Simple State object', () {
    final counter = Counter(0);
    counter.listen((value) {
      print('State notification 1: $value');
    });
    counter.listen((value) {
      print('State notification 2: $value');
    });
    counter.inc();
    counter.inc();
    counter.set(2);
    counter.set(4);
  });

  test(
    'Compound State object',
    () {
      final person = PersonNotifier(Person(name: 'Peter'));

      person.listen((value) {
        print('State notification 1: $value');
      });

      person.listen(
        (value) {
          print('State notification for decorated name: $value');
        },
        selector: (value) => value.decoratedName,
        triggerImmediately: true,
      );

      person.walk();
      person.walk();
      person.walk(10000);
      person.walk(2500);
    },
  );
}
