import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/plant.dart';
import '../models/category.dart';
import '../providers/plant_provider.dart';
import 'plant_detail_screen.dart';
import 'search_screen.dart';
import 'add_plant_screen.dart';
import 'plant_identification_screen.dart';
import 'reminders_screen.dart';

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plantProvider = Provider.of<PlantProvider>(context);
    final size = MediaQuery.of(context).size;
    final isCompact = size.width < 380;
    final horizontalPadding = size.width < 900 ? 28.0 : 40.0;
    const maxContentWidth = 1300.0;
    final featuredPlant = plantProvider.plants.isNotEmpty
        ? plantProvider.plants[0]
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F0E),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxContentWidth),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      24,
                      horizontalPadding,
                      0,
                    ),
                    child: _buildTopBar(context),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      28,
                      horizontalPadding,
                      0,
                    ),
                    child: _buildHeroSection(
                      context,
                      featuredPlant,
                      plantProvider.plants.length,
                      compact: isCompact,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 48)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: _buildQuickActionsRow(context),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 52)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: _buildSectionHeader('Popular Plants'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildPopularPlantsList(
                    context,
                    plantProvider.plants,
                    horizontalPadding,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 52)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: _buildSectionHeader('Categories'),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    20,
                    horizontalPadding,
                    40,
                  ),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: size.width < 900 ? 2 : 3,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1.3,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final category = plantProvider.categories[index];
                      return _CategoryTile(category: category, index: index);
                    }, childCount: plantProvider.categories.length),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'NEXUS LEAFLINE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Plant care dashboard',
                style: TextStyle(
                  color: Color(0xFF8FA89B),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeroSection(
    BuildContext context,
    Plant? plant,
    int plantCount, {
    required bool compact,
  }) {
    final name = plant?.name ?? 'Monstera Deliciosa';
    final scientific = plant?.scientificName ?? 'Monstera deliciosa';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        final imageSize = compact ? 320.0 : 360.0;

        return Container(
          padding: EdgeInsets.all(compact ? 24 : 32),
          decoration: BoxDecoration(
            color: const Color(0xFF141A18),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
          ),
          child: isWide
              ? Row(
                  children: [
                    Expanded(
                      child: _HeroTextBlock(
                        name: name,
                        scientific: scientific,
                        plantCount: plantCount,
                        compact: compact,
                        onPrimaryAction: plant == null
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PlantDetailScreen(plant: plant),
                                  ),
                                );
                              },
                      ),
                    ),
                    const SizedBox(width: 32),
                    _HeroImage(plant: plant, size: imageSize),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroTextBlock(
                      name: name,
                      scientific: scientific,
                      plantCount: plantCount,
                      compact: compact,
                      onPrimaryAction: plant == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PlantDetailScreen(plant: plant),
                                ),
                              );
                            },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _HeroImage(plant: plant, size: imageSize),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildQuickActionsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            label: 'Add Plant',
            icon: Icons.add,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddPlantScreen()),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            label: 'Scan',
            icon: Icons.center_focus_strong,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PlantIdentificationScreen()),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            label: 'Reminders',
            icon: Icons.notifications_none,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RemindersScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildPopularPlantsList(
    BuildContext context,
    List<Plant> plants,
    double horizontalPadding,
  ) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          16,
          horizontalPadding,
          0,
        ),
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index == plants.length - 1 ? 0 : 12,
            ),
            child: _PopularPlantCard(plant: plant),
          );
        },
      ),
    );
  }
}
// ============================================================================
// CLEAN DARK MODE COMPONENTS
// ============================================================================

class _HeroTextBlock extends StatelessWidget {
  final String name;
  final String scientific;
  final int plantCount;
  final bool compact;
  final VoidCallback? onPrimaryAction;

  const _HeroTextBlock({
    required this.name,
    required this.scientific,
    required this.plantCount,
    required this.compact,
    required this.onPrimaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 48 : 54,
            fontWeight: FontWeight.w700,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          scientific,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: compact ? 14 : 16,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Smart care guides, reminders, and tracking tailored to your plants.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: compact ? 15 : 16,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        _HeroStatsRow(plantCount: plantCount, compact: compact),
        const SizedBox(height: 14),
        SizedBox(
          height: compact ? 52 : 56,
          child: ElevatedButton(
            onPressed: onPrimaryAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A7C59),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'View Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 16 : 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroStatsRow extends StatelessWidget {
  final int plantCount;
  final bool compact;

  const _HeroStatsRow({required this.plantCount, required this.compact});

  @override
  Widget build(BuildContext context) {
    final valueStyle = TextStyle(
      color: Colors.white,
      fontSize: compact ? 22 : 24,
      fontWeight: FontWeight.w700,
    );
    final labelStyle = TextStyle(
      color: Colors.white.withOpacity(0.6),
      fontSize: compact ? 12 : 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.1,
    );

    return Row(
      children: [
        _HeroStatItem(
          value: '${plantCount}+',
          label: 'PLANTS',
          valueStyle: valueStyle,
          labelStyle: labelStyle,
        ),
        const SizedBox(width: 16),
        _HeroStatItem(
          value: '50+',
          label: 'GUIDES',
          valueStyle: valueStyle,
          labelStyle: labelStyle,
        ),
        const SizedBox(width: 16),
        _HeroStatItem(
          value: '4.9',
          label: 'RATING',
          valueStyle: valueStyle,
          labelStyle: labelStyle,
          trailing: const Icon(
            Icons.star_rounded,
            size: 16,
            color: Color(0xFF4A7C59),
          ),
        ),
      ],
    );
  }
}

class _HeroStatItem extends StatelessWidget {
  final String value;
  final String label;
  final TextStyle valueStyle;
  final TextStyle labelStyle;
  final Widget? trailing;

  const _HeroStatItem({
    required this.value,
    required this.label,
    required this.valueStyle,
    required this.labelStyle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(value, style: valueStyle),
            if (trailing != null) ...[const SizedBox(width: 4), trailing!],
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: labelStyle),
      ],
    );
  }
}

class _HeroImage extends StatelessWidget {
  final Plant? plant;
  final double size;

  const _HeroImage({required this.plant, required this.size});

  @override
  Widget build(BuildContext context) {
    final imageUrl = plant?.imageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: size,
        height: size,
        child: imageUrl == null
            ? Container(
                color: const Color(0xFF1B2120),
                child: const Icon(
                  Icons.local_florist,
                  color: Color(0xFF4A7C59),
                  size: 36,
                ),
              )
            : _buildPlantImage(imageUrl),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF141A18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularPlantCard extends StatelessWidget {
  final Plant plant;

  const _PopularPlantCard({required this.plant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PlantDetailScreen(plant: plant)),
        );
      },
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          color: const Color(0xFF141A18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: _buildPlantImage(plant.imageUrl),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plant.scientificName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final Category category;
  final int index;

  const _CategoryTile({required this.category, required this.index});

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.home,
      Icons.park,
      Icons.spa,
      Icons.local_florist,
      Icons.eco,
      Icons.emoji_nature,
    ];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SearchScreen(initialCategoryId: category.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF141A18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icons[index % icons.length],
                color: const Color(0xFF4A7C59),
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
