import '../../../../domain/either.dart' show Either;
import '../../../../domain/enums.dart';
import '../../../../domain/models/user/user.dart';
import '../../../../domain/repositories/authentication_repository.dart';
import '../../../global/state_notifier.dart';
import 'sign_in_state.dart';

class SignInController extends StateNotifier<SignInState> {
  SignInController(super.state, {required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  void onUserNameChanged(String text) {
    onlyUpodate(
      state.copyWith(
        username: text.trim().toLowerCase(),
      ),
    );
  }

  void onpasswordChanged(String text) {
    onlyUpodate(
      state.copyWith(
        password: text.replaceAll(' ', ''),
      ),
    );
  }

  Future<Either<SigInFailure, User>> submit() async {
    state = state.copyWith(fetching: true);
    final result = await authenticationRepository.sigIn(
      state.username,
      state.password,
    );
    result.when(
      (_) => state = state.copyWith(
        fetching: false,
      ),
      (_) {},
    );
    return result;
  }
}
