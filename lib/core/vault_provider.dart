import 'package:clue/core/vault.dart';
import 'package:flutter/material.dart';

class VaultProvider extends StatelessWidget {
  const VaultProvider({
    required this.vault,
    required this.child,
    super.key,
  });

  final Vault vault;
  final Widget child;

  static VaultProvider of(BuildContext context) {
    final result = context.findAncestorWidgetOfExactType<VaultProvider>();
    assert(result != null, 'Vault not found');
    return result!;
  }

  @override
  Widget build(BuildContext context) => child;
}

extension VaultProviderExtension on BuildContext {
  T get<T>() => VaultProvider.of(this).vault.get<T>();
}
