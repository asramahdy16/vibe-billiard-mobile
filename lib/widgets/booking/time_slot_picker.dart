import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';

class TimeSlotPicker extends StatelessWidget {
  final DateTime? selectedDate;
  final String? startTime;
  final int duration;
  final Function(DateTime) onDateSelected;
  final Function(String, String) onTimeSelected;
  final Function(int) onDurationChanged;

  const TimeSlotPicker({
    super.key,
    this.selectedDate,
    this.startTime,
    required this.duration,
    required this.onDateSelected,
    required this.onTimeSelected,
    required this.onDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Generate dates (today + 6 days)
    final now = DateTime.now();
    final dates = List.generate(7, (i) => now.add(Duration(days: i)));
    
    // Default selected date to today if null
    final activeDate = selectedDate ?? now;

    // Generate hours (08:00 - 23:00)
    final hours = List.generate(16, (i) => i + 8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Tanggal',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected = date.year == activeDate.year &&
                  date.month == activeDate.month &&
                  date.day == activeDate.day;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => onDateSelected(date),
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryContainer
                          : AppColors.surfaceContHigh,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : AppColors.outlineVariant.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Formatters.dayNameShort(date),
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? Colors.white
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Pilih Waktu',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: hours.length,
          itemBuilder: (context, index) {
            final hour = hours[index];
            final timeStr = Formatters.timeFromHour(hour);
            final isSelected = startTime == timeStr;
            
            // Check if time is in the past (only for today)
            final isToday = activeDate.year == now.year &&
                  activeDate.month == now.month &&
                  activeDate.day == now.day;
            final isPast = isToday && hour <= now.hour;

            return GestureDetector(
              onTap: isPast
                  ? null
                  : () {
                      final endTime = Formatters.timeFromHour(hour + duration);
                      onTimeSelected(timeStr, endTime);
                    },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryContainer
                      : isPast
                          ? AppColors.surfaceContLow
                          : AppColors.surfaceContHigh,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : AppColors.outlineVariant.withOpacity(0.2),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  timeStr,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Colors.white
                        : isPast
                            ? AppColors.onSurfaceVariant.withOpacity(0.5)
                            : AppColors.onSurface,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Durasi Bermain (Jam)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: duration > 1 ? () => onDurationChanged(duration - 1) : null,
                icon: const Icon(Icons.remove),
                color: AppColors.primary,
              ),
              Text(
                '$duration Jam',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: duration < 5 ? () => onDurationChanged(duration + 1) : null,
                icon: const Icon(Icons.add),
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
