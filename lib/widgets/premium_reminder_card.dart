import 'package:flutter/material.dart';
import '../models/reminder.dart';
import '../utils/design_system.dart';
import 'dart:math' as math;

class PremiumReminderCard extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback? onToggle;
  final VoidCallback? onTap;

  const PremiumReminderCard({
    super.key,
    required this.reminder,
    this.onToggle,
    this.onTap,
  });

  Color _getStatusColor() {
    final now = DateTime.now();
    final scheduledTime = reminder.scheduledTime;
    final difference = scheduledTime.difference(now);

    if (difference.isNegative) {
      return AppColors.statusCritical; // Overdue
    } else if (difference.inHours < 24) {
      return AppColors.statusWarning; // Upcoming (within 24 hours)
    } else {
      return AppColors.statusGood; // Good
    }
  }

  String _getStatusText() {
    final now = DateTime.now();
    final scheduledTime = reminder.scheduledTime;
    final difference = scheduledTime.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    } else if (difference.inHours < 1) {
      return 'Due in ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Due in ${difference.inHours} hrs';
    } else {
      return 'Due in ${difference.inDays} days';
    }
  }

  double _getProgress() {
    // Calculate progress based on time until due
    final now = DateTime.now();
    final difference = reminder.scheduledTime.difference(now);

    if (difference.isNegative) return 1.0;

    // Assume a 7-day cycle for progress calculation
    final totalHours = 7 * 24;
    final remainingHours = difference.inHours;
    final progress = (totalHours - remainingHours) / totalHours;

    return math.max(0.0, math.min(1.0, progress));
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final progress = _getProgress();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: AppShadows.small,
          border: Border.all(color: statusColor.withOpacity(0.2), width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              // Circular Progress Indicator
              _buildCircularProgress(statusColor, progress),

              const SizedBox(width: AppSpacing.lg),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            reminder.title,
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _buildStatusBadge(statusColor),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.xs),

                    Text(
                      reminder.description,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    // Progress Bar
                    _buildLinearProgress(statusColor, progress),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.lg),

              // Animated Toggle Switch
              _buildToggleSwitch(statusColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularProgress(Color color, double progress) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 4,
            backgroundColor: color.withOpacity(0.1),
            color: Colors.transparent,
          ),
          // Progress circle
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 4,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          // Center icon
          Icon(
            reminder.type == ReminderType.watering
                ? Icons.water_drop
                : Icons.grass,
            size: 24,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        _getStatusText(),
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLinearProgress(Color color, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: AppTypography.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: AppTypography.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSwitch(Color color) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: AppAnimations.normal,
        width: 48,
        height: 28,
        decoration: BoxDecoration(
          color: reminder.isActive ? color : AppColors.divider,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: AnimatedAlign(
          duration: AppAnimations.normal,
          curve: AppAnimations.defaultCurve,
          alignment: reminder.isActive
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
