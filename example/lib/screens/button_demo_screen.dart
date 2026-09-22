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
            AppButton(label: 'Filled', onPressed: () => _tap('Filled')),
            AppButton(
              label: 'Outlined',
              variant: AppButtonVariant.outlined,
              onPressed: () => _tap('Outlined'),
            ),
            AppButton(
              label: 'Text',
              variant: AppButtonVariant.text,
              onPressed: () => _tap('Text'),
            ),
          ]),
          _Section('Subtitle', [
            AppButton(
              label: 'Pay now',
              subtitle: 'Total \$25.00',
              textAlign: TextAlign.center,
              onPressed: () => _tap('Subtitle'),
            ),
            AppButton(
              label: 'Upgrade plan',
              subtitle: 'Get unlimited access',
              variant: AppButtonVariant.outlined,
              onPressed: () => _tap('Subtitle outlined'),
            ),
          ]),
          _Section('Leading / trailing', [
            AppButton(
              label: 'Leading icon',
              leading: const Icon(Icons.lock_outline),
              onPressed: () => _tap('Leading'),
            ),
            AppButton(
              label: 'Trailing icon',
              trailing: const Icon(Icons.arrow_forward),
              onPressed: () => _tap('Trailing'),
            ),
            AppButton(
              label: 'Both + subtitle',
              subtitle: 'Continue to checkout',
              leading: const Icon(Icons.shopping_cart_outlined),
              trailing: const Icon(Icons.chevron_right),
              alignment: MainAxisAlignment.spaceBetween,
              onPressed: () => _tap('Both'),
            ),
          ]),
          _Section('Loading (tap to simulate 2s)', [
            AppButton(
              label: 'Tap to load',
              isLoading: _loading,
              onPressed: _simulateLoading,
            ),
            AppButton(
              label: 'Submit',
              loadingLabel: 'Submitting...',
              isLoading: _loading,
              variant: AppButtonVariant.outlined,
              onPressed: _simulateLoading,
            ),
            AppButton(
              label: 'Custom loader',
              isLoading: _loading,
              loadingWidget: const Icon(Icons.hourglass_top, size: 20),
              onPressed: _simulateLoading,
            ),
          ]),
          const _Section('Disabled', [
            AppButton(label: 'Disabled filled'),
            AppButton(
              label: 'Disabled outlined',
              variant: AppButtonVariant.outlined,
            ),
            AppButton(
              label: 'Disabled text',
              variant: AppButtonVariant.text,
            ),
          ]),
          _Section('Sizing', [
            Align(
              alignment: Alignment.centerLeft,
              child: AppButton(
                label: 'Wrap content',
                isExpanded: false,
                onPressed: () => _tap('Wrap'),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: AppButton(
                label: 'Fixed 220 x 64',
                width: 220,
                height: 64,
                onPressed: () => _tap('Fixed'),
              ),
            ),
            AppButton(
              label: 'Compact',
              minHeight: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onPressed: () => _tap('Compact'),
            ),
          ]),
          _Section('Custom style', [
            AppButton(
              label: 'Custom colors',
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              onPressed: () => _tap('Colors'),
            ),
            AppButton(
              label: 'Pill shape',
              borderRadius: 32,
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              onPressed: () => _tap('Pill'),
            ),
            AppButton(
              label: 'Square with elevation',
              borderRadius: 0,
              elevation: 6,
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              onPressed: () => _tap('Square'),
            ),
            AppButton(
              label: 'Custom border',
              variant: AppButtonVariant.outlined,
              borderColor: Colors.purple,
              foregroundColor: Colors.purple,
              borderWidth: 3,
              borderRadius: 20,
              onPressed: () => _tap('Border'),
            ),
            AppButton(
              label: 'Custom text style',
              subtitle: 'Bigger and bolder',
              labelStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
              subtitleStyle: const TextStyle(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
              onPressed: () => _tap('Text style'),
            ),
            AppButton(
              label: 'With tooltip',
              tooltip: 'Long-press to see me',
              onPressed: () => _tap('Tooltip'),
              onLongPress: () => _tap('Long press'),
            ),
            AppButton(
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
              onPressed: () => _tap('Child'),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 8),
                  Text('Fully custom child'),
                ],
              ),
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
