import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Evolução Semanal (Kcal)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 2500, // define meta hipotética de teto de calorias diárias
                barTouchData: BarTouchData(enabled: false), 
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        // letras dos dias da semana
                        const days = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(days[value.toInt()], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false), // Remove as linhas de fundo
                borderData: FlBorderData(show: false), // Remove a borda do gráfico
                barGroups: [
                  _buildBar(0, 1800), // Domingo
                  _buildBar(1, 2100), // Segunda
                  _buildBar(2, 1950), // Terça
                  _buildBar(3, 2300), // Quarta
                  _buildBar(4, 1500), // Quinta
                  _buildBar(5, 2000), // Sexta
                  _buildBar(6, 800, isToday: true), // Sábado (destacado em verde)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // função auxiliar para desenhar cada barra individualmente
  BarChartGroupData _buildBar(int x, double y, {bool isToday = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          // Se for o dia de hoje, fica verde. Se for dia passado, cinza.
          color: isToday ? Colors.green : Colors.grey.shade700,
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}