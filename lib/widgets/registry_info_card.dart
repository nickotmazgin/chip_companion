import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chip_companion/services/microchip_lookup_service.dart';

class RegistryInfoCard extends StatelessWidget {
  final List<RegistryInfo> registries;

  const RegistryInfoCard({super.key, required this.registries});

  @override
  Widget build(BuildContext context) {
    if (registries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Registry Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Add trademark disclaimer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '⚠️ Registry names are trademarks of their owners. Contact directly for official services.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Professional reference - contact these registries for verification:',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ...registries.map(
              (registry) => _buildRegistryItem(context, registry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistryItem(BuildContext context, RegistryInfo registry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Registry Name
          Text(
            registry.name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          // Region below name (on the left)
          if (registry.region.isNotEmpty)
            Row(
              children: [
                Icon(Icons.public, size: 14, color: Colors.blue[700]),
                const SizedBox(width: 4),
                Text(
                  registry.region,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          // Contact Info (notes)
          if (registry.contactInfo != null && registry.contactInfo!.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    registry.contactInfo!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          // Phone row with copy/open icons
          if (registry.phone != null && registry.phone!.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    registry.phone!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  tooltip: 'Copy',
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: registry.phone!));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Phone number copied to clipboard!')),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_new, size: 18),
                  tooltip: 'Open dialer',
                  onPressed: () => _launchUrl('tel:${registry.phone!}'),
                ),
              ],
            ),
          // Email row with copy/open icons
          if (registry.email != null && registry.email!.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.email, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    registry.email!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  tooltip: 'Copy',
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: registry.email!));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email copied to clipboard!')),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_new, size: 18),
                  tooltip: 'Compose email',
                  onPressed: () => _handleEmailTap(context, registry.email!),
                ),
              ],
            ),
          const SizedBox(height: 12),
          // Visit Website Button
          if (registry.website.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _launchUrl(registry.website),
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text('Visit Website'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          if (registry.isEducational) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, size: 14, color: Colors.orange[700]),
                  const SizedBox(width: 4),
                  Text(
                    'Professional Reference',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.orange[700],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (registry.lookupUrl != null) {
                    await _launchUrl(registry.lookupUrl!);
                  } else {
                    await _launchUrl(registry.website);
                  }
                },
                icon: const Icon(Icons.search, size: 16),
                label: const Text('Real Lookup'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Cannot launch - URL scheme not supported
        throw Exception('Cannot open link');
      }
    } catch (e) {
      // Handle error silently - user can copy/paste URL if needed
      // No scaffold messenger here as this is a widget without BuildContext
    }
  }

  Future<void> _handleEmailTap(BuildContext context, String email) async {
    final mailto = Uri.parse('mailto:$email');
    try {
      if (await canLaunchUrl(mailto)) {
        final ok = await launchUrl(mailto, mode: LaunchMode.externalApplication);
        if (ok) return;
      }
    } catch (_) {
      // fall through to fallback
    }

    // Fallbacks when no email handler is configured (common on desktop/web)
    await Clipboard.setData(ClipboardData(text: email));
    if (context.mounted) {
      final gmailUrl = Uri.parse('https://mail.google.com/mail/?view=cm&fs=1&to=$email');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No mail app detected. Email address copied.'),
          action: SnackBarAction(
            label: 'Open Gmail',
            onPressed: () => _launchUrl(gmailUrl.toString()),
          ),
        ),
      );
    }
  }
}
