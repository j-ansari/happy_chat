import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happy_chat_app/src/data/data_source/api_service.dart';
import 'package:happy_chat_app/src/data/repo/auth_repo.dart';
import 'package:mockito/mockito.dart';

class MockApi extends Mock implements ApiService {}

void main() {
  group('AuthRepo', () {
    late MockApi api;
    late AuthRepo repo;
    setUp(() {
      api = MockApi();
      repo = AuthRepo(api);
    });
    test('sendOtp calls API', () async {
      when(api.dio.post('/api/v1/send-otp', data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {},
        ),
      );
      await repo.sendOtp('09363211109');

      verify(
        api.dio.post('/api/v1/send-otp', data: anyNamed('data')),
      ).called(1);
    });
  });
}
