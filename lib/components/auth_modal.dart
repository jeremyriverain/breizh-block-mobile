import 'package:breizh_blok_mobile/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthModal extends StatelessWidget {
  const AuthModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentifiez-vous'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                icon: SvgPicture.asset(
                  'assets/google_logo.svg',
                  semanticsLabel: 'Google Logo',
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(AuthenticateEvent());
                  Navigator.of(context).pop();
                },
                label: const Text('Continuer avec Google'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text('OU'),
            ),
            const SizedBox(
              width: 250,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthenticateEvent());
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Continuer avec l'email"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
