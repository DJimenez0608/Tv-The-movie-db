import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'app/data/services/http/http.dart';
import 'app/data/services/remote/autheticatio_api.dart';
import 'app/data/services/remote/internet_checker.dart';
import 'app/data/services/repositories_implementation/authentication_repository_impl.dart';
import 'app/data/services/repositories_implementation/connectivity_repository_impl.dart';
import 'app/domain/repositories/authentication_repository.dart';
import 'app/domain/repositories/connectivity_repository.dart';
import 'app/my_app.dart';

void main() {
  runApp(Injector(
    connectivityRepository: ConnectivityRepositoryImpl(
      Connectivity(),
      InternetChecker(),
    ),
    authenticationRepository: AuthenticationRepositoryImpl(
      const FlutterSecureStorage(),
      AuthenticationApi(
        Http(
          apiKey: '063e120b5749a1c01a0d0e8c493e0500',
          baseUrl: 'https://api.themoviedb.org/3',
          client: http.Client(),
        ),
      ),
    ),
    child: const MyApp(),
  ));
}

class Injector extends InheritedWidget {
  const Injector({
    super.key,
    required super.child,
    required this.connectivityRepository,
    required this.authenticationRepository,
  });

  final ConnectivityRepository connectivityRepository;
  final AuthenticationRepository authenticationRepository;
  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) {
    return false;
  }

  static Injector of(BuildContext context) {
    final injector = context.dependOnInheritedWidgetOfExactType<Injector>();
    assert(injector != null, 'injector is null');
    return injector!;
  }
}
