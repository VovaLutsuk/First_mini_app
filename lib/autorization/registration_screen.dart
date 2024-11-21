import 'package:flutter/material.dart';

class RegistrationScreen extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitRegistration(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      // додати логіку для збереження користувача
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Реєстрація')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Ім\'я користувача'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Будь ласка, введіть ім\'я користувача';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _loginController,
                decoration: InputDecoration(labelText: 'Логін'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Будь ласка, введіть логін';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Будь ласка, введіть пароль';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () => _submitRegistration(context),
                child: Text('Зареєструватися'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
