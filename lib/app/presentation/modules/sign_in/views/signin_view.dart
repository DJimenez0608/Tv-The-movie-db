import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/sign_in_controller.dart';
import '../controller/sign_in_state.dart';
import 'widgets/submit_button.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    print('-------------- build');
    return ChangeNotifierProvider<SignInController>(
      create: (BuildContext context) {
        return SignInController(
          authenticationRepository: context.read(),
          const SignInState(),
        );
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: Builder(builder: (context) {
                final controller = Provider.of<SignInController>(context);
                return AbsorbPointer(
                  absorbing: controller.state.fetching,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (text) {
                          controller.onUserNameChanged(text);
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
                          controller.onpasswordChanged(text);
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
                      const SubmitButton(),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
