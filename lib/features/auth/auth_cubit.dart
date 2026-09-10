import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/storage_service.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading()); 
    
    await Future.delayed(const Duration(milliseconds: 1500));

    // Validação simples exigida 
    if (email.isNotEmpty && password.length >= 6) {
      // Salva no banco local que o usuário está logado
      await StorageService.box.put('isLoggedIn', true);
      emit(AuthSuccess());
    } else {
      emit(AuthError('E-mail inválido ou senha muito curta (min. 6 caracteres).'));
    }
  }

  Future<void> logout() async {
    await StorageService.box.put('isLoggedIn', false);
    emit(AuthInitial());
  }
}