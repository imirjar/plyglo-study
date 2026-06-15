// user_info_card.dart
import 'package:flutter/material.dart';
import 'package:poliglotim/app/data/models/user.dart';

class UserInfoCard extends StatelessWidget {
  final User user;
  final VoidCallback onPhotoTap;

  const UserInfoCard({
    super.key,
    required this.user,
    required this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: onPhotoTap,
              // child: CircleAvatar(
              // radius: 50,
              // backgroundImage: null,
              // child: null
              // ),
            ),
            const SizedBox(height: 16),
            Text(
              user.username,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'ID: ${user.id}',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
