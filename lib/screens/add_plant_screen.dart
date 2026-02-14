import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/plant.dart';
import '../providers/plant_provider.dart';

class AddPlantScreen extends StatefulWidget {
  @override
  _AddPlantScreenState createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _scientificNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _wateringController = TextEditingController();
  final _sunlightController = TextEditingController();
  final _soilController = TextEditingController();
  final _careInstructionsController = TextEditingController();

  int _selectedCategoryId = 1;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _scientificNameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _wateringController.dispose();
    _sunlightController.dispose();
    _soilController.dispose();
    _careInstructionsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final plantProvider = Provider.of<PlantProvider>(context, listen: false);

      final careInstructions = _careInstructionsController.text
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();

      final newPlant = Plant(
        name: _nameController.text,
        scientificName: _scientificNameController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,
        categoryId: _selectedCategoryId,
        watering: _wateringController.text,
        sunlight: _sunlightController.text,
        soil: _soilController.text,
        careInstructions: careInstructions,
      );

      plantProvider.addPlant(newPlant);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'Plant added successfully!',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: Color(0xFF4A7C59),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final plantProvider = Provider.of<PlantProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A1A1A),
                    Color(0xFF0D0D0D),
                    Color(0xFF050505),
                  ],
                ),
              ),
            ),
          ),

          // Radial gradient accent
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF4A7C59).withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: CustomScrollView(
                  slivers: [
                    // Custom app bar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(24, 20, 24, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Back button
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.05),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            SizedBox(height: 32),

                            // Header
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF4A7C59),
                                        Color(0xFF2D5A3D),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Add New Plant',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Expand your green collection',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 15,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Form content
                    SliverToBoxAdapter(
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Basic Information Section
                              _buildSectionHeader(
                                'Basic Information',
                                'Essential details about your plant',
                              ),
                              SizedBox(height: 20),

                              _buildTextField(
                                controller: _nameController,
                                label: 'Plant Name',
                                hint: 'e.g., Snake Plant',
                                icon: Icons.local_florist,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter plant name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),

                              _buildTextField(
                                controller: _scientificNameController,
                                label: 'Scientific Name',
                                hint: 'e.g., Sansevieria trifasciata',
                                icon: Icons.science,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter scientific name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),

                              _buildTextField(
                                controller: _descriptionController,
                                label: 'Description',
                                hint: 'Tell us about this plant...',
                                icon: Icons.description,
                                maxLines: 4,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter description';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),

                              _buildTextField(
                                controller: _imageUrlController,
                                label: 'Image URL',
                                hint: 'https://example.com/plant.jpg',
                                icon: Icons.image,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter image URL';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 40),

                              // Category Selection
                              _buildSectionHeader(
                                'Category',
                                'Choose the best fit',
                              ),
                              SizedBox(height: 16),

                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF1A1A1A),
                                      Color(0xFF151515),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Color(0xFF4A7C59).withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: plantProvider.categories.map((
                                    category,
                                  ) {
                                    final isSelected =
                                        _selectedCategoryId == category.id;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedCategoryId = category.id;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: isSelected
                                              ? LinearGradient(
                                                  colors: [
                                                    Color(0xFF4A7C59),
                                                    Color(0xFF2D5A3D),
                                                  ],
                                                )
                                              : null,
                                          color: isSelected
                                              ? null
                                              : Colors.white.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? Color(0xFF4A7C59)
                                                : Colors.white.withOpacity(0.1),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Text(
                                          category.name,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.7),
                                            fontSize: 14,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                              SizedBox(height: 40),

                              // Care Requirements
                              _buildSectionHeader(
                                'Care Requirements',
                                'How to keep it thriving',
                              ),
                              SizedBox(height: 20),

                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      controller: _wateringController,
                                      label: 'Watering',
                                      hint: '2-3 times per week',
                                      icon: Icons.water_drop,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: _buildTextField(
                                      controller: _sunlightController,
                                      label: 'Sunlight',
                                      hint: 'Full sun',
                                      icon: Icons.wb_sunny,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),

                              _buildTextField(
                                controller: _soilController,
                                label: 'Soil Type',
                                hint: 'Well-draining potting mix',
                                icon: Icons.terrain,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter soil type';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),

                              _buildTextField(
                                controller: _careInstructionsController,
                                label: 'Care Instructions',
                                hint:
                                    'Each line will be a separate instruction...\nWater when soil is dry\nKeep in bright indirect light',
                                icon: Icons.assignment,
                                maxLines: 6,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter care instructions';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 48),

                              // Submit button
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF4A7C59),
                                      Color(0xFF2D5A3D),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF4A7C59).withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(18),
                                    onTap: _submitForm,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            'Add Plant to Collection',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 60),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 14,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A1A1A), Color(0xFF151515)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 15,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(14),
                child: Icon(
                  icon,
                  color: Color(0xFF4A7C59).withOpacity(0.7),
                  size: 22,
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: maxLines > 1 ? 18 : 16,
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
