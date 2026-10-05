import 'dart:io';

import 'package:flutter/material.dart';

class BuildCoverImage extends StatelessWidget {
  const BuildCoverImage({
    super.key,
    required this.onPickCoverImage,
    required this.onRemoveCoverImage,
    required this.coverImage,
  });

  final Future<void> Function() onPickCoverImage;
  final void Function() onRemoveCoverImage;

  final File? coverImage;

  @override
  Widget build(BuildContext context) {
    if (coverImage == null) {
      return InkWell(
        onTap: onPickCoverImage,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 190,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate_outlined, size: 48),
              SizedBox(height: 12),
              Text(
                'Tap to add cover image',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 5),
              Text('JPG, PNG or WebP', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            coverImage!,
            width: double.infinity,
            height: 190,
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          right: 10,
          top: 10,
          child: IconButton.filled(
            onPressed: onRemoveCoverImage,
            icon: const Icon(Icons.close),
          ),
        ),

        Positioned(
          bottom: 10,
          right: 10,
          child: FilledButton.tonalIcon(
            onPressed: onPickCoverImage,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Change'),
          ),
        ),
      ],
    );
  }
}
