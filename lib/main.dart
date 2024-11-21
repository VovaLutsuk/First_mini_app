import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/expenses_screen.dart';
import 'screens/income_screen.dart';
import 'screens/list_screen.dart';
import 'autorization/login_screen.dart';
import 'autorization/registration_screen.dart';
import 'database.dart'; // Для доступу до бази даних

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
  List<Map<String, dynamic>> dataList = []; // Список записів

  // Функція для авторизації
  void _login(int id) {
    setState(() {
      isLoggedIn = true;
      userId = id; // Призначаємо id користувача
    });
  }

  // Функція для додавання запису
  void _addRecord(Map<String, dynamic> newRecord) {
    setState(() {
      dataList.add(newRecord);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Контроль витрат',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => LoginScreen(onLogin: _login),
        '/register': (context) => RegistrationScreen(),
        '/home': (context) => HomePage(
          onAddRecord: _addRecord,
          dataList: dataList,
          userId: userId ?? 1, // Якщо користувач не авторизований, використовуємо значення за замовчуванням
        ),
        '/expenses': (context) => ExpensesScreen(
          userId: userId ?? 1,
          onAddRecord: _addRecord,
        ),
        '/income': (context) => IncomeScreen(
          userId: userId ?? 1,
          onAddRecord: _addRecord,
        ),
        '/list': (context) => ListScreen(
          dataList: dataList,
        ),
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

class HomePage extends StatelessWidget {
  final Function(Map<String, dynamic>) onAddRecord;
  final List<Map<String, dynamic>> dataList;
  final int userId;

  HomePage({
    required this.onAddRecord,
    required this.dataList,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Контроль витрат')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/expenses');
              },
              child: Text('Витрати'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/income');
              },
              child: Text('Прибутки'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/list');
              },
              child: Text('Список'),
            ),
          ],
        ),
      ),
    );
  }
}
