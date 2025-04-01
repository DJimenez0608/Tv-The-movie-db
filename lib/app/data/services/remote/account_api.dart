import '../../../domain/models/user/user.dart';
import '../http/http.dart';

class AccountApi {
  AccountApi(this._http);

  final Http _http;

  Future<User?> getAccount(String sessionId) async {
    final result = await _http.request(
      '/account',
      onSucces: (json) {
        return User.fromJson(json);
      },
      queryParameters: {
        'session_id': sessionId,
      },
    );
    return result.when(
      (_) => null,
      (user) => user,
    );
  }
}
