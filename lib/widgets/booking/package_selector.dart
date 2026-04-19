import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/package_model.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PackageSelector extends StatelessWidget {
  final PackageModel package;
  final bool isEligible;
  final bool isSelected;
  final int duration;
  final VoidCallback onTap;

  const PackageSelector({
    super.key,
    required this.package,
    required this.isEligible,
    required this.isSelected,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!package.isActive) return const SizedBox.shrink();

    return GestureDetector(
      onTap: isEligible ? onTap : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: isSelected
            ? AppDecorations.selectedCard
            : AppDecorations.cardElevated.copyWith(
                color: isEligible
                    ? AppColors.surfaceContHigh
                    : AppColors.surfaceContLow,
                border: Border.all(
                  color: isEligible
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
                Expanded(
                  child: Text(
                    package.namaPaket,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isEligible
                          ? AppColors.onSurface
                          : AppColors.onSurfaceVariant.withOpacity(0.5),
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primaryContainer,
                    size: 24,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.currencyCompact(
                      package.isReguler ? package.hargaPerJam! : package.hargaFlat!),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isEligible
                        ? (package.isReguler ? AppColors.primary : AppColors.tertiary)
                        : AppColors.onSurfaceVariant.withOpacity(0.5),
                  ),
                ),
                Text(
                  package.isReguler ? ' / jam' : ' / ${package.durasiMinJam} jam',
                  style: TextStyle(
                    fontSize: 12,
                    color: isEligible
                        ? AppColors.onSurfaceVariant
                        : AppColors.onSurfaceVariant.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            if (package.isHemat) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCont,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.info,
                      size: 16,
                      color: AppColors.onSurfaceVariant.withOpacity(0.8),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Berlaku ${package.hariBerlaku == 'mon-fri' ? 'Sen-Jum' : package.hariBerlaku}, pk ${Formatters.time(package.jamMulai ?? '')} - ${Formatters.time(package.jamSelesai ?? '')}',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (!isEligible) ...[
              const SizedBox(height: 8),
              const Text(
                '*Paket tidak tersedia untuk waktu yang dipilih',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.error,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            if (isEligible && isSelected) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Harga:'),
                  Text(
                    Formatters.currency(package.calculatePrice(duration)),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
