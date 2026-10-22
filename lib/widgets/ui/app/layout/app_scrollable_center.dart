import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';

/// Centers [child] in the viewport while keeping it scrollable.

class AppScrollableCenter extends StatelessWidget {
  const AppScrollableCenter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(child: child),
        ),
      ),
    );
  }
}
