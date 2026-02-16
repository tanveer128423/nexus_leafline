import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../utils/design_system.dart';

class PremiumCareInstructions extends StatefulWidget {
  final Plant plant;

  const PremiumCareInstructions({super.key, required this.plant});

  @override
  State<PremiumCareInstructions> createState() =>
      _PremiumCareInstructionsState();
}

class _PremiumCareInstructionsState extends State<PremiumCareInstructions> {
  bool _showWhyMatters = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Text(
              'Care Instructions',
              style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
            ),
          ),

          // Icon-based care requirements
          _buildCareRequirement(
            icon: Icons.water_drop,
            color: AppColors.statusInfo,
            title: 'Watering',
            value: widget.plant.watering,
            tip: 'Check soil moisture before watering',
          ),

          const Divider(height: 1),

          _buildCareRequirement(
            icon: Icons.wb_sunny,
            color: AppColors.statusWarning,
            title: 'Sunlight',
            value: widget.plant.sunlight,
            tip: 'Place near appropriate light source',
          ),

          const Divider(height: 1),

          _buildCareRequirement(
            icon: Icons.grass,
            color: AppColors.earthyBrown,
            title: 'Soil',
            value: widget.plant.soil,
            tip: 'Ensure proper drainage',
          ),

          if (widget.plant.careInstructions.isNotEmpty) ...[
            const Divider(height: 1),
            _buildDetailedInstructions(),
          ],

          // Collapsible "Why this matters" section
          _buildWhyMattersSection(),
        ],
      ),
    );
  }

  Widget _buildCareRequirement({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String tip,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: color, size: 24),
          ),

          const SizedBox(width: AppSpacing.lg),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Tooltip icon
          Tooltip(
            message: tip,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            textStyle: AppTypography.bodySmall.copyWith(color: Colors.white),
            child: Icon(
              Icons.info_outline,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedInstructions() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Detailed Care Steps',
                style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ...widget.plant.careInstructions.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: AppTypography.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildWhyMattersSection() {
    return Column(
      children: [
        const Divider(height: 1),
        InkWell(
          onTap: () {
            setState(() {
              _showWhyMatters = !_showWhyMatters;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 20,
                  color: AppColors.accentAmber,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Why this matters',
                    style: AppTypography.label.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _showWhyMatters ? 0.5 : 0,
                  duration: AppAnimations.normal,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: AppAnimations.normal,
          curve: AppAnimations.defaultCurve,
          child: _showWhyMatters
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    0,
                    AppSpacing.xl,
                    AppSpacing.xl,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.veryLightSage,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Text(
                      'Proper care ensures your ${widget.plant.name} thrives and maintains its health. Following these guidelines helps prevent common issues like overwatering, insufficient light, or poor soil drainage, which are the leading causes of plant stress.',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
