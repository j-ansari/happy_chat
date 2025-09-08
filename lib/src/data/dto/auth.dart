class SendOtpRequestDto {
  final String phone;

  SendOtpRequestDto(this.phone);

  Map<String, dynamic> toJson() => {'phone': phone};
}

class VerifyOtpRequestDto {
  final String phone;
  final int otp;

  VerifyOtpRequestDto({required this.phone, required this.otp});

  Map<String, dynamic> toJson() => {'phone': phone, 'otp': otp};
}

class AuthResponseDto {
  final String token;

  AuthResponseDto({required this.token});

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      AuthResponseDto(token: json['token'] as String);
}
