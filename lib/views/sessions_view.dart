import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SessionsView extends StatelessWidget {
  SessionsView({super.key});

  // ignore: lines_longer_than_80_chars
  final sessions = [
    (
      title: '5 avril 2024',
      subtitle: 'Menez ham',
    ),
    (
      title: '2 mars 2024',
      subtitle: 'Petit paradis',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sessions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) => ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          title: Text(
            sessions[index].title,
          ),
          subtitle: Text(
            sessions[index].subtitle,
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            context.pushNamed(
              'session_details',
              pathParameters: {
                'id': 'foo',
              },
            );
          },
        ),
      ),
    );
  }
}
