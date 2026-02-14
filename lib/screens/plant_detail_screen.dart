import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';
import '../models/plant.dart';
import '../models/reminder.dart';
import '../providers/plant_provider.dart';
import 'edit_plant_screen.dart';
import 'edit_plant_screen.dart';

class PlantDetailScreen extends StatefulWidget {
  final Plant plant;

  PlantDetailScreen({required this.plant});

  @override
  _PlantDetailScreenState createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late Animation<double> _heroAnimation;
  late AnimationController _contentController;
  late Animation<double> _contentAnimation;
  late ScrollController _scrollController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();

    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _heroAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic),
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _contentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });

    _heroController.forward();
    Future.delayed(Duration(milliseconds: 300), () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _contentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plantProvider = Provider.of<PlantProvider>(context);
    final size = MediaQuery.of(context).size;
    final currentPlant = widget.plant;
    final isFavorite = plantProvider.isFavorite(currentPlant.id!);

    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Parallax background
          Positioned(
            top: -_scrollOffset * 0.5,
            left: 0,
            right: 0,
            height: size.height * 0.6,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2D5A3D).withOpacity(0.8),
                    Color(0xFF1A3D2A).withOpacity(0.9),
                    Color(0xFF0A0A0A),
                  ],
                ),
              ),
            ),
          ),

          // Floating elements
          Positioned(
            top: size.height * 0.1 - _scrollOffset * 0.3,
            right: size.width * 0.1,
            child: Transform.rotate(
              angle: _scrollOffset * 0.001,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
          ),

          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Parallax app bar
              SliverAppBar(
                expandedHeight: size.height * 0.5,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  // Edit button
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(
                        color: Color(0xFFFFB444).withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditPlantScreen(plant: currentPlant),
                          ),
                        );
                      },
                    ),
                  ),
                  // Delete button
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        _showDeleteConfirmation(
                          context,
                          plantProvider,
                          currentPlant,
                        );
                      },
                    ),
                  ),
                  // Favorite button
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        plantProvider.toggleFavorite(currentPlant.id!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFavorite
                                  ? 'Removed from favorites'
                                  : 'Added to favorites',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Plant image with parallax
                      Positioned.fill(
                        top: -_scrollOffset * 0.8,
                        child: Hero(
                          tag: 'plant_${currentPlant.id}',
                          child: CachedNetworkImage(
                            imageUrl: currentPlant.imageUrl,
                            cacheKey: currentPlant.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF4A7C59).withOpacity(0.3),
                                    Color(0xFF2D5A3D).withOpacity(0.5),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF4A7C59).withOpacity(0.3),
                                    Color(0xFF2D5A3D).withOpacity(0.5),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 120,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Gradient overlay for better text contrast
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.4),
                                Colors.black.withOpacity(0.8),
                              ],
                              stops: [0.3, 0.7, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // Plant info overlay
                      Positioned(
                        bottom: 30,
                        left: 24,
                        right: 24,
                        child: FadeTransition(
                          opacity: _heroAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4A7C59).withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'PLANT PROFILE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                currentPlant.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                currentPlant.scientificName,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.95),
                                  fontSize: 17,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content sections
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _contentAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF0A0A0A),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24),

                        // Quick stats bar
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF2D5A3D).withOpacity(0.3),
                                  Color(0xFF1A3D2A).withOpacity(0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Color(0xFF4A7C59).withOpacity(0.4),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildQuickStat(
                                  Icons.water_drop_outlined,
                                  'Easy Care',
                                ),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                _buildQuickStat(Icons.air, 'Air Purifier'),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                _buildQuickStat(
                                  Icons.pets_outlined,
                                  'Pet Safe',
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Care information
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 40, 24, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4A7C59),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'CARE REQUIREMENTS',
                                    style: TextStyle(
                                      color: Color(0xFF4A7C59),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Essential care information',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Care grid with actual data
                        _buildCareGrid(currentPlant),

                        // Description
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 32, 24, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4A7C59),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'ABOUT THIS PLANT',
                                    style: TextStyle(
                                      color: Color(0xFF4A7C59),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 18),
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Color(0xFF1A1A1A),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Color(0xFF4A7C59).withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  currentPlant.description,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 15,
                                    height: 1.7,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Care Instructions
                        if (currentPlant.careInstructions.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF4A7C59),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'CARE INSTRUCTIONS',
                                      style: TextStyle(
                                        color: Color(0xFF4A7C59),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 18),
                                ...currentPlant.careInstructions
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 16),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 6),
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: Color(
                                                  0xFF4A7C59,
                                                ).withOpacity(0.2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${entry.key + 1}',
                                                  style: TextStyle(
                                                    color: Color(0xFF4A7C59),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 14),
                                            Expanded(
                                              child: Text(
                                                entry.value,
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  fontSize: 14,
                                                  height: 1.6,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                    .toList(),
                              ],
                            ),
                          ),

                        // Set reminder button
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: LinearGradient(
                                colors: [Color(0xFF4A7C59), Color(0xFF3D6A4C)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF4A7C59).withOpacity(0.4),
                                  blurRadius: 16,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () =>
                                    _showReminderDialog(context, currentPlant),
                                borderRadius: BorderRadius.circular(18),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 18),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.alarm_add,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Set Care Reminder',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
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
                        ),

                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFF4A7C59), size: 24),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    PlantProvider plantProvider,
    Plant plant,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.red.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.red.withOpacity(0.2),
                        Colors.red.withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
                SizedBox(height: 24),

                // Title
                Text(
                  'Delete Plant?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 12),

                // Message
                Text(
                  'Are you sure you want to delete "${plant.name}"? This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32),

                // Buttons
                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => Navigator.pop(dialogContext),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),

                    // Delete button
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF4444), Color(0xFFCC0000)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.4),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              plantProvider.deletePlant(plant.id!);
                              Navigator.pop(dialogContext); // Close dialog
                              Navigator.pop(
                                context,
                              ); // Go back to previous screen
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Plant deleted successfully',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: EdgeInsets.all(16),
                                ),
                              );
                            },
                            child: Center(
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCareGrid(Plant plant) {
    final careItems = [
      {
        'icon': Icons.water_drop_outlined,
        'title': 'Watering',
        'value': plant.watering,
        'color': Color(0xFF4A9FE5),
      },
      {
        'icon': Icons.wb_sunny_outlined,
        'title': 'Sunlight',
        'value': plant.sunlight,
        'color': Color(0xFFFFB444),
      },
      {
        'icon': Icons.grass_outlined,
        'title': 'Soil Type',
        'value': plant.soil,
        'color': Color(0xFF8B6F47),
      },
      {
        'icon': Icons.spa_outlined,
        'title': 'Difficulty',
        'value': 'Easy',
        'color': Color(0xFF4A7C59),
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.55,
        ),
        itemCount: careItems.length,
        itemBuilder: (context, index) {
          final item = careItems[index];
          return AnimatedBuilder(
            animation: _contentAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 50 * (1 - _contentAnimation.value)),
                child: Opacity(
                  opacity: _contentAnimation.value,
                  child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1A1A1A), Color(0xFF151515)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: (item['color'] as Color).withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (item['color'] as Color).withOpacity(0.1),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (item['color'] as Color).withOpacity(0.15),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: item['color'] as Color,
                            size: 22,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          item['title'] as String,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          item['value'] as String,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showReminderDialog(BuildContext context, Plant plant) {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set Care Reminder',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Choose when to be reminded to care for your ${plant.name}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.dark(
                                  primary: Color(0xFF4A7C59),
                                  surface: Color(0xFF1A1A1A),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (date != null) {
                          selectedDate = date;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2D5A3D),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Pick Date'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.dark(
                                  primary: Color(0xFF4A7C59),
                                  surface: Color(0xFF1A1A1A),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (time != null) {
                          selectedTime = time;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2D5A3D),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Pick Time'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final provider = Provider.of<PlantProvider>(
                          context,
                          listen: false,
                        );
                        Reminder reminder = Reminder(
                          plantId: plant.id!,
                          title: 'Water ${plant.name}',
                          description: 'Time to water your plant',
                          scheduledTime: DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          ),
                        );
                        provider.addReminder(reminder);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Reminder set!',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Color(0xFF4A7C59),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4A7C59),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Set Reminder',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
