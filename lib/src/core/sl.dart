import 'package:get_it/get_it.dart';
import '../data/data_source/api_service.dart';
import '../data/data_source/mqtt_client.dart';
import '../data/repo/auth_repo.dart';
import '../data/repo/contact_repo.dart';
import '../data/repo/chat_repo.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerSingleton<ApiService>(ApiService());
  getIt.registerSingleton<MqttService>(MqttService());

  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(getIt<ApiService>()));
  getIt.registerLazySingleton<ContactRepo>(
    () => ContactRepo(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ChatRepo>(() => ChatRepo(getIt<MqttService>()));

  await getIt.get<MqttService>().init();
}
