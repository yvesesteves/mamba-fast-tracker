import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/storage_service.dart';
import 'meal_model.dart';

class MealsCubit extends Cubit<List<Meal>> {
  MealsCubit() : super([]) {
    loadMeals();
  }

  void loadMeals() {
    final List<dynamic> storedMeals = StorageService.box.get('meals', defaultValue: []);
    final meals = storedMeals.map((e) => Meal.fromMap(e)).toList();
    meals.sort((a, b) => b.time.compareTo(a.time));
    emit(meals);
  }

  void addMeal(String name, int calories) {
    final newMeal = Meal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      calories: calories,
      time: DateTime.now(),
    );

    final currentMeals = List<Meal>.from(state)..add(newMeal);
    _saveAndEmit(currentMeals);
  }

  void deleteMeal(String id) {
    final currentMeals = state.where((m) => m.id != id).toList();
    _saveAndEmit(currentMeals);
  }

  // função para editar uma refeição existente
  void editMeal(String id, String newName, int newCalories) {
    final currentMeals = List<Meal>.from(state);
    final index = currentMeals.indexWhere((m) => m.id == id);
    
    if (index != -1) {
      final oldMeal = currentMeals[index];
      // substitui a refeição antiga por uma nova com os dados atualizados, mas mantém a mesma ID e Hora
      currentMeals[index] = Meal(
        id: oldMeal.id,
        name: newName,
        calories: newCalories,
        time: oldMeal.time,
      );
      _saveAndEmit(currentMeals);
    }
  }

  // função auxiliar para evitar repetição de código na hora de salvar
  void _saveAndEmit(List<Meal> updatedMeals) {
    final mealsMap = updatedMeals.map((m) => m.toMap()).toList();
    StorageService.box.put('meals', mealsMap);
    loadMeals();
  }
}