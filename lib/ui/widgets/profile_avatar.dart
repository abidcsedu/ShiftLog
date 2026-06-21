import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../state/providers.dart';

/// Circular profile photo — shows the saved image, else the name's initial on a
/// brand tint, else a person icon. Pass [onTap] to make it interactive (adds a
/// small edit badge).
class ProfileAvatar extends StatelessWidget {
  final double radius;
  final String? photoPath;
  final String? name;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    required this.radius,
    this.photoPath,
    this.name,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasPhoto = photoPath != null && File(photoPath!).existsSync();
    final trimmed = name?.trim() ?? '';
    final initial = trimmed.isNotEmpty ? trimmed[0].toUpperCase() : null;

    Widget avatar = CircleAvatar(
      radius: radius,
      backgroundColor: scheme.primary.withValues(alpha: 0.18),
      foregroundImage: hasPhoto ? FileImage(File(photoPath!)) : null,
      child: hasPhoto
          ? null
          : (initial != null
              ? Text(initial,
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: radius * 0.85,
                  ))
              : Icon(Icons.person, color: scheme.primary, size: radius)),
    );

    if (onTap == null) return avatar;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: scheme.surface, width: 2),
              ),
              child: Icon(Icons.camera_alt,
                  size: radius * 0.42, color: scheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Picks an image (gallery/camera), copies it into app storage with a unique
/// name (busts the image cache), saves the path, and deletes the old file.
Future<void> _pickAndSave(WidgetRef ref, ImageSource source) async {
  final picked = await ImagePicker()
      .pickImage(source: source, maxWidth: 1024, imageQuality: 85);
  if (picked == null) return;
  final dir = await getApplicationDocumentsDirectory();
  final dest =
      '${dir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
  await File(picked.path).copy(dest);
  final old = ref.read(profilePhotoProvider);
  await ref.read(repositoryProvider).updateSettings(photoPath: dest);
  if (old != null && old != dest) {
    try {
      await File(old).delete();
    } catch (_) {}
  }
}

Future<void> _remove(WidgetRef ref) async {
  final old = ref.read(profilePhotoProvider);
  await ref.read(repositoryProvider).updateSettings(clearPhoto: true);
  if (old != null) {
    try {
      await File(old).delete();
    } catch (_) {}
  }
}

/// Bottom sheet to choose / take / remove the profile photo.
Future<void> showPhotoSheet(BuildContext context, WidgetRef ref) async {
  final hasPhoto = ref.read(profilePhotoProvider) != null;
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Choose from gallery'),
            onTap: () async {
              Navigator.pop(ctx);
              await _pickAndSave(ref, ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('Take a photo'),
            onTap: () async {
              Navigator.pop(ctx);
              await _pickAndSave(ref, ImageSource.camera);
            },
          ),
          if (hasPhoto)
            ListTile(
              leading: Icon(Icons.delete_outline,
                  color: Theme.of(ctx).colorScheme.error),
              title: Text('Remove photo',
                  style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
              onTap: () async {
                Navigator.pop(ctx);
                await _remove(ref);
              },
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
