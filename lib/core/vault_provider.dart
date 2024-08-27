import 'package:clue/core/vault.dart';
import 'package:flutter/material.dart';

extension VaultProvider on BuildContext {
  T get<T>() => Vault.instance.get<T>();

  T? getOrNull<T>() => Vault.instance.getOrNull<T>();
}
