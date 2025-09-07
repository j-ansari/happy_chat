import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repo/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo repo;

  AuthCubit(this.repo) : super(AuthInitial());

  Future<void> sendOtp(String phone) async {
    try {
      emit(AuthLoading());
      await repo.sendOtp(phone);
      emit(OtpSent(phone));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> verifyOtp(String phone, int otp) async {
    try {
      emit(AuthLoading());
      final token = await repo.verifyOtp(phone, otp);
      emit(Authenticated(token));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await repo.logout();
    emit(Unauthenticated());
  }
}
