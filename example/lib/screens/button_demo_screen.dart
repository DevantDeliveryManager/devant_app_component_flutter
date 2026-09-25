import 'dart:async';

import 'package:devant_components/devant_components.dart';
import 'package:flutter/material.dart';

/// Demo of every [AppButton] type, state and customization option.
class ButtonDemoScreen extends StatefulWidget {
  const ButtonDemoScreen({super.key});

  @override
  State<ButtonDemoScreen> createState() => _ButtonDemoScreenState();
}

class _ButtonDemoScreenState extends State<ButtonDemoScreen> {
  bool _loading = false;

  void _simulateLoading() {
    setState(() => _loading = true);
    Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  void _tap(String name) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$name tapped')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buttons')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section('Variants', [
            for (final v in ButtonVariant.values)
              AppButton(
                label: v.name,
                variant: v,
                onPressed: () => _tap(v.name),
              ),
          ]),
          _Section('Prefix / suffix icons', [
            AppButton(
              label: 'Prefix icon',
              prefixIcon: const Icon(Icons.lock_outline, size: 18),
              onPressed: () => _tap('Prefix'),
            ),
            AppButton(
              label: 'Suffix icon',
              suffixIcon: const Icon(Icons.arrow_forward, size: 18),
              onPressed: () => _tap('Suffix'),
            ),
          ]),
          _Section('Loading (tap to simulate 2s)', [
            AppButton(
              label: 'Tap to load',
              isLoading: _loading,
              onPressed: _simulateLoading,
            ),
            AppButton(
              label: 'Outline loading',
              variant: ButtonVariant.outline,
              isLoading: _loading,
              onPressed: _simulateLoading,
            ),
          ]),
          const _Section('Disabled', [
            AppButton(label: 'Disabled primary'),
            AppButton(label: 'Disabled outline', variant: ButtonVariant.outline),
          ]),
          _Section('Sizes (presets)', [
            for (final s in ButtonSize.values)
              AppButton(
                label: s.name,
                height: s,
                width: s,
                onPressed: () => _tap(s.name),
              ),
            AppButton(
              label: 'Full width',
              isFullWidth: true,
              onPressed: () => _tap('Full width'),
            ),
          ]),
          _Section('Custom values (via parameters)', [
            AppButton(
              label: 'Custom colors',
              color: Colors.deepOrange,
              textColor: Colors.white,
              onPressed: () => _tap('Colors'),
            ),
            AppButton(
              label: 'Pill shape',
              color: Colors.teal,
              textColor: Colors.white,
              borderRadius: BorderRadius.circular(32),
              onPressed: () => _tap('Pill'),
            ),
            AppButton(
              label: 'Explicit 220 x 64',
              widthValue: 220,
              heightValue: 64,
              fontSize: 18,
              onPressed: () => _tap('Explicit'),
            ),
            AppButton(
              label: 'Custom border',
              variant: ButtonVariant.outline,
              borderColor: Colors.purple,
              textColor: Colors.purple,
              borderWidth: 3,
              onPressed: () => _tap('Border'),
            ),
            AppButton(
              label: 'Custom success',
              variant: ButtonVariant.success,
              successColor: Colors.green.shade700,
              onSuccessColor: Colors.white,
              onPressed: () => _tap('Success'),
            ),
            AppButton(
              label: 'Cupertino style',
              platform: AppPlatformStyle.cupertino,
              onPressed: () => _tap('Cupertino'),
            ),
          ]),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.children);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final c in children)
            Padding(padding: const EdgeInsets.only(bottom: 12), child: c),
        ],
      ),
    );
  }
}
