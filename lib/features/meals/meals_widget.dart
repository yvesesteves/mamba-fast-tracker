import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'meals_cubit.dart';
import 'meal_model.dart';
import '../dashboard/history_page.dart';

class MealsWidget extends StatefulWidget {
  const MealsWidget({super.key});

  @override
  State<MealsWidget> createState() => _MealsWidgetState();
}

class _MealsWidgetState extends State<MealsWidget> {
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  
  // definindo uma meta diária fixa para o MVP
  final int _dailyGoal = 2000; 

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  void _submitMeal() {
    final name = _nameController.text;
    final calories = int.tryParse(_caloriesController.text) ?? 0;

    if (name.isNotEmpty && calories > 0) {
      context.read<MealsCubit>().addMeal(name, calories);
      _nameController.clear();
      _caloriesController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  // diálogo para editar a refeição
  void _showEditDialog(BuildContext context, Meal meal) {
    final editNameController = TextEditingController(text: meal.name);
    final editCaloriesController = TextEditingController(text: meal.calories.toString());

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Editar Refeição'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editNameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: editCaloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Calorias (kcal)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<MealsCubit>().deleteMeal(meal.id);
                Navigator.pop(dialogContext);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = editNameController.text;
                final newCalories = int.tryParse(editCaloriesController.text) ?? 0;
                
                if (newName.isNotEmpty && newCalories > 0) {
                  context.read<MealsCubit>().editMeal(meal.id, newName, newCalories);
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealsCubit, List<Meal>>(
      builder: (context, meals) {
        final totalCalories = meals.fold<int>(0, (sum, meal) => sum + meal.calories);
        
        // lógica do Status da Meta
        final isWithinGoal = totalCalories <= _dailyGoal;
        final statusText = isWithinGoal ? 'Dentro da meta' : 'Fora da meta';
        final statusColor = isWithinGoal ? Colors.green : Colors.red;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // resumo de Calorias com Status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //  evita quebra de tela
                      const Flexible(
                        child: Text(
                          'Total Consumido: ', 
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$totalCalories / $_dailyGoal kcal', 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Status: $statusText', style: TextStyle(color: statusColor, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // formulário para adicionar refeição
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'O que comeu?', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _caloriesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Kcal', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _submitMeal,
                  icon: const Icon(Icons.add),
                  iconSize: 32,
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            const Text(
              'Histórico de Hoje (Toque p/ editar ou deslize p/ excluir)', 
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            // Lista de Refeições
            meals.isEmpty
                ? const Padding(padding: EdgeInsets.all(16.0), child: Text('Nenhuma refeição registrada.', textAlign: TextAlign.center))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      final timeString = DateFormat('HH:mm').format(meal.time);

                      return Dismissible(
                        key: Key(meal.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => context.read<MealsCubit>().deleteMeal(meal.id),
                        child: ListTile(
                          title: Text(meal.name),
                          subtitle: Text(timeString),
                          trailing: Text('${meal.calories} kcal', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          onTap: () => _showEditDialog(context, meal),
                        ),
                      );
                    },
                  ),
                  
            const SizedBox(height: 24),
            
            // botão para abrir o histórico de dias anteriores
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HistoryPage()),
                );
              },
              icon: const Icon(Icons.history),
              label: const Text('Ver Histórico Completo'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}