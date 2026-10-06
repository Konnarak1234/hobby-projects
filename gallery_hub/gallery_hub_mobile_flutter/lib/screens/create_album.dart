import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_hub_mobile_flutter/screen_models/create_album_screen_model.dart';
import 'package:gallery_hub_mobile_flutter/widgets/build_cover_image.dart';
import 'package:image_picker/image_picker.dart';

class CreateAlbumScreen extends StatefulWidget {
  const CreateAlbumScreen({super.key});

  @override
  State<CreateAlbumScreen> createState() => _CreateAlbumScreenState();
}

class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  final createAlbumScreenModel = CreateAlbumScreenModel();

  final _picker = ImagePicker();

  bool _isLoading = false;

  Future<void> _pickCoverImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1600,
    );

    if (image == null) {
      return;
    }

    if (!mounted) return;

    setState(() {
      createAlbumScreenModel.coverImage = File(image.path);
    });
  }

  void _removeCoverImage() {
    setState(() {
      createAlbumScreenModel.coverImage = null;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();

    super.dispose();
  }

  Future<void> _createAlbum() async {
    if (!_formKey.currentState!.validate() && createAlbumScreenModel.coverImage == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
        createAlbumScreenModel.title =  _titleController.text.trim();
        createAlbumScreenModel.location =  _locationController.text.trim();
        createAlbumScreenModel.description =  _descriptionController.text.trim();

      // start creating new album
      await createAlbumScreenModel.createAlbum();


      // Temporary simulation
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      _showSuccessDialog();

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create album: $e')));

    } finally {

      if (mounted) {
        setState(() {
          _isLoading = false;
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
          icon: const Icon(Icons.check_circle, size: 60, color: Colors.green),
          title: const Text('Album created!'),
          content: const Text(
            'Your album has been created successfully.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                // Later navigate to album detail.
              },
              child: const Text('View Album'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                // Later:
                //
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) =>
                //         UploadPhotoScreen(
                //           albumId: album.id,
                //         ),
                //   ),
                // );
              },
              child: const Text('Upload Photos'),
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
          'Create Album',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // -----------------------------
              // Cover image
              // -----------------------------
              BuildCoverImage(
                onPickCoverImage: _pickCoverImage,
                onRemoveCoverImage: _removeCoverImage,
                coverImage: createAlbumScreenModel.coverImage,
              ),

              const SizedBox(height: 25),

              // -----------------------------
              // Title
              // -----------------------------
              const Text(
                'Title *',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Family Trip',
                  prefixIcon: Icon(Icons.photo_album_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an album title';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // -----------------------------
              // Description
              // -----------------------------
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText: 'Tell something about this album...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              // -----------------------------
              // Location
              // -----------------------------
              const Text(
                'Location',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Siem Reap, Cambodia',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // -----------------------------
              // Privacy
              // -----------------------------
              const Text(
                'Privacy',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 30),

              // -----------------------------
              // Create button
              // -----------------------------
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _isLoading ? null : _createAlbum,
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text(
                            'Create Album',
                            style: TextStyle(fontSize: 16),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
