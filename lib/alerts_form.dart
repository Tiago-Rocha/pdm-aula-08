import 'package:flutter/material.dart';

/// Sign-up form for weather alerts.
///
/// TODO 4: the button accepts anything, even empty fields. Give each
/// TextFormField a validator (null when the value is valid, the error message
/// when it is not), validate while the user types (autovalidateMode on the
/// Form), and open the email keyboard on the e-mail field.
class AlertsForm extends StatefulWidget {
  const AlertsForm({super.key});

  @override
  State<AlertsForm> createState() => _AlertsFormState();
}

class _AlertsFormState extends State<AlertsForm> {
  final _formKey = GlobalKey<FormState>(); // a field, never inside build
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    // validate() runs every validator and shows the errors
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Avisos enviados para ${_email.text}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Receber avisos', style: textTheme.titleMedium),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                // the name: required, at least 3 letters
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                // the e-mail: required, with an @ and a dot
              ),
              const SizedBox(height: 12),
              FilledButton(onPressed: _submit, child: const Text('Subscrever')),
            ],
          ),
        ),
      ),
    );
  }
}
