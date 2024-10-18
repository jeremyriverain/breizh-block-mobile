import 'package:breizh_blok_mobile/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BbRestrictedView extends StatelessWidget {
  const BbRestrictedView({
    required this.child,
    super.key,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    if (context.read<AuthBloc>().state.isAuthenticated) {
      return child;
    }

    return const Scaffold(
      body: Center(
        child: Text('Accès non autorisé'),
      ),
    );
  }
}
