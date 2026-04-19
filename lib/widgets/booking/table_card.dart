import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../data/models/table_model.dart';



class TableCard extends StatelessWidget {
  final TableModel table;
  final bool isSelected;
  final VoidCallback onTap;

  const TableCard({
    super.key,
    required this.table,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = table.isAvailable;

    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Container(
        decoration: isSelected
            ? AppDecorations.selectedCard
            : AppDecorations.cardElevated.copyWith(
                color: isAvailable
                    ? AppColors.surfaceContHigh
                    : AppColors.surfaceContLow,
                border: Border.all(
                  color: isAvailable
                      ? AppColors.outlineVariant.withOpacity(0.1)
                      : Colors.transparent,
                ),
              ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.sports_baseball,
                  color: isSelected
                      ? AppColors.primary
                      : isAvailable
                          ? AppColors.onSurface
                          : AppColors.onSurfaceVariant,
                  size: 24,
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primaryContainer,
                    size: 20,
                  ),
              ],
            ),
            const Spacer(),
            Text(
              table.namaMeja,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isAvailable
                    ? AppColors.onSurface
                    : AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: table.tableStatus.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                table.tableStatus.label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: table.tableStatus.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
