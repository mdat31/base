import 'package:flutter/material.dart';

/// Network avatar that falls back to initials.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    required this.name,
    super.key,
    this.imageUrl,
    this.radius = 28,
  });

  final String name;
  final String? imageUrl;
  final double radius;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final hasImage = url != null && url.isNotEmpty;
    return CircleAvatar(
      radius: radius,
      foregroundImage: hasImage ? NetworkImage(url) : null,
      onForegroundImageError: hasImage ? (_, _) {} : null,
      child: Text(initials),
    );
  }
}
