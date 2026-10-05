import 'package:flutter/material.dart';

/// Sign-up form for weather alerts.
///
/// Step 4: each field has a validator. The button only accepts the form when
/// every validator returns null.
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Obrigatório';
                  if (v.trim().length < 3) return 'Pelo menos 3 letras';
                  return null; // null means valid
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Obrigatório';
                  if (!v.contains('@') || !v.contains('.')) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
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
