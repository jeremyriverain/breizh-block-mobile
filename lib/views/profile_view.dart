import 'package:breizh_blok_mobile/components/bb_restricted_clickable_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BbRestrictedClickableWidget(
            child: ListTile(
              title: const Text(
                'Sessions',
              ),
              leading: const Icon(Icons.event),
              onTap: () {
                context.pushNamed('sessions');
              },
            ),
          ),
          BbRestrictedClickableWidget(
            child: ListTile(
              title: const Text(
                'Statistiques',
              ),
              leading: const Icon(Icons.insert_chart),
              onTap: () {
                context.pushNamed('stats');
              },
            ),
          ),
          ListTile(
            title: const Text(
              'Téléchargements',
            ),
            leading: const Icon(Icons.download_outlined),
            onTap: () {
              context.pushNamed('downloads');
            },
          ),
        ],
      ),
    );
  }
}
