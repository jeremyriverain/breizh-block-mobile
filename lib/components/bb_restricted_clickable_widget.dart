import 'package:breizh_blok_mobile/blocs/auth_bloc.dart';
import 'package:breizh_blok_mobile/components/auth_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BbRestrictedClickableWidget extends StatelessWidget {
  const BbRestrictedClickableWidget({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthBloc>().state.isAuthenticated) {
      return child;
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return const AuthModal();
            },
          ),
        );
      },
      child: IgnorePointer(
        child: child,
      ),
    );
  }
}
