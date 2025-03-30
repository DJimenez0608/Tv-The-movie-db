import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/enums.dart';
import '../../../../domain/repositories/authentication_repository.dart';
import '../../../routes/routes.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String _username = '', _password = '';
  bool _fetching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            child: AbsorbPointer(
              absorbing: _fetching,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (text) {
                      setState(
                        () {
                          _username = text.trim().toLowerCase();
                        },
                      );
                    },
                    decoration: const InputDecoration(
                      hintText: 'username',
                    ),
                    validator: (text) {
                      text = text?.trim().toLowerCase() ?? '';
                      if (text.isEmpty) {
                        return 'invalid username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (text) {
                      setState(
                        () {
                          _password = text.replaceAll(' ', '');
                        },
                      );
                    },
                    decoration: const InputDecoration(
                      hintText: 'password',
                    ),
                    validator: (text) {
                      text = text?.replaceAll(' ', '') ?? '';
                      if (text.length < 4) {
                        return 'invalid password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Builder(
                    builder: (context) {
                      if (_fetching) {
                        return const CircularProgressIndicator();
                      }
                      return MaterialButton(
                        onPressed: () {
                          final isValid = Form.of(context).validate();
                          if (isValid) {
                            _submit(context);
                          }
                        },
                        color: Colors.blue,
                        child: const Text('Sign in'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    setState(() {
      _fetching = true;
    });
    final result = await context.read<AuthenticationRepository>().sigIn(
          _username,
          _password,
        );

    if (!mounted) {
      return;
    }
    result.when(
      (failure) {
        setState(() {
          _fetching = false;
        });
        final message = {
          SigInFailure.notFound: 'Not Found',
          SigInFailure.unauthorizaed: 'Invalid Password',
          SigInFailure.unknown: 'Error',
          SigInFailure.network: 'Network error'
        }[failure];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message!),
          ),
        );
      },
      (user) {
        Navigator.pushReplacementNamed(
          context,
          Routes.home,
        );
      },
    );
  }
}
