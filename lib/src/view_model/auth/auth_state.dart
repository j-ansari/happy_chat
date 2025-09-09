part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final bool isDisabled;
  final bool isSuccess;
  final bool isAuthenticated;
  final String? sendOtpError;
  final String? verifyOtpError;
  final int timer;
  final bool canResend;
  final String? phone;
  final String? token;

  const AuthState({
    this.isLoading = false,
    this.isDisabled = false,
    this.isSuccess = false,
    this.isAuthenticated = false,
    this.sendOtpError,
    this.verifyOtpError,
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
    String? sendOtpError,
    String? verifyOtpError,
    int? timer,
    bool? canResend,
    String? phone,
    String? token,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isDisabled: isDisabled ?? this.isDisabled,
      isSuccess: isSuccess ?? this.isSuccess,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      sendOtpError: sendOtpError ?? this.sendOtpError,
      verifyOtpError: verifyOtpError ?? this.verifyOtpError,
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
    sendOtpError,
    verifyOtpError,
    timer,
    canResend,
    phone,
    token,
  ];
}
