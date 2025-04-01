import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'app/data/services/http/http.dart';
import 'app/data/services/local/session_service.dart';
import 'app/data/services/remote/account_api.dart';
import 'app/data/services/remote/autheticatio_api.dart';
import 'app/data/services/remote/internet_checker.dart';
import 'app/data/services/repositories_implementation/account_repository_impl.dart';
import 'app/data/services/repositories_implementation/authentication_repository_impl.dart';
import 'app/data/services/repositories_implementation/connectivity_repository_impl.dart';
import 'app/domain/repositories/account_repository.dart';
import 'app/domain/repositories/authentication_repository.dart';
import 'app/domain/repositories/connectivity_repository.dart';
import 'app/my_app.dart';
import 'app/presentation/global/controller/session_controller.dart';

void main() {
  final sessionService = SessionService(
    const FlutterSecureStorage(),
  );
  final http = Http(
    apiKey: '063e120b5749a1c01a0d0e8c493e0500',
    baseUrl: 'https://api.themoviedb.org/3',
    client: Client(),
  );

  final accountApi = AccountApi(http);
  runApp(
    MultiProvider(
      providers: [
        Provider<ConnectivityRepository>(
          create: (context) {
            print('-------------------------ConnectivityRepository');

            return ConnectivityRepositoryImpl(
              Connectivity(),
              InternetChecker(),
            );
          },
        ),
        Provider<AccountRepository>(
          create: (context) {
            print('-------------------------accountRepository');
            return AccountRepositoryImpl(
              accountApi,
              sessionService,
            );
          },
        ),
        Provider<AuthenticationRepository>(
          create: (context) {
            print('-------------------------AuthenticationRepository');
            return AuthenticationRepositoryImpl(
              AuthenticationApi(http),
              sessionService,
              accountApi,
            );
          },
        ),
        ChangeNotifierProvider<SessionController>(
          create: (context) =>
              SessionController(authenticationRepository: context.read()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
