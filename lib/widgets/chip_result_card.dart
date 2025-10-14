import 'package:flutter/material.dart';
import 'package:chip_companion/services/microchip_lookup_service.dart';
import 'package:chip_companion/services/real_lookup_service.dart';
import 'package:chip_companion/l10n/app_localizations.dart';
import 'package:chip_companion/widgets/tree_ui_components.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class ChipResultCard extends StatelessWidget {
  final MicrochipLookupResult result;

  const ChipResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return TreeBackgroundCard(
      elevation: 6,
      treeOpacity: 0.08,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, l10n, theme),
            const SizedBox(height: 16),
            _buildChipIdDisplay(theme),
            const SizedBox(height: 16),
            _buildFormatInfo(theme),
            const SizedBox(height: 16),
            _buildDescription(theme),
            if (result.chipStandard != null) ...[
              const SizedBox(height: 12),
              _buildChipStandard(theme),
            ],
            // Show prefix hint for ISO 15-digit chips
            if (_shouldShowPrefixHint()) ...[
              const SizedBox(height: 12),
              _buildPrefixHint(theme),
            ],
            if (result.manufacturerHint != null) ...[
              const SizedBox(height: 12),
              _buildManufacturerHint(theme),
            ],
            if (result.country != null) ...[
              const SizedBox(height: 12),
              _buildCountry(theme),
            ],
            if (result.nextStepsGuidance != null) ...[
              const SizedBox(height: 12),
              _buildNextStepsGuidance(theme),
            ],
            const SizedBox(height: 12),
            _buildValidationDate(theme),
            if (result.isValidFormat) ...[
              const SizedBox(height: 16),
              _buildRealLookupButton(context, theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: result.isValidFormat
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.errorContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            result.isValidFormat ? Icons.check_circle : Icons.error,
            color: result.isValidFormat
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onErrorContainer,
            size: 32,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.isValidFormat ? l10n.validFormat : l10n.invalidFormat,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: result.isValidFormat
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Format Validation Result',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCountry(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF5E35B1).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.flag, color: const Color(0xFF5E35B1), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Country',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF4527A0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.country!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF4527A0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipIdDisplay(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tag, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chip ID',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      result.chipId,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
                IconButton(
                tooltip: 'Copy',
                icon: const Icon(Icons.copy),
                onPressed: () async {
                  await HapticFeedback.lightImpact();
                  await Clipboard.setData(ClipboardData(text: result.chipId));
                },
              ),
            ],
          ),
          if (result.decimalIsoId != null) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.calculate_outlined,
                    color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Decimal ISO (from hex)',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        result.decimalIsoId!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Copy',
                  icon: const Icon(Icons.copy),
                  onPressed: () async {
                    await HapticFeedback.lightImpact();
                    await Clipboard.setData(
                        ClipboardData(text: result.decimalIsoId!));
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormatInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chip Type',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.chipType,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.description,
            color: theme.colorScheme.onPrimaryContainer,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              result.formatDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealLookupButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final idForLookup = result.decimalIsoId ?? result.chipId;
          // Show loading
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );

          // Perform real lookup
          final success = await RealLookupService.performBestRealLookup(
            idForLookup,
          );

          // Close loading dialog
          if (context.mounted) {
            Navigator.of(context).pop();

            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    result.decimalIsoId != null
                        ? '✅ Using decimal ISO to open the lookup...'
                        : '✅ Opening real microchip lookup in your browser...',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    '❌ Could not open lookup. Please try manually.',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        icon: const Icon(Icons.search),
        label: const Text('Perform REAL Lookup'),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildChipStandard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF2196F3).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.verified, color: const Color(0xFF2196F3), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chip Standard',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF1976D2),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.chipStandard!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF1976D2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManufacturerHint(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.business, color: const Color(0xFF9C27B0), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Identified Manufacturer',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF7B1FA2),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.manufacturerHint!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF7B1FA2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepsGuidance(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: const Color(0xFF2E7D32),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Steps',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF1B5E20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.nextStepsGuidance!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF1B5E20),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidationDate(ThemeData theme) {
    final formatter = DateFormat('MMM dd, yyyy • HH:mm');
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            color: theme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'Validated: ${formatter.format(result.validationDate)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Check if we should show the prefix hint for ISO 15-digit chips
  bool _shouldShowPrefixHint() {
    if (result.chipType != 'ISO 11784/11785') return false;
    if (result.chipId.length != 15) return false;
    
    final prefix = int.tryParse(result.chipId.substring(0, 3));
    if (prefix == null) return false;
    
    return (prefix >= 1 && prefix <= 899) || (prefix >= 900 && prefix <= 998);
  }

  /// Build prefix hint widget for ISO chips
  Widget _buildPrefixHint(ThemeData theme) {
    final prefix = int.parse(result.chipId.substring(0, 3));
    final isCountry = prefix >= 1 && prefix <= 899;
    final hint = isCountry ? 'Country code' : 'Manufacturer code';
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF00BCD4).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCountry ? Icons.public : Icons.precision_manufacturing,
            color: const Color(0xFF00838F),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prefix: ${result.chipId.substring(0, 3)}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF006064),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF00838F),
                    fontWeight: FontWeight.w600,
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
