import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../domain/repositories/connectivity_repository.dart';
import '../remote/internet_checker.dart';

class ConnectivityRepositoryImpl implements ConnectivityRepository {
  ConnectivityRepositoryImpl(this._connectivity, this._internetChecker);
  // @override
  // Future<bool> get hasInternet {
  //   return true;
  // }

  final Connectivity _connectivity;
  final InternetChecker _internetChecker;

  @override
  Future<bool> get hasInternet async {
    final result = await _connectivity.checkConnectivity();

    if (result.contains(ConnectivityResult.none)) {
      return false;
    }
    return _internetChecker.hasInternet();
  }
}
