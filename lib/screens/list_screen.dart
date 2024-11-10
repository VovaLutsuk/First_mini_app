import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> dataList;

  ListScreen({required this.dataList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список записів'),
      ),
      body: dataList.isEmpty
          ? Center(
        child: Text('Немає записів'),
      )
          : ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final item = dataList[index];

          // Форматуємо дату для відображення
          String formattedDate = DateFormat('yyyy-MM-dd').format(item['date']);

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text('${item['type']}: ${item['amount']} ${item['currency']}'),
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
