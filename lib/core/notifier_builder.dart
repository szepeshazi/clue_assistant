import 'package:clue/core/notifier.dart';
import 'package:clue/core/vault_provider.dart';
import 'package:flutter/material.dart';

typedef NotificationStateBuilder<T> = Widget Function(
  BuildContext context,
  T state,
  Widget? child,
);

class NotifierBuilder<T extends Notifier<S>, S> extends StatefulWidget {
  const NotifierBuilder({
    required this.builder,
    this.resolver,
    this.selector,
    this.child,
    super.key,
  });

  final Widget? child;

  final T Function()? resolver;
  final Object Function(S value)? selector;

  final NotificationStateBuilder<S> builder;

  @override
  State<NotifierBuilder<T, S>> createState() => _NotifierBuilderState<T, S>();
}

class _NotifierBuilderState<T extends Notifier<S>, S>
    extends State<NotifierBuilder<T, S>> {
  late S _state;

  @override
  void initState() {
    super.initState();
    try {
      if (widget.resolver != null) {
        _subscribe(widget.resolver!);
      }
    } catch (e) {
      print(e);
    }
  }

  void _subscribe(T Function() resolver) {
    final notifier = resolver();
    _state = notifier.state;
    notifier.listen(
      selector: widget.selector,
      (value) {
        setState(
          () {
            _state = value;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.resolver == null) {
      _subscribe(context.get<T>);
    }
    return widget.builder(context, _state, widget.child);
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

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NotifierBuilder<PersonNotifier, Person>(
          builder: (context, state, child) {
            return Text('$state');
          },
        ),
        NotifierBuilder<PersonNotifier, Person>(
          selector: (v) => v.badge != null,
          builder: (context, state, child) {
            final decorated = state.badge ?? 'no way';
            return Text('Is ${state.name} a decorated person? $decorated');
          },
        ),
        const SizedBox(height: 100),
        ElevatedButton(
          onPressed: () => context.get<PersonNotifier>().walk(3000),
          child: const Text('Walk 3000 m'),
        ),
      ],
    );
  }
}

/// using it
