import 'package:flutter/widgets.dart';
import 'dependency_injector.dart';

class DependencyProvider extends InheritedWidget {
  final DependencyInjector injector;

  const DependencyProvider({
    super.key,
    required this.injector,
    required super.child,
  });

  static DependencyInjector of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<DependencyProvider>();
    assert(
      provider != null,
      'DependencyProvider tidak ditemukan di widget tree',
    );
    return provider!.injector;
  }

  static DependencyInjector read(BuildContext context) {
    final provider = context
        .getInheritedWidgetOfExactType<DependencyProvider>();
    assert(
      provider != null,
      'DependencyProvider tidak ditemukan di widget tree',
    );
    return provider!.injector;
  }

  @override
  bool updateShouldNotify(DependencyProvider oldWidget) {
    return injector != oldWidget.injector;
  }
}
