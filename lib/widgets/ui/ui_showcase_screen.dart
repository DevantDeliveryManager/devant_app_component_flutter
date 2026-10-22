import 'package:devant_components/devant_components.dart'
    show AppButton, ButtonVariant;
import 'package:devant_components/forms/app_textfield.dart';
import 'package:devant_components/widgets/ui/app/navigation/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:devant_components/extensions/context_extension.dart';
import 'package:devant_components/widgets/ui/app/actions/app_chip.dart';
import 'package:devant_components/widgets/ui/app/actions/app_icon_button.dart';

import '../../theme/theme_constants.dart';
import 'app/display/app_avatar.dart';
import 'app/display/app_badge.dart';
import 'app/display/app_card.dart';
import 'app/feedback/app_empty_state.dart';
import 'app/feedback/app_loading.dart';
import 'app/inputs/app_checkbox.dart';
import 'app/inputs/app_password_field.dart';
import 'app/inputs/app_switch.dart';
import 'app/navigation/app_scaffold.dart';


/// Live gallery of App (and optional ShadApp) components.
class UiShowcaseScreen extends StatelessWidget {
  const UiShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppTopBar(title: 'UI Showcase'),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          Text('Actions', style: context.textTheme.titleLarge),
          SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              AppButton(label: 'Primary', onPressed: () {}),
              AppButton(
                label: 'Secondary',
                variant: ButtonVariant.secondary,
                onPressed: () {},
              ),
              AppButton(
                label: 'Outline',
                variant: ButtonVariant.outline,
                onPressed: () {},
              ),
              AppIconButton(
                icon: Icons.favorite_outline,
                onPressed: () {},
              ),
              AppChip(label: 'Chip', selected: true, onSelected: (_) {}),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Text('Inputs', style: context.textTheme.titleLarge),
          SizedBox(height: AppSpacing.sm),
          const AppTextField(label: 'Email', hint: 'you@example.com'),
          SizedBox(height: AppSpacing.sm),
          const AppPasswordField(label: 'Password'),
          SizedBox(height: AppSpacing.sm),
          AppSwitch(value: true, onChanged: (_) {}),
          AppCheckbox(value: true, onChanged: (_) {}, label: 'Remember me'),
          SizedBox(height: AppSpacing.lg),
          Text('Display', style: context.textTheme.titleLarge),
          SizedBox(height: AppSpacing.sm),
          AppCard(
            title: 'Card title',
            subtitle: 'Uses design tokens for padding and radius.',
            child: Text(
              'Body content',
              style: context.textTheme.bodyMedium,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const AppAvatar(initials: 'FI'),
              SizedBox(width: AppSpacing.sm),
              const AppBadge(label: 'New'),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Text('Feedback', style: context.textTheme.titleLarge),
          SizedBox(height: AppSpacing.sm),
          const AppLoading(message: 'Loading…'),
          SizedBox(height: AppSpacing.sm),
          AppEmptyState(
            title: 'Nothing here',
            subtitle: 'Empty states use App actions.',
            actionLabel: 'Retry',
            onAction: () {},
          ),
        ],
      ),
    );
  }
}
