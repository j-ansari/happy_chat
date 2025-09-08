part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final bool isDisabled;
  final bool isSuccess;
  final bool isAuthenticated;
  final String? errorMessage;
  final int timer;
  final bool canResend;
  final String? phone;
  final String? token;

  const AuthState({
    this.isLoading = false,
    this.isDisabled = false,
    this.isSuccess = false,
    this.isAuthenticated = false,
    this.errorMessage,
    this.timer = 0,
    this.canResend = false,
    this.phone,
    this.token,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isDisabled,
    bool? isSuccess,
    bool? isAuthenticated,
    String? errorMessage,
    int? timer,
    bool? canResend,
    String? phone,
    String? token,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isDisabled: isDisabled ?? this.isDisabled,
      isSuccess: isSuccess ?? this.isSuccess,
      isAuthenticated: isSuccess ?? this.isAuthenticated,
      errorMessage: errorMessage,
      timer: timer ?? this.timer,
      canResend: canResend ?? this.canResend,
      phone: phone ?? this.phone,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isDisabled,
    isSuccess,
    isAuthenticated,
    errorMessage,
    timer,
    canResend,
    phone,
    token,
  ];
}
