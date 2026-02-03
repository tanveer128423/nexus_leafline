import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../models/plant.dart';
import '../models/reminder.dart';
import '../providers/plant_provider.dart';

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
                      // Plant image placeholder with parallax
                      Positioned.fill(
                        top: -_scrollOffset * 0.8,
                        child: Container(
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

                      // Plant info overlay
                      Positioned(
                        bottom: 40,
                        left: 24,
                        right: 24,
                        child: FadeTransition(
                          opacity: _heroAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'PLANT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                currentPlant.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                currentPlant.scientificName,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
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
                        // Care information
                        Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CARE GUIDE',
                                style: TextStyle(
                                  color: Color(0xFF4A7C59),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Essential care information for your ${currentPlant.name}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Care grid
                        _buildCareGrid(),

                        // Description
                        Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ABOUT',
                                style: TextStyle(
                                  color: Color(0xFF4A7C59),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                currentPlant.description ??
                                    'This beautiful plant brings life and color to any space. With proper care, it will thrive and become a stunning addition to your plant collection.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Set reminder button
                        Padding(
                          padding: EdgeInsets.all(24),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _showReminderDialog(context, currentPlant),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF4A7C59),
                                padding: EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Set Care Reminder',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
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

  Widget _buildCareGrid() {
    final careItems = [
      {'icon': Icons.water_drop, 'title': 'Watering', 'value': 'Every 7 days'},
      {'icon': Icons.wb_sunny, 'title': 'Light', 'value': 'Bright indirect'},
      {'icon': Icons.thermostat, 'title': 'Temperature', 'value': '18-24°C'},
      {'icon': Icons.grass, 'title': 'Soil', 'value': 'Well-draining'},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
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
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(0xFF4A7C59).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF4A7C59).withOpacity(0.2),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: Color(0xFF4A7C59),
                            size: 24,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          item['title'] as String,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          item['value'] as String,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
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
