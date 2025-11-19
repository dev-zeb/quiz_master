import 'package:flutter/material.dart';
import 'package:quiz_master/features/auth/domain/entities/app_user.dart';

class UserProfileChip extends StatelessWidget {
  const UserProfileChip({
    super.key,
    required this.user,
    required this.onTap,
  });

  final AppUser user;
  final VoidCallback onTap;

  bool get _isGuest {
    final name = user.displayName?.toLowerCase().trim() ?? '';
    return (user.email.isEmpty && name.contains('guest')) ||
        (user.id == 'guest-local');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final nameLetters = _isGuest ? '' : user.displayName?[0];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: colorScheme.primary,
          backgroundImage: !_isGuest && user.photoUrl != null
              ? NetworkImage(user.photoUrl!)
              : null,
          child: _isGuest
              ? Icon(
                  Icons.person,
                  size: 28,
                  color: colorScheme.onPrimary,
                )
              : Text(nameLetters!),
        ),
      ),
    );
  }
}
