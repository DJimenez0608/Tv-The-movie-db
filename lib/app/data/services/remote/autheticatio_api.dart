import '../../../domain/either.dart';
import '../../../domain/enums.dart';
import '../http/http.dart';

class AuthenticationApi {
  AuthenticationApi(this._http);
  final Http _http;

  Either<SigInFailure, String> _handleFailure(HttpFailure failure) {
    if (failure.statusCode != null) {
      switch (failure.statusCode!) {
        case 401:
          return Either.left(SigInFailure.unauthorizaed);
        case 404:
          return Either.left(SigInFailure.notFound);

        default:
          return Either.left(SigInFailure.unknown);
      }
    }
    if (failure.exception is NetWorkException) {
      return Either.left(SigInFailure.network);
    }
    return Either.left(SigInFailure.unknown);
  }

  Future<Either<SigInFailure, String>> createRequesToken() async {
    final result = await _http.request(
      '/authentication/token/new?api_key=',
      onSucces: (responseBody) {
        final json = responseBody as Map;
        return json['request_token'] as String;
      },
    );

    return result.when(
      _handleFailure,
      (requestToken) => Either.right(requestToken),
    );
  }

  Future<Either<SigInFailure, String>> createSessionWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final result = await _http.request(
      '/authentication/token/validate_with_login',
      onSucces: (responseBody) {
        final json = responseBody as Map;

        return json['request_token'];
      },
      method: HttpMethod.post,
      body: {
        'username': username,
        'password': password,
        'request_token': requestToken,
      },
    );

    return result.when(
      _handleFailure,
      (newrequestToken) => Either.right(newrequestToken),
    );
  }

  Future<Either<SigInFailure, String>> createSession(String requetToken) async {
    final result = await _http.request('/authentication/session/new', body: {
      'request_token': requetToken,
    }, onSucces: (responseBody) {
      final json = responseBody as Map;
      return json['session_id'] as String;
    }, method: HttpMethod.post);
    return result.when(
      _handleFailure,
      (sessionId) => Either.right(sessionId),
    );
  }
}
