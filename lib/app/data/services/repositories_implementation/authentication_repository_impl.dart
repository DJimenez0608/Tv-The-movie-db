import '../../../domain/either.dart';
import '../../../domain/enums.dart';
import '../../../domain/models/user/user.dart';
import '../../../domain/repositories/authentication_repository.dart';
import '../local/session_service.dart';
import '../remote/account_api.dart';
import '../remote/autheticatio_api.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl(
    this._autheticatioApi,
    this._sessionService,
    this._accountApi,
  );
  final AuthenticationApi _autheticatioApi;
  final SessionService _sessionService;
  final AccountApi _accountApi;

  @override
  Future<bool> get isSignedIn async {
    final sessionId = await _sessionService.sessionId;
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
          (failure) async {
            return Either.left(failure);
          },
          (newRequesToken) async {
            final sessionResult = await _autheticatioApi.createSession(
              newRequesToken,
            );
            return sessionResult.when(
              (failure) async => Either.left(failure),
              (sessionId) async {
                await _sessionService.saveSessionId(sessionId);

                final user = await _accountApi.getAccount(sessionId);

                if (user == null) {
                  return Either.left(SigInFailure.unknown);
                }

                return Either.right(
                  user,
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Future<void> signOut() {
    return _sessionService.signOut();
  }
}
