import 'package:benrica/service/auth_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

setupProviders() {
  getIt.registerSingleton<AuthService>(AuthService());
}
