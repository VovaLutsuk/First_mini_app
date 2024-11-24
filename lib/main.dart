import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/expenses_screen.dart';
import 'screens/income_screen.dart';

import 'autorization/login_screen.dart';
import 'autorization/registration_screen.dart';
import 'autorization/password_recovery_screen.dart';
import 'database.dart';

void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatefulWidget {
  @override
  _ExpenseTrackerAppState createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  bool isLoggedIn = false; // Перевірка чи користувач авторизований
  int? userId; // Ідентифікатор користувача

  // Функція для авторизації
  void _login(int id) {
    setState(() {
      isLoggedIn = true;
      userId = id;
    });
  }

  // Функція для виходу
  void _logout(BuildContext context) {
    setState(() {
      isLoggedIn = false;
      userId = null;
    });
    // Повертаємо на екран логіну після виходу
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Функція для додавання запису
  void _addRecord(Map<String, dynamic> record) {
    DatabaseHelper.addRecord(
      record['user_id'],     // Ідентифікатор користувача
      record['type'],        // Тип (витрати чи прибутки)
      record['amount'],      // Сума
      record['currency'],    // Валюта
      record['date'],        // Дата
      record['description'], // Опис
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Контроль витрат',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => LoginScreen(onLogin: _login),
        '/register': (context) => RegistrationScreen(),
        '/home': (context) => HomePage(userId: userId!, onLogout: _logout),
        '/expenses': (context) => ExpensesScreen(onAddRecord: _addRecord, userId: userId!),
        '/income': (context) => IncomeScreen(onAddRecord: _addRecord, userId: userId!),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('uk', 'UA'),
        Locale('en', 'US'),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  final int userId;
  final void Function(BuildContext) onLogout;

  HomePage({required this.userId, required this.onLogout});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final records = await DatabaseHelper.getUserRecords(widget.userId);
    setState(() {
      _records = records;
    });
  }

  Future<void> _deleteRecord(int id) async {
    await DatabaseHelper.deleteRecord(id);
    _loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ваші записи'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              widget.onLogout(context); // Викликаємо функцію виходу
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/expenses')
                      .then((_) => _loadRecords());
                },
                child: Text('Витрати'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/income')
                      .then((_) => _loadRecords());
                },
                child: Text('Прибутки'),
              ),
            ],
          ),
          Expanded(
            child: _records.isEmpty
                ? Center(child: Text('Записів немає'))
                : ListView.builder(
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                // Визначення іконки для витрат та прибутків
                Icon icon = record['type'] == 'Витрати'
                    ? Icon(Icons.arrow_downward, color: Colors.red)
                    : Icon(Icons.arrow_upward, color: Colors.green);

                return Card(
                  child: ListTile(
                    leading: icon, // Відображаємо іконку
                    title: Text('${record['type']}: ${record['amount']} ${record['currency']}'),
                    subtitle: Text('${record['date']} — ${record['description']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.black),
                      onPressed: () {
                        _deleteRecord(record['id']);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
