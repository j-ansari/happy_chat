import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:happy_chat_app/src/data/data_source/exceptions.dart';
import '../../data/repo/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo repo;
  Timer? _timer;

  AuthCubit(this.repo) : super(const AuthState());

  Future<void> sendOtp(String phone) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      await repo.sendOtp(phone);
      _startTimer();
      emit(
        state.copyWith(
          isSuccess: true,
          isAuthenticated: false,
          isLoading: false,
          phone: phone,
          timer: 60,
          canResend: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> verifyOtp(String phone, int otp) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final token = await repo.verifyOtp(phone, otp);
      emit(state.copyWith(isLoading: false, isSuccess: true, token: token));
    } catch (e) {
      e as ApiException;
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    }
  }

  Future<void> logout() async {
    await repo.logout();
    emit(const AuthState());
  }

  void _startTimer() {
    _timer?.cancel();
    int t = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (t > 0) {
        t--;
        emit(state.copyWith(timer: t));
      }
      if (t == 0) {
        emit(state.copyWith(canResend: true));
        _timer?.cancel();
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
