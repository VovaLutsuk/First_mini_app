import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final Function(int) onLogin; // Функція для авторизації, яка приймає id користувача

  LoginScreen({required this.onLogin});

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitLogin(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {

      // Для простоти ми використовуємо id користувача як 1
      onLogin(1); // Викликаємо onLogin із id користувача
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Вхід')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
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
                onPressed: () => _submitLogin(context),
                child: Text('Увійти'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Реєстрація'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/password-recovery');
                },
                child: Text('Відновити пароль'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
