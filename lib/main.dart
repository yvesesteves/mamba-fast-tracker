import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/storage_service.dart';
import 'core/services/notification_service.dart'; // <-- NOVO IMPORT AQUI
import 'features/auth/auth_cubit.dart';
import 'features/auth/login_page.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/fasting/fasting_cubit.dart';
import 'features/meals/meals_cubit.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await NotificationService.init(); 
  runApp(const MambaApp());
}

class MambaApp extends StatelessWidget {
  const MambaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = StorageService.box.get('isLoggedIn', defaultValue: false);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => FastingCubit()),
        BlocProvider(create: (context) => MealsCubit()),
      ],
      child: MaterialApp(
        title: 'Mamba Fast Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: isLoggedIn ? const DashboardPage() : const LoginPage(),
        ),

    );
  }
}