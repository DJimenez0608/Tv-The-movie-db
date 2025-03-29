import 'dart:convert';

import '../../../domain/either.dart';
import '../../../domain/enums.dart';
import '../http/http.dart';

class AuthenticationApi {
  AuthenticationApi(this._http);
  final Http _http;

  Future<Either<SigInFailure, String>> createRequesToken() async {
    final result = await _http.request(
      '/authentication/token/new?api_key=',
    );

    return result.when(
      (failure) {
        if (failure.exception is NetWorkException) {
          return Either.left(SigInFailure.network);
        }
        return Either.left(SigInFailure.unknown);
      },
      (responseBody) {
        final json = Map<String, dynamic>.from(
          jsonDecode(responseBody),
        );

        return Either.right(json['request_token'] as String);
      },
    );
  }

  Future<Either<SigInFailure, String>> createSessionWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final result = await _http.request(
      '/authentication/token/validate_with_login',
      method: HttpMethod.post,
      body: {
        'username': username,
        'password': password,
        'request_token': requestToken,
      },
    );

    return result.when(
      (failure) {
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
      },
      (responseBody) {
        final json = Map<String, dynamic>.from(jsonDecode(responseBody));

        final newRequestToken = json['request_token'];
        return Either.right(newRequestToken);
      },
    );
  }

  Future<Either<SigInFailure, String>> createSession(String requetToken) async {
    final result = await _http.request('/authentication/session/new',
        body: {
          'request_token': requetToken,
        },
        method: HttpMethod.post);
    return result.when(
      (failure) {
        if (failure is NetWorkException) {
          return Either.left(SigInFailure.network);
        }
        return Either.left(SigInFailure.unknown);
      },
      (responseBody) {
        final json = Map<String, dynamic>.from(
          jsonDecode(responseBody),
        );
        final sessionId = json['session_id'] as String;
        return Either.right(sessionId);
      },
    );
  }
}
