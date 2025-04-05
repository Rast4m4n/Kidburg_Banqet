import 'package:flutter/material.dart';
import 'package:kidburg_banquet/core/di/i_di_scope.dart';

class DiScopeProvider<T extends IDiScope> extends InheritedWidget {
  const DiScopeProvider(
      {super.key, required this.diScope, required super.child});

  final T diScope;

  static T? of<T extends IDiScope>(BuildContext context) =>
      context.findAncestorWidgetOfExactType<DiScopeProvider<T>>()?.diScope;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
