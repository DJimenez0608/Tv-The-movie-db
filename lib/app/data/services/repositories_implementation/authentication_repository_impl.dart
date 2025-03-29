import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../domain/either.dart';
import '../../../domain/enums.dart';
import '../../../domain/models/user.dart';
import '../../../domain/repositories/authentication_repository.dart';
import '../remote/autheticatio_api.dart';

const _key = 'sessionId';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl(
    this._secureStorage,
    this._autheticatioApi,
  );
  final FlutterSecureStorage _secureStorage;
  final AuthenticationApi _autheticatioApi;
  @override
  Future<User?> getUserData() {
    return Future.value(User());
  }

  @override
  Future<bool> get isSignedIn async {
    final sessionId = await _secureStorage.read(key: _key);
    return sessionId != null;
  }

  @override
  Future<Either<SigInFailure, User>> sigIn(
    String username,
    String password,
  ) async {
    final requestTokenResult = await _autheticatioApi.createRequesToken();
    return requestTokenResult.when(
      (failure) {
        return Either.left(failure);
      },
      (requestToken) async {
        final loginResult = await _autheticatioApi.createSessionWithLogin(
          username: username,
          password: password,
          requestToken: requestToken,
        );

        return loginResult.when(
          (failure) {
            return Either.left(failure);
          },
          (newRequesToken) {
            return Either.right(
              User(),
            );
          },
        );
      },
    );
  }

  @override
  Future<void> signOut() {
    return _secureStorage.delete(key: _key);
  }
}
