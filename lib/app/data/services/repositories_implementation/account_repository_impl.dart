import '../../../domain/models/user/user.dart';
import '../../../domain/repositories/account_repository.dart';
import '../local/session_service.dart';
import '../remote/account_api.dart';

class AccountRepositoryImpl extends AccountRepository {
  AccountRepositoryImpl(this._accountApi, this._sessionService);

  final AccountApi _accountApi;
  final SessionService _sessionService;
  @override
  Future<User?> getUserData() async {
    return _accountApi.getAccount(
      await _sessionService.sessionId ?? '',
    );
  }
}
