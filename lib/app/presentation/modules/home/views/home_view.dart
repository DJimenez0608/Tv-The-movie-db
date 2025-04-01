import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../global/controller/session_controller.dart';
import '../../../routes/routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = Provider.of(context);
    final user = sessionController.state!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user.avatarPath != null)
              Image.network(
                  'https://image.tmdb.org/t/p/w500${user.avatarPath}'),
            Text(
              user.id.toString(),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              user.username,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            TextButton(
              onPressed: () async {
                await sessionController.signOut();
                Navigator.pushReplacementNamed(context, Routes.signIn);
              },
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
