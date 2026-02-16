import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/plant.dart';
import '../utils/design_system.dart';

class PremiumPlantCard extends StatefulWidget {
  final Plant plant;
  final VoidCallback onTap;
  final int index;

  const PremiumPlantCard({
    super.key,
    required this.plant,
    required this.onTap,
    this.index = 0,
  });

  @override
  State<PremiumPlantCard> createState() => _PremiumPlantCardState();
}

class _PremiumPlantCardState extends State<PremiumPlantCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.entrance),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.entrance),
    );

    // Staggered animation based on index
    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getPlantStatus() {
    // Logic to determine plant status based on care requirements
    // For now, return a sample status
    final statuses = ['Healthy', 'Water Today', 'Needs Sunlight', 'Perfect'];
    return statuses[widget.plant.id! % statuses.length];
  }

  Color _getStatusColor() {
    final status = _getPlantStatus();
    switch (status) {
      case 'Healthy':
      case 'Perfect':
        return AppColors.statusGood;
      case 'Water Today':
        return AppColors.statusWarning;
      case 'Needs Sunlight':
        return AppColors.statusInfo;
      default:
        return AppColors.statusGood;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: AppAnimations.normal,
            curve: AppAnimations.defaultCurve,
            transform: Matrix4.identity()
              ..translate(0.0, _isHovered ? -8.0 : 0.0),
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: _isHovered ? AppShadows.hover : AppShadows.medium,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plant Image
                    _buildPlantImage(),

                    // Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status Badge
                            _buildStatusBadge(),

                            const SizedBox(height: AppSpacing.sm),

                            // Plant Name
                            Text(
                              widget.plant.name,
                              style: AppTypography.h3.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: AppSpacing.xs),

                            // Scientific Name
                            Text(
                              widget.plant.scientificName,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const Spacer(),

                            // Care Info Row
                            _buildCareInfoRow(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlantImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppRadius.md),
        topRight: Radius.circular(AppRadius.md),
      ),
      child: AspectRatio(
        aspectRatio: 1.2,
        child: CachedNetworkImage(
          imageUrl: widget.plant.imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.veryLightSage,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryGreen,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.veryLightSage,
            child: const Icon(Icons.eco, size: 48, color: AppColors.lightSage),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final status = _getPlantStatus();
    final color = _getStatusColor();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            status,
            style: AppTypography.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareInfoRow() {
    return Row(
      children: [
        _buildCareIcon(Icons.water_drop, AppColors.statusInfo),
        const SizedBox(width: AppSpacing.sm),
        _buildCareIcon(Icons.wb_sunny, AppColors.statusWarning),
        const SizedBox(width: AppSpacing.sm),
        _buildCareIcon(Icons.grass, AppColors.earthyBrown),
      ],
    );
  }

  Widget _buildCareIcon(IconData icon, Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }
}
