import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageOverlayCameraScreen extends StatefulWidget {
  final String imagePath;
  final bool isFromGallery;

  const ImageOverlayCameraScreen({
    super.key,
    required this.imagePath,
    this.isFromGallery = false,
  });

  @override
  State<ImageOverlayCameraScreen> createState() =>
      _ImageOverlayCameraScreenState();
}

class _ImageOverlayCameraScreenState extends State<ImageOverlayCameraScreen> {
  CameraController? _cameraController;
  double _opacity = 0.5;
  bool _isCameraInitialized = false;
  double _scale = 0.5;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    if (await Permission.camera.request().isGranted) {
      final cameras = await availableCameras();

      if (cameras.isNotEmpty) {
        try {
          _cameraController = CameraController(
            cameras[0],
            ResolutionPreset.medium,
            enableAudio: false,
          );

          await _cameraController!.initialize();

          setState(() {
            _isCameraInitialized = true;
          });
        } catch (e) {
          print("Error initializing camera: $e");
        }
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Widget _buildOverlayImage() {
    if (widget.imagePath.isEmpty) return const SizedBox();

    final imageWidget = widget.isFromGallery
        ? Image.file(
            File(widget.imagePath),
            width: double.infinity,
            fit: BoxFit.cover,
          )
        : Image.asset(
            widget.imagePath,
            width: double.infinity,
            fit: BoxFit.cover,
          );

    return Transform.scale(scale: _scale, child: imageWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8BBD0),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF512DA8),
        title: const Text(
          "Overlay Camera",
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.info_outline),
            color: Colors.white,
          ),
        ],
      ),
      body: _isCameraInitialized
          ? Stack(
              children: [
                Positioned.fill(child: CameraPreview(_cameraController!)),

                // Overlay image (scrollable if large)
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Opacity(
                          opacity: _opacity,
                          child: Center(child: _buildOverlayImage()),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF8BBD0),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Transparency",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                value: _opacity,
                                onChanged: (value) {
                                  setState(() {
                                    _opacity = value;
                                  });
                                },
                                min: 0.0,
                                max: 1.0,
                                activeColor: Colors.pinkAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              "Size",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                value: _scale,
                                onChanged: (value) {
                                  setState(() {
                                    _scale = value;
                                  });
                                },
                                min: 0.0,
                                max: 2.0,
                                activeColor: Colors.pinkAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
