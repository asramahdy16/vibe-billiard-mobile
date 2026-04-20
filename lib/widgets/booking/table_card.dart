import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/table_model.dart';
import '../common/glass_container.dart';



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
      child: GlassContainer(
        opacity: isSelected ? 0.3 : (isAvailable ? 0.05 : 0.01),
        border: Border.all(
          color: isSelected 
              ? AppColors.primaryContainer 
              : (isAvailable ? Colors.white.withOpacity(0.1) : Colors.transparent),
          width: isSelected ? 2 : 1,
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
