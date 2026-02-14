import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';
import '../models/plant.dart';
import '../models/category.dart';
import '../providers/plant_provider.dart';
import '../widgets/plant_card.dart';
import 'plant_detail_screen.dart';
import 'search_screen.dart';
import 'add_plant_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    Future.delayed(Duration(milliseconds: 200), () {
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plantProvider = Provider.of<PlantProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Background gradient layers
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

          // Floating geometric shapes
          Positioned(
            top: size.height * 0.1,
            right: size.width * 0.1,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFF2D5A3D).withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            bottom: size.height * 0.2,
            left: size.width * 0.05,
            child: Transform.rotate(
              angle: pi / 6,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF4A7C59).withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: CustomScrollView(
                slivers: [
                  // Custom header with search
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      child: Row(
                        children: [
                          // Menu button with custom design
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF2D5A3D), Color(0xFF4A7C59)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF2D5A3D).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer(),
                            ),
                          ),
                          SizedBox(width: 16),

                          // Title with custom typography
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'NEXUS',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                    shadows: [
                                      Shadow(
                                        color: Color(
                                          0xFF4A7C59,
                                        ).withOpacity(0.5),
                                        blurRadius: 10,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'LEAF LINE',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xFF4A7C59),
                                    letterSpacing: 3,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Search button with morphing effect
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                              border: Border.all(
                                color: Color(0xFF4A7C59).withOpacity(0.3),
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => SearchScreen(),
                                    transitionsBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          child,
                                        ) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Hero section with featured plant
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(24, 32, 24, 0),
                      child: Stack(
                        children: [
                          // Main card background with refined styling
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF2D5A3D),
                                  Color(0xFF1F4530),
                                  Color(0xFF0F2318),
                                ],
                                stops: [0.0, 0.5, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF2D5A3D).withOpacity(0.4),
                                  blurRadius: 32,
                                  offset: Offset(0, 12),
                                  spreadRadius: -4,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Stack(
                                children: [
                                  // Subtle pattern overlay
                                  Positioned.fill(
                                    child: Opacity(
                                      opacity: 0.03,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PHBhdHRlcm4gaWQ9ImdyaWQiIHdpZHRoPSI2MCIgaGVpZ2h0PSI2MCIgcGF0dGVyblVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHBhdGggZD0iTSAxMCAwIEwgMCAwIDAgMTAiIGZpbGw9Im5vbmUiIHN0cm9rZT0id2hpdGUiIHN0cm9rZS13aWR0aD0iMSIvPjwvcGF0dGVybj48L2RlZnM+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0idXJsKCNncmlkKSIvPjwvc3ZnPg==',
                                            ),
                                            repeat: ImageRepeat.repeat,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Gradient mesh overlay for depth
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
                                            Color(0xFF4A7C59).withOpacity(0.2),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Content
                                  Padding(
                                    padding: EdgeInsets.all(36),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Badge with refined design
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 7,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.15,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 6,
                                                    height: 6,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xFF7FFF7F),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Color(
                                                            0xFF7FFF7F,
                                                          ).withOpacity(0.6),
                                                          blurRadius: 8,
                                                          spreadRadius: 2,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'FEATURED COLLECTION',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.95),
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: 1.2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 28),

                                        // Main heading with refined typography
                                        Text(
                                          plantProvider.plants.isNotEmpty
                                              ? plantProvider.plants[0].name
                                              : 'Monstera',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 42,
                                            fontWeight: FontWeight.w800,
                                            height: 1.1,
                                            letterSpacing: -1,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(
                                                  0.3,
                                                ),
                                                blurRadius: 20,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(height: 16),

                                        // Subtitle with better hierarchy
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth: 320,
                                          ),
                                          child: Text(
                                            'Expert care guides and personalized reminders to help your plants thrive',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.75,
                                              ),
                                              fontSize: 15,
                                              height: 1.6,
                                              letterSpacing: 0.2,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 32),

                                        // Quick stats row for credibility
                                        Row(
                                          children: [
                                            _buildStatItem(
                                              '${plantProvider.plants.length}+',
                                              'Plants',
                                            ),
                                            SizedBox(width: 32),
                                            _buildStatItem('50+', 'Guides'),
                                            SizedBox(width: 32),
                                            _buildStatItem('4.9★', 'Rating'),
                                          ],
                                        ),

                                        SizedBox(height: 36),

                                        // CTAs with primary + secondary pattern
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                height: 54,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.white,
                                                      Color(0xFFF5F5F5),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.15),
                                                      blurRadius: 16,
                                                      offset: Offset(0, 6),
                                                    ),
                                                  ],
                                                ),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    onTap: () {
                                                      if (plantProvider
                                                          .plants
                                                          .isNotEmpty) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                PlantDetailScreen(
                                                                  plant: plantProvider
                                                                      .plants[0],
                                                                ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'View Details',
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xFF1F4530,
                                                              ),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              letterSpacing:
                                                                  0.3,
                                                            ),
                                                          ),
                                                          SizedBox(width: 8),
                                                          Icon(
                                                            Icons
                                                                .arrow_forward_rounded,
                                                            color: Color(
                                                              0xFF1F4530,
                                                            ),
                                                            size: 20,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Container(
                                              width: 54,
                                              height: 54,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.2),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  onTap: () {
                                                    // Share or bookmark action
                                                  },
                                                  child: Icon(
                                                    Icons.bookmark_border,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Floating plant icon with refined styling
                          Positioned(
                            top: 24,
                            right: 24,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.15),
                                    Colors.white.withOpacity(0.05),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.15),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.spa_rounded,
                                color: Colors.white.withOpacity(0.9),
                                size: 36,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Categories section with asymmetric layout
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EXPLORE',
                            style: TextStyle(
                              color: Color(0xFF4A7C59),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Plant Categories',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Categories in a creative layout
                  SliverToBoxAdapter(
                    child: Container(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        itemCount: plantProvider.categories.length,
                        itemBuilder: (context, index) {
                          final category = plantProvider.categories[index];
                          return Container(
                            width: 160,
                            margin: EdgeInsets.only(right: 16),
                            child: _buildCategoryCard(context, category, index),
                          );
                        },
                      ),
                    ),
                  ),

                  // Recent plants section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                      child: Row(
                        children: [
                          Text(
                            'RECENT',
                            style: TextStyle(
                              color: Color(0xFF4A7C59),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF4A7C59).withOpacity(0.5),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Plants in a staggered grid
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final plant = plantProvider
                            .plants[index % plantProvider.plants.length];
                        return _buildPlantCard(context, plant, index);
                      }, childCount: min(6, plantProvider.plants.length)),
                    ),
                  ),

                  // Bottom spacing
                  SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF4A7C59), Color(0xFF2D5A3D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF4A7C59).withOpacity(0.5),
              blurRadius: 20,
              offset: Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    AddPlantScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 0.1),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
              ),
            );
          },
          child: Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    Category category,
    int index,
  ) {
    final colors = [
      [Color(0xFF2D5A3D), Color(0xFF4A7C59)],
      [Color(0xFF5A4A3D), Color(0xFF7C6B59)],
      [Color(0xFF3D4A5A), Color(0xFF597C8C)],
      [Color(0xFF5A3D4A), Color(0xFF8C597C)],
      [Color(0xFF4A5A3D), Color(0xFF7C8C59)],
    ];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(initialCategoryId: category.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20 + index * 5),
            bottomRight: Radius.circular(20 + index * 5),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors[index % colors.length],
          ),
          boxShadow: [
            BoxShadow(
              color: colors[index % colors.length][0].withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: Text(
                category.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantCard(BuildContext context, Plant plant, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailScreen(plant: plant),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(0xFF1A1A1A),
          border: Border.all(
            color: Color(0xFF4A7C59).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Hero(
                tag: 'plant_${plant.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: plant.imageUrl,
                    cacheKey: plant.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Color(0xFF2D5A3D).withOpacity(0.1),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF4A7C59),
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Color(0xFF2D5A3D).withOpacity(0.1),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          color: Color(0xFF4A7C59).withOpacity(0.5),
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      plant.scientificName,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          color: Color(0xFF4A7C59),
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Care',
                          style: TextStyle(
                            color: Color(0xFF4A7C59),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
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
