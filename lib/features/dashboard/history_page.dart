import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final historyData = [ // adicionando histórico de dias anteriores para teste
      {'date': 'Ontem', 'calories': 1850, 'fasting': '16h 05m', 'goalReached': true},
      {'date': '07 de Set', 'calories': 2200, 'fasting': '14h 30m', 'goalReached': false},
      {'date': '06 de Set', 'calories': 1900, 'fasting': '18h 10m', 'goalReached': true},
      {'date': '05 de Set', 'calories': 1750, 'fasting': '16h 00m', 'goalReached': true},
      {'date': '04 de Set', 'calories': 2400, 'fasting': '12h 00m', 'goalReached': false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico Anterior'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: historyData.length,
        separatorBuilder: (_, _) => const Divider(),
        itemBuilder: (context, index) {
          final data = historyData[index];
          final goalReached = data['goalReached'] as bool;
          
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: goalReached ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
              child: Icon(
                goalReached ? Icons.check : Icons.close, 
                color: goalReached ? Colors.green : Colors.red,
              ),
            ),
            title: Text(data['date'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Jejum: ${data['fasting']}'),
            trailing: Text(
              '${data['calories']} kcal', 
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: goalReached ? Colors.green : Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }
}