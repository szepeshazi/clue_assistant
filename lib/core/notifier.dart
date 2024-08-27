class Notifier<T> {
  Notifier(this._state);

  T _state;

  T get state => _state;

  final subscriptions = <Subscription<T>>[];

  Subscription<T> listen(
    void Function(T value) callback, {
    Object Function(T value)? selector,
    bool triggerImmediately = false,
  }) {
    if (triggerImmediately) {
      callback(_state);
    }
    final sub = Subscription(callback, selector: selector);
    subscriptions.add(sub);
    return sub;
  }

  void emit(T newValue) {
    if (newValue == _state) {
      return;
    }
    for (final sub in subscriptions) {
      final selector = sub.selector;
      if (selector != null && selector(_state) == selector(newValue)) {
        continue;
      }
      sub.callback(newValue);
    }
    _state = newValue;
  }
}

class Subscription<T> {
  final void Function(T value) callback;
  Object Function(T value)? selector;

  Subscription(this.callback, {this.selector});
}
