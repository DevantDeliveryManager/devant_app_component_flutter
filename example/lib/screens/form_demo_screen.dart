import 'package:devant_components/devant_components.dart';
import 'package:flutter/material.dart';

/// Demo of every form widget: text field, dropdown, date picker, radio, chips.
class FormDemoScreen extends StatefulWidget {
  const FormDemoScreen({super.key});

  @override
  State<FormDemoScreen> createState() => _FormDemoScreenState();
}

class _FormDemoScreenState extends State<FormDemoScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _country;
  String? _gender = 'f';
  List<String> _interests = const ['Music'];
  DateTime? _dob;

  void _submit() {
    final ok = _formKey.currentState?.validate() ?? false;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(ok ? 'Form is valid' : 'Fix the errors')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forms')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Section('Text field', [
              const AppTextField(label: 'Basic', hint: 'Type something'),
              const AppTextField(
                label: 'With helper',
                helper: 'We never share your email',
                prefix: Icon(Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
              ),
              AppTextField(
                label: 'Validated (required)',
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'This field is required' : null,
              ),
              const AppTextField(
                label: 'Password',
                isPassword: true,
                prefix: Icon(Icons.lock_outline),
              ),
              const AppTextField(
                label: 'Bio',
                maxLines: 4,
                minLines: 3,
                maxLength: 120,
                showCounter: true,
              ),
              const AppTextField(label: 'External error', errorText: 'Taken'),
              const AppTextField(label: 'Disabled', enabled: false),
              AppTextField(
                label: 'Custom style',
                filled: false,
                borderRadius: 30,
                borderColor: Colors.purple,
                focusedBorderColor: Colors.deepPurple,
                suffix: const Icon(Icons.star, color: Colors.amber),
              ),
            ]),
            _Section('Dropdown', [
              AppDropdown<String>(
                label: 'Country',
                hint: 'Select a country',
                items: const ['India', 'USA', 'UK', 'Germany'],
                prefix: const Icon(Icons.public),
                onChanged: (v) => setState(() => _country = v),
                validator: (v) => v == null ? 'Pick a country' : null,
              ),
              const AppDropdown<int>(
                label: 'Disabled',
                items: [1, 2, 3],
                enabled: false,
              ),
              AppDropdown<int>(
                label: 'Custom item builder',
                items: const [1, 2, 3],
                itemBuilder: (_, n) => Row(
                  children: [
                    const Icon(Icons.looks_one_outlined),
                    const SizedBox(width: 8),
                    Text('Option $n'),
                  ],
                ),
              ),
            ]),
            _Section('Date picker', [
              AppDatePicker(
                label: 'Date of birth',
                value: _dob,
                lastDate: DateTime.now(),
                onChanged: (d) => setState(() => _dob = d),
                validator: (d) => d == null ? 'Select a date' : null,
              ),
              AppDatePicker(
                label: 'Custom format',
                dateFormatter: (d) => '${d.day}/${d.month}/${d.year}',
                borderRadius: 30,
              ),
              AppDatePicker(label: 'Disabled', enabled: false),
            ]),
            _Section('Radio', [
              AppRadio<String>(
                label: 'Gender',
                value: _gender,
                options: const [
                  AppRadioOption(value: 'm', label: 'Male'),
                  AppRadioOption(value: 'f', label: 'Female'),
                  AppRadioOption(
                    value: 'o',
                    label: 'Other',
                    subtitle: 'Prefer not to say',
                  ),
                ],
                onChanged: (v) => setState(() => _gender = v),
                validator: (v) => v == null ? 'Select one' : null,
              ),
              AppRadio<int>(
                label: 'Horizontal',
                direction: Axis.horizontal,
                value: 1,
                options: const [
                  AppRadioOption(value: 1, label: 'One'),
                  AppRadioOption(value: 2, label: 'Two'),
                ],
              ),
              AppRadio<int>(
                label: 'Disabled option',
                options: const [
                  AppRadioOption(value: 1, label: 'Enabled'),
                  AppRadioOption(value: 2, label: 'Disabled', enabled: false),
                ],
              ),
            ]),
            _Section('Chips', [
              AppChips<String>(
                label: 'Multi select (max 3)',
                items: const ['Music', 'Sports', 'Travel', 'Food', 'Movies'],
                value: _interests,
                multiSelect: true,
                maxSelection: 3,
                onChanged: (v) => setState(() => _interests = v),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Pick at least one' : null,
              ),
              AppChips<String>(
                label: 'Single select',
                items: ['Small', 'Medium', 'Large'],
                value: ['Medium'],
                allowDeselect: false,
              ),
              AppChips<String>(
                label: 'Custom colors',
                items: ['Red', 'Green', 'Blue'],
                multiSelect: true,
                selectedColor: Colors.deepOrange,
                selectedLabelColor: Colors.white,
                borderColor: Colors.deepOrange,
                borderRadius: 8,
              ),
            ]),
            AppButton(label: 'Validate form', onPressed: _submit),
            const SizedBox(height: 8),
            Text(
              'country: $_country, gender: $_gender, '
              'interests: $_interests, dob: $_dob',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
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
            Padding(padding: const EdgeInsets.only(bottom: 16), child: c),
        ],
      ),
    );
  }
}
