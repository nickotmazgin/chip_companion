import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chip_companion/l10n/app_localizations.dart';
import 'package:chip_companion/widgets/tree_background.dart';
import 'package:chip_companion/widgets/tree_ui_components.dart';
import 'package:chip_companion/constants/docs_links.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static const _paypalUrl = 'https://www.paypal.com/paypalme/nickotmazgin';

  Future<void> _openUrl(BuildContext context, String url, String errorMessage) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cannot open link')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$errorMessage: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (kDebugMode) debugPrint('Error opening URL: $e');
    }
  }

  Future<void> _openPaypal(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final uri = Uri.parse(_paypalUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await Clipboard.setData(const ClipboardData(text: _paypalUrl));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.paypalLinkCopiedToClipboard)),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorOpeningPaypal}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (kDebugMode) debugPrint('Error opening PayPal: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
  appBar: TreeBackgroundAppBar(title: Text(l10n.support)),
      body: TreeBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Only show PayPal donate section on Android/Web (not iOS)
                  if (!kIsWeb && (Platform.isAndroid || !Platform.isIOS) || kIsWeb)
                    TreeBackgroundCard(
                      treeOpacity: 0.1,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.volunteer_activism, color: Color(0xFF2E7D32)),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.supportTitle,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF2E7D32),
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.supportIntro,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.25)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.info_outline, color: Color(0xFF2E7D32)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Voluntary, does not unlock features. In-app purchases (Pro) use Play/App Store billing.',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF1B5E20)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => _openPaypal(context),
                                icon: const Icon(Icons.open_in_new),
                                label: Text(l10n.donateViaPaypal),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2E7D32),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!kIsWeb && !Platform.isAndroid && Platform.isIOS)
                    TreeBackgroundCard(
                      treeOpacity: 0.1,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.info_outline, color: Color(0xFF1976D2)),
                                const SizedBox(width: 8),
                                Text(
                                  'Support via In-App Purchase',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1976D2),
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'On iOS, you can support development by purchasing Pro features through the App Store. This uses official App Store billing and provides lifetime access to Pro features.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF1976D2).withValues(alpha: 0.25)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.apple, color: Colors.blue[700]),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'In-app purchases (Pro features) use App Store billing. One-time purchase, lifetime access.',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF0D47A1)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Legal & Privacy Section
                  TreeBackgroundCard(
                    treeOpacity: 0.1,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.policy, color: Color(0xFF1976D2)),
                              const SizedBox(width: 8),
                              Text(
                                'Legal & Privacy',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1976D2),
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.privacy_tip, color: Color(0xFF1976D2)),
                            title: const Text('Privacy Policy'),
                            subtitle: const Text('How we handle your data'),
                            trailing: const Icon(Icons.open_in_new),
                            onTap: () => _openUrl(context, kPrivacyUrl, 'Error opening Privacy Policy'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.description, color: Color(0xFF1976D2)),
                            title: const Text('Legal Disclaimer'),
                            subtitle: const Text('Terms and conditions'),
                            trailing: const Icon(Icons.open_in_new),
                            onTap: () => _openUrl(context, kLegalUrl, 'Error opening Legal Disclaimer'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.security, color: Color(0xFF1976D2)),
                            title: const Text('Security'),
                            subtitle: const Text('Security practices and reporting'),
                            trailing: const Icon(Icons.open_in_new),
                            onTap: () => _openUrl(context, kSecurityUrl, 'Error opening Security'),
                          ),
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
    );
  }
}
