import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/plant_provider.dart';
import 'plant_detail_screen.dart';

class PlantIdentificationScreen extends StatefulWidget {
  @override
  _PlantIdentificationScreenState createState() =>
      _PlantIdentificationScreenState();
}

class _PlantIdentificationScreenState extends State<PlantIdentificationScreen> {
  File? _image;
  bool _isIdentifying = false;
  String? _identifiedPlant;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _identifiedPlant = null;
      });
      _identifyPlant();
    }
  }

  Future<void> _identifyPlant() async {
    setState(() {
      _isIdentifying = true;
    });

    // Simulate AI identification process
    await Future.delayed(Duration(seconds: 2));

    // Mock identification results
    final mockPlants = [
      'Monstera Deliciosa',
      'Snake Plant',
      'Peace Lily',
      'Spider Plant',
      'Pothos',
      'Fiddle Leaf Fig',
      'Rubber Plant',
      'ZZ Plant',
      'Boston Fern',
      'Aloe Vera',
    ];

    setState(() {
      _isIdentifying = false;
      _identifiedPlant =
          mockPlants[DateTime.now().millisecondsSinceEpoch % mockPlants.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Identification'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.camera_alt, size: 48, color: Colors.green),
                    SizedBox(height: 16),
                    Text(
                      'Identify Your Plant',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Take a photo or upload an image to identify your plant and get care instructions.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            if (_image != null) ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _image!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 16),
                      if (_isIdentifying)
                        Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 8),
                            Text('Identifying plant...'),
                          ],
                        )
                      else if (_identifiedPlant != null)
                        Column(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 48,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Identified: $_identifiedPlant',
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                // Find the plant by name
                                final plantProvider =
                                    Provider.of<PlantProvider>(
                                      context,
                                      listen: false,
                                    );
                                final identifiedPlant = plantProvider.plants
                                    .firstWhere(
                                      (plant) =>
                                          plant.name.toLowerCase() ==
                                          _identifiedPlant!.toLowerCase(),
                                      orElse: () => plantProvider
                                          .plants
                                          .first, // Fallback to first plant
                                    );

                                // Navigate to plant detail screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlantDetailScreen(
                                      plant: identifiedPlant,
                                    ),
                                  ),
                                );
                              },
                              child: Text('View Care Instructions'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: Icon(Icons.camera),
                    label: Text('Take Photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: Icon(Icons.photo_library),
                    label: Text('Upload Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How it works:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Text('• Take a clear photo of your plant'),
                    Text(
                      '• Include leaves, flowers, or stems for better identification',
                    ),
                    Text('• Ensure good lighting for accurate results'),
                    Text('• Get instant care instructions and tips'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
