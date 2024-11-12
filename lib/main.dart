import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Image Compression',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Image Compression'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker picker = ImagePicker();
  File? selectedImage;
  
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<XFile> compressImageFile(
    {
      required File imageFile, 
      int quality = 80, 
      CompressFormat format = CompressFormat.jpeg
    }) async {

    DateTime time = DateTime.now();
    final String targetPath = path.join(
      Directory.systemTemp.path, 'imagetemp-${format.name}-$quality-${time.second}.${format.name}'
    );

    final XFile? compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      targetPath,
      quality: quality,
      format: format
    );

    if (compressedImageFile == null){
      throw ("Image compression failed! Please try again.");
    }
    debugPrint("Compressed image saved to: ${compressedImageFile.path}");
    return compressedImageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedImage != null) 
              Image.file(
                selectedImage!
              ),
            TextButton(
              onPressed: () async {
                await pickImage();
              }, 
              child: const Text("Pick Image")
            ),

            ElevatedButton(
              onPressed: () {
                if (selectedImage != null) {
                  compressImageFile(
                    imageFile: selectedImage!,
                    quality: 10
                  );
                }
              }, 
              child: const Text("Compress")
            )
          ],
        ),
      ),
    );
  }
}
