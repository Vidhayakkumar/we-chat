import 'package:get_it/get_it.dart';
import 'backend/repository/auth/repo_auth.dart';
import 'data/repository/auth/auth_repository_impl.dart';
import 'data/source/auth/auth_firebase_service.dart';
import 'data/usecase/auth/signin.dart';
import 'data/usecase/auth/signup.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerLazySingleton<AuthFirebaseService>(
    () => AuthFirebaseServiceImp(),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );

  sl.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(),
  );

  sl.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(),
  );
}
