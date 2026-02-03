import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../models/plant.dart';
import '../models/category.dart';
import '../providers/plant_provider.dart';
import '../widgets/plant_card.dart';
import 'plant_detail_screen.dart';

class SearchScreen extends StatefulWidget {
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
    _filteredPlants = plantProvider.plants;

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
                // Custom header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'DISCOVER',
                        style: TextStyle(
                          color: Color(0xFF4A7C59),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Search bar
                FadeTransition(
                  opacity: _searchAnimation,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(24, 32, 24, 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: Color(0xFF4A7C59).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search plants, species, care tips...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF4A7C59),
                          size: 24,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                      ),
                      onChanged: _filterPlants,
                    ),
                  ),
                ),

                // Filter chips
                Container(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      // All filter
                      Container(
                        margin: EdgeInsets.only(right: 12),
                        child: FilterChip(
                          label: Text(
                            'All',
                            style: TextStyle(
                              color: _selectedCategoryId == null
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          selected: _selectedCategoryId == null,
                          onSelected: (selected) => _filterByCategory(null),
                          backgroundColor: Colors.white.withOpacity(0.1),
                          selectedColor: Color(0xFF4A7C59),
                          checkmarkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: _selectedCategoryId == null
                                  ? Color(0xFF4A7C59)
                                  : Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                      ),

                      // Category filters
                      ...plantProvider.categories.map((category) {
                        final isSelected = _selectedCategoryId == category.id;
                        return Container(
                          margin: EdgeInsets.only(right: 12),
                          child: FilterChip(
                            label: Text(
                              category.name,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) => _filterByCategory(
                              selected ? category.id : null,
                            ),
                            backgroundColor: Colors.white.withOpacity(0.1),
                            selectedColor: Color(0xFF4A7C59),
                            checkmarkColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected
                                    ? Color(0xFF4A7C59)
                                    : Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
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
                                      : 'Start searching...',
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
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            16,
                                                          ),
                                                        ),
                                                    color: Color(
                                                      0xFF2D5A3D,
                                                    ).withOpacity(0.1),
                                                  ),
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
