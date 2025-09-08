import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data_source/api_service.dart';
import '../data_source/exceptions.dart';
import '../model/auth.dart';

class AuthRepo {
  final ApiService api;

  AuthRepo(this.api);

  Future<void> sendOtp(String phone) async {
    try {
      await api.dio.post(
        '/api/v1/send-otp',
        data: SendOtpRequestDto(phone).toJson(),
      );
    } on DioException catch (e) {
      throw ApiException('Failed to send OTP');
    }
  }

  Future<String> verifyOtp(String phone, int otp) async {
    try {
      final resp = await api.dio.post(
        '/api/v1/verify-otp',
        data: VerifyOtpRequestDto(phone: phone, otp: otp).toJson(),
      );
      final dto = AuthResponseDto.fromJson(resp.data as Map<String, dynamic>);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', dto.token);
      return dto.token;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Invalid OTP');
      }
      throw ApiException(e.response?.data['message'] ?? '');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
