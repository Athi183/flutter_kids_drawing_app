import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreviewScreen extends StatelessWidget {
  final File imageFile;
  const ImagePreviewScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('preview')),
      body: Center(child: Image.file(imageFile)),
    );
  }
}
