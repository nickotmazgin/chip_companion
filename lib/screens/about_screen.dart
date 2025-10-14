import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chip_companion/l10n/app_localizations.dart';
import 'package:chip_companion/widgets/tree_background.dart';
import 'package:chip_companion/widgets/tree_ui_components.dart';
import 'package:chip_companion/services/version_service.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  Future<void> _openEmail() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final uri = Uri.parse('mailto:nickotmazgin.dev@gmail.com');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to clipboard if email app not available
        await Clipboard.setData(
          const ClipboardData(text: 'nickotmazgin.dev@gmail.com'),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.emailCopiedToClipboard),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorOpeningEmail}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: TreeBackgroundAppBar(title: Text(l10n.about)),
      body: TreeBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? 32.0 : 16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo and Title
              Icon(
                Icons.pets,
                size: isTablet ? 120 : 100,
                color: const Color(0xFF2E7D32),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  l10n.appTitle,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: const Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 36 : null,
                    shadows: [Shadow(color: Colors.white, blurRadius: 2)],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<String>(
                future: VersionService.getVersionString(l10n.version),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? l10n.version,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                l10n.forPetOwners,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Developer Section
              Card(
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 24 : 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, color: Color(0xFF2E7D32)),
                          const SizedBox(width: 8),
                          Text(
                            l10n.developer,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: const Color(0xFF2E7D32),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.createdBy,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: isTablet ? 18 : null,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Nick Otmazgin',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 18 : null,
                          color: const Color(0xFF2E7D32),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Contact Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _openEmail(),
                          icon: const Icon(Icons.email),
                          label: Text(l10n.contact),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 16 : 12,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        l10n.developerEmail,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),



              const SizedBox(height: 16),

              // Supported Regions
              Card(
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 24 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.public, color: Color(0xFF2E7D32)),
                          const SizedBox(width: 8),
                          Text(
                            l10n.supportedRegions,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: const Color(0xFF2E7D32),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      ListTile(
                        leading: const Text(
                          '🇮🇱',
                          style: TextStyle(fontSize: 24),
                        ),
                        title: Text(l10n.israelSupport),
                        subtitle: Text(l10n.israelSupportDescription),
                        contentPadding: EdgeInsets.zero,
                      ),

                      ListTile(
                        leading: const Text(
                          '🇷🇺',
                          style: TextStyle(fontSize: 24),
                        ),
                        title: Text(l10n.russiaSupport),
                        subtitle: Text(l10n.russiaSupportDescription),
                        contentPadding: EdgeInsets.zero,
                      ),

                      ListTile(
                        leading: const Text(
                          '🌍',
                          style: TextStyle(fontSize: 24),
                        ),
                        title: Text(l10n.worldwideSupport),
                        subtitle: Text(l10n.worldwideSupportDescription),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Footer
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFE8F5E8),
                      Color(0xFFF1F8E9),
                      Color(0xFFE8F5E8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFF2E7D32).withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🌳', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          l10n.madeWithLove,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF1B5E20),
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.pets, color: Color(0xFF2E7D32), size: 18),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Legal Notice
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.appDisclaimer,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),
              // Support entry (voluntary donations only)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/support');
                  },
                  icon: const Icon(Icons.volunteer_activism),
                  label: Text(AppLocalizations.of(context)!.supportVoluntaryButton),
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
