import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:intl/intl.dart';

class ExpensesScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddRecord;

  ExpensesScreen({required this.onAddRecord});

  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedCurrency;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void _listen(TextEditingController controller) async {
    bool available = await _speech.initialize();
    if (available && !_isListening) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            controller.text = result.recognizedWords;
            _isListening = false; // Зупинка прослуховування після введення тексту
          });
        },
        localeId: 'uk-UA',
      );
    } else if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Витрати'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Сума витрат',
                suffixIcon: IconButton(
                  icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                  onPressed: () => _listen(_amountController),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              items: ['USD', 'EUR', 'UAH'].map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCurrency = newValue;
                });
              },
              decoration: InputDecoration(labelText: 'Валюта'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Коментар',
                suffixIcon: IconButton(
                  icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                  onPressed: () => _listen(_descriptionController),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Дата',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      locale: Locale('uk', 'UA'),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_amountController.text.isNotEmpty &&
                    _selectedCurrency != null &&
                    _dateController.text.isNotEmpty) {
                  widget.onAddRecord({
                    'type': 'Витрати',
                    'amount': double.tryParse(_amountController.text) ?? 0.0,
                    'currency': _selectedCurrency,
                    'date': DateTime.tryParse(_dateController.text) ?? DateTime.now(),
                    'description': _descriptionController.text,
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Будь ласка, заповніть всі поля')),
                  );
                }
              },
              child: Text('Зберегти'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}
