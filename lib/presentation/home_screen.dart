// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_application_kids_drawing_app/presentation/image_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final List<File> _selectedImages = [];

  Future<void> _pickImageFromGallery() async {
    if (Platform.isAndroid) {
      // For Android 13 and above
      if (await Permission.photos.request().isGranted ||
          await Permission.storage.request().isGranted) {
        final pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );
        if (pickedFile != null) {
          setState(() {
            _selectedImages.add(File(pickedFile.path));
          });
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gallery access denied')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 249, 225, 235),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(63),

          child: AppBar(
            
            title: const Center(
              child: Text(
                'Kidzee Drawing',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            backgroundColor: const Color(0xFF512DA8),
          ),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            // Static assets
            ...[
                  'assets/image 1.jpg',
                  'assets/image 2.png',
                  'assets/image 3.jpg',
                  'assets/image 4.jpg',
                  'assets/image 5.jpg',
                  'assets/image 6.jpg',
                  'assets/image 5.jpg',
                  'assets/image 8.jpg',
                ]
                .map(
                  (path) => _buildImageCard(
                    Image.asset(path),
                    imagePath: path,
                    isFromGallery: false,
                  ),
                )
                .toList(),

            // Dynamically added images from gallery
            ..._selectedImages
                .map(
                  (file) => _buildImageCard(
                    Image.file(file),
                    imagePath: file.path,
                    isFromGallery: true,
                  ),
                )
                .toList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _pickImageFromGallery,
          child: const Icon(Icons.image),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF5E55C2),
        ),
      ),
    );
  }

  Widget _buildImageCard(
    Image image, {
    required String imagePath,
    required bool isFromGallery,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ImageOverlayCameraScreen(
              imagePath: imagePath,
              isFromGallery: isFromGallery,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFF8BBD0), width: 5),
        ),
        elevation: 4,
        child: Padding(padding: const EdgeInsets.all(8.0), child: image),
      ),
    );
  }
}
