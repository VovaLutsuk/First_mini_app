import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/expenses_screen.dart';
import 'screens/income_screen.dart';
import 'screens/list_screen.dart';

void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatefulWidget {
  @override
  _ExpenseTrackerAppState createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  final List<Map<String, dynamic>> _dataList = [];

  void _addRecord(Map<String, dynamic> newRecord) {
    setState(() {
      _dataList.add(newRecord);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Контроль витрат',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        onAddRecord: _addRecord,
        dataList: _dataList,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('uk', 'UA'), // Українська
        Locale('en', 'US'), // Англійська
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  final Function(Map<String, dynamic>) onAddRecord;
  final List<Map<String, dynamic>> dataList;

  HomePage({required this.onAddRecord, required this.dataList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Контроль витрат'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpensesScreen(onAddRecord: onAddRecord),
                  ),
                );
              },
              child: Text('Витрати'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IncomeScreen(onAddRecord: onAddRecord),
                  ),
                );
              },
              child: Text('Прибутки'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListScreen(dataList: dataList),
                  ),
                );
              },
              child: Text('Список'),
            ),
          ],
        ),
      ),
    );
  }
}
