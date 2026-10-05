import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhotoScreen extends StatefulWidget {
  final String albumUuid;
  final String albumTitle;

  const UploadPhotoScreen({
    super.key,
    required this.albumUuid,
    required this.albumTitle,
  });

  @override
  State<UploadPhotoScreen> createState() =>
      _UploadPhotoScreenState();
}

class _UploadPhotoScreenState
    extends State<UploadPhotoScreen> {

  final ImagePicker _picker = ImagePicker();

  final List<XFile> _selectedImages = [];

  bool _isUploading = false;

  static const int _maxPhotos = 20;

  Future<void> _pickImages() async {
    final List<XFile> images =
        await _picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 2000,
    );

    if (images.isEmpty) {
      return;
    }

    final remaining =
        _maxPhotos - _selectedImages.length;

    if (!mounted) return;

    if (remaining <= 0) {
      _showMaximumMessage();
      return;
    }

    setState(() {
      _selectedImages.addAll(
        images.take(remaining),
      );
    });

    if (images.length > remaining) {
      _showMaximumMessage();
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _showMaximumMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'You can select up to 20 photos at once.',
        ),
      ),
    );
  }

  Future<void> _uploadPhotos() async {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select at least one photo.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Later:
      //
      // await photoViewModel.uploadPhotos(
      //   albumUuid: widget.albumUuid,
      //   images: _selectedImages,
      // );

      await Future.delayed(
        const Duration(seconds: 3),
      );

      if (!mounted) return;

      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Upload failed: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 60,
          ),
          title: Text(
            '${_selectedImages.length} photos uploaded!',
          ),
          content: Text(
            'Your photos were added to '
            '${widget.albumTitle}.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                setState(() {
                  _selectedImages.clear();
                });
              },
              child: const Text(
                'Upload More',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                // Later navigate to AlbumDetailScreen.
              },
              child: const Text(
                'View Album',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Photos',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Column(
          children: [

            // Album information
            _buildAlbumHeader(),

            const Divider(height: 1),

            Expanded(
              child: _selectedImages.isEmpty
                  ? _buildEmptyState()
                  : _buildPhotoGrid(),
            ),

            if (_selectedImages.isNotEmpty)
              _buildBottomArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.photo_album_outlined,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Uploading to',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  widget.albumTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 20),

            const Text(
              'Add photos',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Select photos from your gallery '
              'to add to ${widget.albumTitle}.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            FilledButton.icon(
              onPressed: _pickImages,
              icon: const Icon(
                Icons.photo_library_outlined,
              ),
              label: const Text(
                'Select Photos',
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Maximum $_maxPhotos photos',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),

      itemCount:
          _selectedImages.length + 1,

      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),

      itemBuilder: (context, index) {

        if (index == _selectedImages.length) {
          return _buildAddPhotoButton();
        }

        return _buildPhotoItem(
          _selectedImages[index],
          index,
        );
      },
    );
  }

  Widget _buildPhotoItem(
    XFile image,
    int index,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(image.path),
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          right: 5,
          top: 5,
          child: InkWell(
            onTap: () {
              _removeImage(index);
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 17,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhotoButton() {
    return InkWell(
      onTap: _pickImages,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: const Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 35,
            ),
            SizedBox(height: 5),
            Text(
              'Add',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        15,
        20,
        20,
      ),
      decoration: BoxDecoration(
        color:
            Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.08,
            ),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '${_selectedImages.length} '
                  'photo${_selectedImages.length == 1 ? '' : 's'} '
                  'selected',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                Text(
                  '${_selectedImages.length}/$_maxPhotos',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed:
                    _isUploading
                        ? null
                        : _uploadPhotos,

                icon: _isUploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.cloud_upload_outlined,
                      ),

                label: Text(
                  _isUploading
                      ? 'Uploading...'
                      : 'Upload Photos',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}