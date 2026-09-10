import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../core/services/storage_service.dart';
import '../../core/services/notification_service.dart'; 

// Estados do nosso Jejum
abstract class FastingState {}

class FastingInitial extends FastingState {}

class FastingRunning extends FastingState {
  final DateTime startTime;
  final DateTime endTime;
  final Duration elapsed; // Tempo que já passou
  final Duration remaining; // Tempo que falta
  final double progress; // Porcentagem do círculo 

  FastingRunning({
    required this.startTime,
    required this.endTime,
    required this.elapsed,
    required this.remaining,
    required this.progress,
  });
}

class FastingCubit extends Cubit<FastingState> {
  Timer? _timer;

  FastingCubit() : super(FastingInitial()) {
    // Quando o Cubit nasce, ele verifica se já tinha um jejum rodando
    _checkActiveFast();
  }

  void _checkActiveFast() {
    final startTimeStr = StorageService.box.get('fastStartTime');
    final durationHours = StorageService.box.get('fastDuration');

    if (startTimeStr != null && durationHours != null) {
      final startTime = DateTime.parse(startTimeStr);
      _startTimerLoop(startTime, durationHours);
    }
  }

  // Inicia um novo jejum de X horas
  void startFast(int hours) {
    final startTime = DateTime.now();
    
    // salva no banco local
    StorageService.box.put('fastStartTime', startTime.toIso8601String());
    StorageService.box.put('fastDuration', hours);
    
    _startTimerLoop(startTime, hours);

    NotificationService.showNotification(
      title: 'Jejum Iniciado',
      body: 'Seu protocolo de $hours horas começou! Foco!',
    );
  }

  // Encerra ou cancela o jejum
  void endFast() {
    _timer?.cancel();
    StorageService.box.delete('fastStartTime');
    StorageService.box.delete('fastDuration');
    emit(FastingInitial());
  }

  // O loop que atualiza a tela a cada 1 segundo
  void _startTimerLoop(DateTime startTime, int durationHours) {
    final endTime = startTime.add(Duration(hours: durationHours));

    _timer?.cancel(); // Garante que não há dois timers rodando
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      
      if (now.isAfter(endTime)) {
        // Jejum concluído, fica em 100% (1.0) e tempo restante zero
        emit(FastingRunning(
          startTime: startTime,
          endTime: endTime,
          elapsed: now.difference(startTime),
          remaining: Duration.zero,
          progress: 1.0, 
        ));
      } else {
        // calcula a diferença em tempo real
        final totalDuration = endTime.difference(startTime);
        final elapsed = now.difference(startTime);
        final remaining = endTime.difference(now);
        final progress = elapsed.inSeconds / totalDuration.inSeconds;

        emit(FastingRunning(
          startTime: startTime,
          endTime: endTime,
          elapsed: elapsed,
          remaining: remaining,
          progress: progress,
        ));
      }
    });
  }
  
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}