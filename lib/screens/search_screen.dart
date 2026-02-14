import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';
import '../models/plant.dart';
import '../models/category.dart';
import '../providers/plant_provider.dart';
import '../widgets/plant_card.dart';
import 'plant_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final int? initialCategoryId;

  const SearchScreen({super.key, this.initialCategoryId});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  List<Plant> _filteredPlants = [];
  int? _selectedCategoryId;
  late AnimationController _searchControllerAnim;
  late Animation<double> _searchAnimation;
  late AnimationController _resultsController;
  late Animation<double> _resultsAnimation;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    final plantProvider = Provider.of<PlantProvider>(context, listen: false);
    _selectedCategoryId = widget.initialCategoryId;
    _filteredPlants = _selectedCategoryId != null
        ? plantProvider.plants
              .where((plant) => plant.categoryId == _selectedCategoryId)
              .toList()
        : plantProvider.plants;

    _searchControllerAnim = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _searchControllerAnim,
        curve: Curves.easeOutCubic,
      ),
    );

    _resultsController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _resultsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resultsController, curve: Curves.easeOut),
    );

    _searchControllerAnim.forward();
    if (_filteredPlants.isNotEmpty) {
      _resultsController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchControllerAnim.dispose();
    _resultsController.dispose();
    super.dispose();
  }

  void _filterPlants(String query) {
    final plantProvider = Provider.of<PlantProvider>(context, listen: false);
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredPlants = _selectedCategoryId != null
            ? plantProvider.plants
                  .where((plant) => plant.categoryId == _selectedCategoryId)
                  .toList()
            : plantProvider.plants;
      } else {
        _filteredPlants = plantProvider.plants.where((plant) {
          final matchesQuery =
              plant.name.toLowerCase().contains(query.toLowerCase()) ||
              plant.scientificName.toLowerCase().contains(query.toLowerCase());
          final matchesCategory =
              _selectedCategoryId == null ||
              plant.categoryId == _selectedCategoryId;
          return matchesQuery && matchesCategory;
        }).toList();
      }
    });

    if (_filteredPlants.isNotEmpty && !_resultsController.isAnimating) {
      _resultsController.forward(from: 0.0);
    }
  }

  void _filterByCategory(int? categoryId) {
    final plantProvider = Provider.of<PlantProvider>(context, listen: false);
    setState(() {
      _selectedCategoryId = categoryId;
      _filterPlants(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final plantProvider = Provider.of<PlantProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Background with floating particles
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
                ),
              ),
            ),
          ),

          // Floating particles
          ...List.generate(20, (index) {
            final random = Random(index);
            return Positioned(
              top: random.nextDouble() * size.height,
              left: random.nextDouble() * size.width,
              child: AnimatedBuilder(
                animation: _searchAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _searchAnimation.value * 0.1,
                    child: Container(
                      width: 4 + random.nextDouble() * 8,
                      height: 4 + random.nextDouble() * 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF4A7C59).withOpacity(0.3),
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'DISCOVER',
                            style: TextStyle(
                              color: Color(0xFF4A7C59),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          'Find your next plant',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Search bar
                FadeTransition(
                  opacity: _searchAnimation,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(24, 20, 24, 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.04),
                        ],
                      ),
                      border: Border.all(
                        color: Color(0xFF4A7C59).withOpacity(0.35),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search plants, species, care tips...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 15,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF4A7C59),
                          size: 22,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 18,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _filterPlants('');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                      ),
                      onChanged: _filterPlants,
                    ),
                  ),
                ),

                // Results meta
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Row(
                    children: [
                      Text(
                        _selectedCategoryId == null
                            ? 'All plants'
                            : (plantProvider.categories
                                  .firstWhere(
                                    (c) => c.id == _selectedCategoryId,
                                    orElse: () => Category(
                                      id: -1,
                                      name: 'Selected',
                                      icon: '',
                                      description: '',
                                    ),
                                  )
                                  .name),
                        style: TextStyle(
                          color: const Color.fromARGB(
                            255,
                            255,
                            255,
                            255,
                          ).withOpacity(0.85),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '${_filteredPlants.length} results',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Filter chips
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilterChip(
                        label: Text(
                          'All',
                          style: TextStyle(
                            color: _selectedCategoryId == null
                                ? Colors.white
                                : Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        selected: _selectedCategoryId == null,
                        onSelected: (selected) => _filterByCategory(null),
                        backgroundColor: _selectedCategoryId == null
                            ? Color(0xFF4A7C59)
                            : Colors.white.withOpacity(0.85),
                        selectedColor: Color(0xFF4A7C59),
                        checkmarkColor: Colors.white,
                        showCheckmark: false,
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: _selectedCategoryId == null
                                ? Color(0xFF4A7C59)
                                : Colors.white.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                      ...plantProvider.categories.map((category) {
                        final isSelected = _selectedCategoryId == category.id;
                        return FilterChip(
                          label: Text(
                            category.name,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) =>
                              _filterByCategory(selected ? category.id : null),
                          backgroundColor: isSelected
                              ? Color(0xFF4A7C59)
                              : Colors.white.withOpacity(0.85),
                          selectedColor: Color(0xFF4A7C59),
                          checkmarkColor: Colors.white,
                          showCheckmark: false,
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: isSelected
                                  ? Color(0xFF4A7C59)
                                  : Colors.white.withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),

                // Results
                Expanded(
                  child: FadeTransition(
                    opacity: _resultsAnimation,
                    child: _filteredPlants.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  color: Colors.white.withOpacity(0.3),
                                  size: 64,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  _isSearching
                                      ? 'No plants found'
                                      : (_selectedCategoryId == null
                                            ? 'Start searching...'
                                            : 'No plants in this category'),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.all(24),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.75,
                                ),
                            itemCount: _filteredPlants.length,
                            itemBuilder: (context, index) {
                              final plant = _filteredPlants[index];
                              return AnimatedBuilder(
                                animation: _resultsAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                      0,
                                      50 * (1 - _resultsAnimation.value),
                                    ),
                                    child: Opacity(
                                      opacity: _resultsAnimation.value,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PlantDetailScreen(
                                                    plant: plant,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            color: Color(0xFF1A1A1A),
                                            border: Border.all(
                                              color: Color(
                                                0xFF4A7C59,
                                              ).withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Hero(
                                                  tag: 'plant_${plant.id}',
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            16,
                                                          ),
                                                        ),
                                                    child: CachedNetworkImage(
                                                      imageUrl: plant.imageUrl,
                                                      cacheKey: plant.imageUrl,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (
                                                            context,
                                                            url,
                                                          ) => Container(
                                                            color: Color(
                                                              0xFF2D5A3D,
                                                            ).withOpacity(0.1),
                                                            child: Center(
                                                              child: CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                      Color
                                                                    >(
                                                                      Color(
                                                                        0xFF4A7C59,
                                                                      ),
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                      errorWidget:
                                                          (
                                                            context,
                                                            url,
                                                            error,
                                                          ) => Container(
                                                            color: Color(
                                                              0xFF2D5A3D,
                                                            ).withOpacity(0.1),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.image,
                                                                color: Color(
                                                                  0xFF4A7C59,
                                                                ).withOpacity(0.5),
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
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        plant.name,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        plant.scientificName,
                                                        style: TextStyle(
                                                          color: Colors.white
                                                              .withOpacity(0.6),
                                                          fontSize: 12,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Spacer(),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.visibility,
                                                            color: Color(
                                                              0xFF4A7C59,
                                                            ),
                                                            size: 14,
                                                          ),
                                                          SizedBox(width: 4),
                                                          Text(
                                                            'View',
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xFF4A7C59,
                                                              ),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
