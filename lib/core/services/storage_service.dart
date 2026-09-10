import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String _boxName = 'mambaBox';

  // Método que sera chamado quando o app abrir
  static Future<void> init() async {
    await Hive.initFlutter();
    
    await Hive.openBox(_boxName);
  }

  static Box get box => Hive.box(_boxName);
}