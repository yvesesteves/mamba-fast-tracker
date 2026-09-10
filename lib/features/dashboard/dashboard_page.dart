import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../fasting/fasting_cubit.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/time_formatter.dart'; // <-- NOVO IMPORT DO FORMATADOR
import '../auth/login_page.dart';
import '../meals/meals_widget.dart';
import 'weekly_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await StorageService.box.put('isLoggedIn', false);
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const WeeklyChart(),
            const SizedBox(height: 32),
            
            BlocBuilder<FastingCubit, FastingState>(
              builder: (context, state) {
                if (state is FastingInitial) {
                  return _buildStartFasting(context);
                } else if (state is FastingRunning) {
                  return _buildRunningFasting(context, state);
                }
                return const SizedBox();
              }
            ),
            
            const SizedBox(height: 40),
            const Divider(color: Colors.grey),
            const SizedBox(height: 24),
            
            const MealsWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildStartFasting(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Escolha seu protocolo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.read<FastingCubit>().startFast(12),
                child: const Text('12:12'),
              ),
              ElevatedButton(
                onPressed: () => context.read<FastingCubit>().startFast(16),
                child: const Text('16:8'),
              ),
              ElevatedButton(
                onPressed: () => context.read<FastingCubit>().startFast(18),
                child: const Text('18:6'),
              ),
              ElevatedButton(
                onPressed: () => _showCustomProtocolDialog(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade800),
                child: const Text('Customizado', style: TextStyle(color: Colors.white)),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showCustomProtocolDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Protocolo Customizado'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Quantas horas de jejum?',
              suffixText: 'horas',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final hours = int.tryParse(controller.text);
                if (hours != null && hours > 0) {
                  context.read<FastingCubit>().startFast(hours);
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Iniciar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRunningFasting(BuildContext context, FastingRunning state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 250,
            height: 250,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: state.progress,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey.shade800,
                  color: Colors.green,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Restante', style: TextStyle(color: Colors.grey)),
                      Text(
                        // USANDO O NOVO FORMATADOR AQUI
                        TimeFormatter.formatDuration(state.remaining),
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            // USANDO O NOVO FORMATADOR AQUI TAMBÉM
            'Tempo Decorrido: ${TimeFormatter.formatDuration(state.elapsed)}',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => context.read<FastingCubit>().endFast(),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Encerrar / Cancelar Jejum'),
          )
        ],
      ),
    );
  }
}