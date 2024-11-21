import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> dataList;

  ListScreen({required this.dataList});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Список записів')),
      body: widget.dataList.isEmpty
          ? Center(child: Text('Немає записів'))
          : ListView.builder(
        itemCount: widget.dataList.length,
        itemBuilder: (context, index) {
          final item = widget.dataList[index];
          String formattedDate = DateFormat('yyyy-MM-dd').format(
            DateTime.tryParse(item['date'].toString()) ?? DateTime.now(),
          );

          final isExpense = item['type'] == 'Витрати';
          final indicatorColor = isExpense ? Colors.red : Colors.green;

          return Card(
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: indicatorColor,
                radius: 10,
              ),
              title: Text(
                '${item['type']}: ${item['amount']} ${item['currency']}',
                style: TextStyle(
                  color: indicatorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Дата: $formattedDate\nКоментар: ${item['description']}',
              ),
            ),
          );
        },
      ),
    );
  }
}
