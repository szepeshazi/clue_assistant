import 'package:clue/core/vault.dart';
import 'package:flutter_test/flutter_test.dart';

class Animal {
  Animal({
    required this.name,
    required this.hasWings,
  });

  final String name;
  final bool hasWings;

  bool get canFly => hasWings;

  String makeNoise() {
    return 'Squeek? Burp? Kwak?';
  }
}

class FlyingSquirrel extends Animal {
  FlyingSquirrel({
    required super.name,
    super.hasWings = false,
  });

  @override
  String makeNoise() {
    return 'mak mak';
  }
}

void main() {
  test('Vault single class', () {
    final dog = Animal(name: 'Bert', hasWings: false);
    final vault = Vault.instance;
    vault.add<Animal>(dog);

    expect(vault.get<Animal>(), dog);
    expect(vault.get<Animal>().name, 'Bert');
    expect(vault.get<FlyingSquirrel>, throwsA(isA<VaultException>()));
    expect(vault.get<Object>(), dog);
  });

  test('Vault multiple classes', () {
    final dog = Animal(name: 'Bert', hasWings: false);
    final squirry = FlyingSquirrel(name: 'Ernie');
    final vault = Vault.instance;
    vault.add<Animal>(dog);
    vault.add<FlyingSquirrel>(squirry);

    expect(vault.get<Animal>(), dog);
    expect(vault.get<Animal>().name, 'Bert');
    expect(vault.get<Animal>().makeNoise(), 'Squeek? Burp? Kwak?');

    expect(vault.get<FlyingSquirrel>(), squirry);
    expect(vault.get<FlyingSquirrel>().makeNoise(), 'mak mak');
  });
}
