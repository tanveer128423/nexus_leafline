import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/plant_provider.dart';
import '../utils/design_system.dart';
import '../widgets/premium_plant_card.dart';
import '../screens/add_plant_screen.dart';
import '../screens/plant_detail_screen.dart';

class PremiumDashboard extends StatefulWidget {
  const PremiumDashboard({super.key});

  @override
  State<PremiumDashboard> createState() => _PremiumDashboardState();
}

class _PremiumDashboardState extends State<PremiumDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plantProvider = Provider.of<PlantProvider>(context);
    final plants = plantProvider.plants;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Premium App Bar
              _buildAppBar(),

              // Stats Cards
              _buildStatsSection(plants.length),

              // Tab Bar
              _buildTabBar(),

              // Tab Content
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMyPlantsTab(plants),
                    _buildUpcomingTasksTab(),
                    _buildCompletedTasksTab(),
                  ],
                ),
              ),
            ],
          ),

          // Floating Action Button
          _buildFAB(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primaryGreen,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nexus Leafline',
              style: AppTypography.h2.copyWith(color: Colors.white),
            ),
            Text(
              'Your Plant Care Dashboard',
              style: AppTypography.caption.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        titlePadding: const EdgeInsets.only(
          left: AppSpacing.xl,
          bottom: AppSpacing.lg,
        ),
      ),
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
    );
  }

  Widget _buildStatsSection(int plantCount) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.primaryGreen,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.xxxl,
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Plants',
                '$plantCount',
                Icons.eco,
                AppColors.statusGood,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: _buildStatCard(
                'Need Care',
                '3',
                Icons.water_drop,
                AppColors.statusWarning,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: _buildStatCard(
                'Healthy',
                '${plantCount - 3}',
                Icons.check_circle,
                AppColors.statusGood,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.h1.copyWith(color: AppColors.textPrimary),
          ),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: AppShadows.small,
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: AppTypography.label,
          tabs: const [
            Tab(text: 'My Plants'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
    );
  }

  Widget _buildMyPlantsTab(List plants) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.xl),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.lg,
        crossAxisSpacing: AppSpacing.lg,
        childAspectRatio: 0.75,
      ),
      itemCount: plants.length,
      itemBuilder: (context, index) {
        final plant = plants[index];
        return PremiumPlantCard(
          plant: plant,
          index: index,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlantDetailScreen(plant: plant),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUpcomingTasksTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        _buildTaskCard(
          'Water Spider Plant',
          'Due in 2 hours',
          AppColors.statusWarning,
          false,
        ),
        _buildTaskCard(
          'Fertilize Peace Lily',
          'Due tomorrow',
          AppColors.statusInfo,
          false,
        ),
        _buildTaskCard(
          'Prune Snake Plant',
          'Due in 3 days',
          AppColors.statusGood,
          false,
        ),
      ],
    );
  }

  Widget _buildCompletedTasksTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        _buildTaskCard(
          'Watered Aloe Vera',
          'Completed today',
          AppColors.statusGood,
          true,
        ),
        _buildTaskCard(
          'Repotted Basil',
          'Completed yesterday',
          AppColors.statusGood,
          true,
        ),
      ],
    );
  }

  Widget _buildTaskCard(
    String title,
    String subtitle,
    Color color,
    bool completed,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.small,
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              completed ? Icons.check_circle : Icons.schedule,
              color: color,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    decoration: completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (!completed)
            Icon(Icons.chevron_right, color: AppColors.textTertiary),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Positioned(
      right: AppSpacing.xl,
      bottom: AppSpacing.xl,
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddPlantScreen()),
          );
        },
        backgroundColor: AppColors.primaryGreen,
        elevation: 8,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Plant',
          style: AppTypography.label.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
