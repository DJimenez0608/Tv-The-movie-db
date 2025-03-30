import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'app/data/services/http/http.dart';
import 'app/data/services/remote/autheticatio_api.dart';
import 'app/data/services/remote/internet_checker.dart';
import 'app/data/services/repositories_implementation/account_repository_impl.dart';
import 'app/data/services/repositories_implementation/authentication_repository_impl.dart';
import 'app/data/services/repositories_implementation/connectivity_repository_impl.dart';
import 'app/domain/repositories/authentication_repository.dart';
import 'app/domain/repositories/connectivity_repository.dart';
import 'app/my_app.dart';

void main() {
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
        Provider(
          create: (context) {
            print('-------------------------accountRepository');
            return AccountRepositoryImpl();
          },
        ),
        Provider<AuthenticationRepository>(
          create: (context) {
            print('-------------------------AuthenticationRepository');
            return AuthenticationRepositoryImpl(
              const FlutterSecureStorage(),
              AuthenticationApi(
                Http(
                  apiKey: '063e120b5749a1c01a0d0e8c493e0500',
                  baseUrl: 'https://api.themoviedb.org/3',
                  client: http.Client(),
                ),
              ),
            );
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}
