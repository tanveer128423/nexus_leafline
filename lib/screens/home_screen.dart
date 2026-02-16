import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'dart:ui';
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
    final isCompact = size.width < 380;
    final isNarrow = size.width < 520;
    final horizontalPadding = size.width < 420 ? 18.0 : 24.0;
    final heroTopPadding = size.width < 420 ? 28.0 : 40.0;
    final heroInnerPadding = size.width < 420 ? 24.0 : 48.0;
    final sectionTopPadding = size.width < 420 ? 48.0 : 64.0;
    final featuredPlant = plantProvider.plants.isNotEmpty
        ? plantProvider.plants[0]
        : null;

    return Container(
      color: const Color(0xFF0A0A0A),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF161B18),
                    Color(0xFF0C0F0E),
                    Color(0xFF050505),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        20,
                        horizontalPadding,
                        0,
                      ),
                      child: Row(
                        children: [
                          Builder(
                            builder: (context) {
                              return Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF2D5A3D),
                                      Color(0xFF4A7C59),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF2D5A3D,
                                      ).withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'NEXUS',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                  ),
                                ),
                                Text(
                                  'LEAF LINE',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF4A7C59),
                                    letterSpacing: 3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2D5A3D), Color(0xFF4A7C59)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF2D5A3D,
                                  ).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        heroTopPadding,
                        horizontalPadding,
                        0,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 720;

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF1A1A1A), Color(0xFF0F1513)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF2D5A3D,
                                  ).withOpacity(0.15),
                                  blurRadius: 30,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(heroInnerPadding),
                              child: isWide
                                  ? Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: _buildHeroContent(
                                            context,
                                            featuredPlant,
                                            plantProvider.plants.length,
                                            compact: isCompact,
                                            narrow: isNarrow,
                                          ),
                                        ),
                                        const SizedBox(width: 48),
                                        Expanded(
                                          flex: 2,
                                          child: _buildFeaturedImage(
                                            featuredPlant,
                                            isWide,
                                            compact: isCompact,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildHeroContent(
                                          context,
                                          featuredPlant,
                                          plantProvider.plants.length,
                                          compact: isCompact,
                                          narrow: isNarrow,
                                        ),
                                        SizedBox(height: isCompact ? 28 : 40),
                                        _buildFeaturedImage(
                                          featuredPlant,
                                          isWide,
                                          compact: isCompact,
                                        ),
                                      ],
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        sectionTopPadding,
                        horizontalPadding,
                        24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'EXPLORE',
                            style: TextStyle(
                              color: Color(0xFF4A7C59),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Plant Categories',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        itemCount: plantProvider.categories.length,
                        itemBuilder: (context, index) {
                          final category = plantProvider.categories[index];
                          return Container(
                            width: 160,
                            margin: const EdgeInsets.only(right: 16),
                            child: _buildCategoryCard(context, category, index),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        sectionTopPadding,
                        horizontalPadding,
                        24,
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'RECENT',
                            style: TextStyle(
                              color: Color(0xFF4A7C59),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0),
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: size.width >= 1200
                            ? 4
                            : size.width >= 768
                            ? 3
                            : 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: size.width >= 768 ? 0.75 : 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final plant = plantProvider
                            .plants[index % plantProvider.plants.length];
                        return _buildPlantCard(context, plant, index);
                      }, childCount: min(6, plantProvider.plants.length)),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ),
          Positioned(
            right: 24,
            bottom: 24,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4A7C59),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A7C59).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
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
                                  begin: const Offset(0, 0.1),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                    ),
                  );
                },
                child: const Icon(Icons.add, size: 32, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroContent(
    BuildContext context,
    Plant? plant,
    int plantCount, {
    required bool compact,
    required bool narrow,
  }) {
    final name = plant?.name ?? 'Monstera Deliciosa';
    final scientific = plant?.scientificName ?? 'Monstera deliciosa';
    final watering = plant?.watering ?? 'Moderate';
    final sunlight = plant?.sunlight ?? 'Bright';
    final soil = plant?.soil ?? 'Well-drained';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GlassBadge(label: 'THIS WEEK\'S FEATURE', compact: compact),
        SizedBox(height: compact ? 18 : 24),
        Text(
          name,
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: compact ? 36 : 48,
            fontWeight: FontWeight.w700,
            height: 1.0,
            letterSpacing: compact ? -0.6 : -1.0,
          ),
        ),
        SizedBox(height: compact ? 6 : 10),
        Text(
          scientific,
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white.withOpacity(0.6),
            fontSize: compact ? 13 : 15,
            fontStyle: FontStyle.italic,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: compact ? 16 : 24),
        Text(
          'Craft a thriving indoor oasis with curated care guides and smart reminders tailored to your plants.',
          style: GoogleFonts.dmSans(
            color: Colors.white.withOpacity(0.7),
            fontSize: compact ? 14 : 16,
            height: compact ? 1.55 : 1.7,
          ),
        ),
        SizedBox(height: compact ? 18 : 28),
        Wrap(
          spacing: compact ? 8 : 12,
          runSpacing: compact ? 8 : 12,
          children: [
            _CareTag(
              icon: Icons.water_drop,
              label: 'Water',
              value: watering,
              compact: compact,
            ),
            _CareTag(
              icon: Icons.wb_sunny,
              label: 'Light',
              value: sunlight,
              compact: compact,
            ),
            _CareTag(
              icon: Icons.grass,
              label: 'Soil',
              value: soil,
              compact: compact,
            ),
          ],
        ),
        SizedBox(height: compact ? 22 : 32),
        _StatsSection(plantCount: plantCount, compact: compact),
        SizedBox(height: compact ? 24 : 36),
        narrow
            ? Column(
                children: [
                  _PrimaryButton(
                    label: 'View Details',
                    height: compact ? 50 : 54,
                    onPressed: plant == null
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlantDetailScreen(plant: plant),
                              ),
                            );
                          },
                  ),
                  const SizedBox(height: 12),
                  _SecondaryButton(
                    label: 'Add Plant',
                    icon: Icons.add_circle_outline,
                    height: compact ? 50 : 54,
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  AddPlantScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.06),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                        ),
                      );
                    },
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _PrimaryButton(
                      label: 'View Details',
                      onPressed: plant == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PlantDetailScreen(plant: plant),
                                ),
                              );
                            },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: _SecondaryButton(
                      label: 'Add Plant',
                      icon: Icons.add_circle_outline,
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    AddPlantScreen(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 0.06),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildFeaturedImage(
    Plant? plant,
    bool isWide, {
    bool compact = false,
  }) {
    final imageUrl = plant?.imageUrl;
    final imageSize = isWide
        ? 280.0
        : compact
        ? 210.0
        : 250.0;

    return SizedBox(
      height: imageSize + 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: const Color(0xFF4A7C59).withOpacity(0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: imageUrl == null
                  ? Container(
                      color: const Color(0xFF161B18),
                      child: const Icon(
                        Icons.local_florist,
                        color: Color(0xFF4A7C59),
                        size: 56,
                      ),
                    )
                  : _buildPlantImage(imageUrl),
            ),
          ),
          Positioned(
            right: -8,
            bottom: 8,
            child: _AnimatedCareScore(score: 92),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        cacheKey: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: const Color(0xFF161B18),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFF4A7C59)),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: const Color(0xFF161B18),
          child: const Icon(
            Icons.local_florist,
            color: Color(0xFF4A7C59),
            size: 48,
          ),
        ),
      );
    }

    final assetPath = imageUrl.replaceFirst('../', '');
    return Image.asset(assetPath, fit: BoxFit.cover);
  }

  Widget _buildCategoryCard(
    BuildContext context,
    Category category,
    int index,
  ) {
    final colors = [
      [const Color(0xFF2D5A3D), const Color(0xFF4A7C59)],
      [const Color(0xFF5A4A3D), const Color(0xFF7C6B59)],
      [const Color(0xFF3D4A5A), const Color(0xFF597C8C)],
      [const Color(0xFF5A3D4A), const Color(0xFF8C597C)],
      [const Color(0xFF4A5A3D), const Color(0xFF7C8C59)],
    ];

    final icons = [
      Icons.home,
      Icons.park,
      Icons.spa,
      Icons.local_florist,
      Icons.eco,
    ];

    return _CategoryCard(
      category: category,
      index: index,
      colors: colors[index % colors.length],
      icon: icons[index % icons.length],
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
          color: const Color(0xFF1A1A1A),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D5A3D).withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
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
                      color: const Color(0xFF161B18),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF4A7C59),
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFF161B18),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          color: Color(0xFF4A7C59),
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
                        fontSize: 13,
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
                        fontSize: 11,
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
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Care',
                          style: TextStyle(
                            color: Color(0xFF4A7C59),
                            fontSize: 11,
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

// ============================================================================
// REUSABLE DARK MODE COMPONENTS
// ============================================================================

/// Premium glassmorphic badge for dark mode
class _GlassBadge extends StatelessWidget {
  final String label;
  final bool compact;

  const _GlassBadge({required this.label, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 16,
            vertical: compact ? 8 : 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4A7C59),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 10 : 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: compact ? 1.1 : 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Care tag pill with icon for dark mode
class _CareTag extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool compact;

  const _CareTag({
    required this.icon,
    required this.label,
    required this.value,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 14,
            vertical: compact ? 8 : 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: compact ? 12 : 14,
                color: const Color(0xFF4A7C59),
              ),
              SizedBox(width: compact ? 6 : 8),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 10 : 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: compact ? 0.6 : 0.8,
                ),
              ),
              SizedBox(width: compact ? 4 : 6),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 11 : 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Premium stats section for dark mode
class _StatsSection extends StatelessWidget {
  final int plantCount;
  final bool compact;

  const _StatsSection({required this.plantCount, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 16 : 24,
            vertical: compact ? 14 : 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                value: '${plantCount}+',
                label: 'Plants',
                compact: compact,
              ),
              Container(
                width: 1,
                height: compact ? 32 : 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0),
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0),
                    ],
                  ),
                ),
              ),
              _StatItem(value: '50+', label: 'Guides', compact: compact),
              Container(
                width: 1,
                height: compact ? 32 : 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0),
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0),
                    ],
                  ),
                ),
              ),
              _StatItem(value: '4.9★', label: 'Rating', compact: compact),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual stat item for dark mode
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final bool compact;

  const _StatItem({
    required this.value,
    required this.label,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 20 : 24,
            fontWeight: FontWeight.w800,
            letterSpacing: compact ? -0.4 : -0.8,
          ),
        ),
        SizedBox(height: compact ? 2 : 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 11 : 13,
            fontWeight: FontWeight.w500,
            letterSpacing: compact ? 0.2 : 0.4,
          ),
        ),
      ],
    );
  }
}

/// Primary button with green accent
class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final double height;

  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.height = 56,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed == null
          ? null
          : (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: widget.onPressed == null
                ? Colors.grey.shade400
                : const Color(0xFF4A7C59),
            boxShadow: _isPressed
                ? []
                : [
                    BoxShadow(
                      color: const Color(0xFF4A7C59).withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: widget.height <= 52 ? 15 : 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary outlined button
class _SecondaryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final double height;

  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.height = 56,
  });

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: _isPressed
                ? Colors.white.withOpacity(0.12)
                : Colors.white.withOpacity(0.08),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: widget.height <= 52 ? 16 : 18,
                color: const Color(0xFF4A7C59),
              ),
              SizedBox(width: widget.height <= 52 ? 6 : 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.height <= 52 ? 14 : 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Premium care score badge for dark mode
class _AnimatedCareScore extends StatelessWidget {
  final int score;

  const _AnimatedCareScore({required this.score});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: score / 100),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A7C59).withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: CircularProgressIndicator(
                          value: value,
                          strokeWidth: 6,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF4A7C59),
                          ),
                        ),
                      ),
                      Text(
                        '${(value * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Care score',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Category card for dark mode with premium styling
class _CategoryCard extends StatefulWidget {
  final Category category;
  final int index;
  final List<Color> colors;
  final IconData icon;

  const _CategoryCard({
    required this.category,
    required this.index,
    required this.colors,
    required this.icon,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SearchScreen(initialCategoryId: widget.category.id),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.colors,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.colors[0].withOpacity(_isHovered ? 0.3 : 0.2),
              blurRadius: _isHovered ? 20 : 12,
              offset: Offset(0, _isHovered ? 12 : 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                widget.icon,
                size: 100,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              right: 60,
              child: Text(
                widget.category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(_isHovered ? 0.3 : 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
