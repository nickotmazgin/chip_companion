import 'package:flutter/material.dart';
import 'package:chip_companion/l10n/app_localizations.dart';
import 'package:chip_companion/services/settings_service.dart';
import 'package:chip_companion/services/version_service.dart';
import 'package:chip_companion/screens/about_screen.dart';
import 'package:chip_companion/screens/help_screen.dart';
import 'package:chip_companion/widgets/tree_background.dart';
import 'package:chip_companion/widgets/tree_ui_components.dart';
import 'package:chip_companion/screens/support_screen.dart';
// Diagnostics screen was temporary for testing and has been removed for release.

class SettingsScreen extends StatefulWidget {
  final SettingsService settingsService;

  const SettingsScreen({super.key, required this.settingsService});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsService _settingsService = widget.settingsService;
  String _currentLanguage = 'en';
  bool _autoValidateOnScan = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    final language = await _settingsService.getSavedLanguage();
    final autoValidate = await _settingsService.getAutoValidateOnScan();
    setState(() {
      _currentLanguage = language;
      _autoValidateOnScan = autoValidate;
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    await _settingsService.saveLanguage(languageCode);
    setState(() {
      _currentLanguage = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: TreeBackgroundAppBar(title: Text(l10n.settings)),
      body: TreeBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
            // Language Selection Section
            TreeBackgroundCard(
              treeOpacity: 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        l10n.language,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.selectLanguage,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // Language Options
                  ...SettingsService.supportedLanguages.map((language) {
                    return CheckboxListTile(
                      title: Text(language.nativeName),
                      subtitle: Text(language.englishName),
                      value: _currentLanguage == language.code,
                      onChanged: (bool? selected) {
                        if (selected == true) {
                          _changeLanguage(language.code);
                        }
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Actions Section
            TreeBackgroundCard(
              treeOpacity: 0.15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.dashboard, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        l10n.quickActions,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Auto-validate on scan toggle
                  SwitchListTile(
                    title: Text(l10n.autoValidateOnScanTitle),
                    subtitle: Text(l10n.autoValidateOnScanSubtitle),
                    value: _autoValidateOnScan,
                    onChanged: (value) async {
                      await _settingsService.setAutoValidateOnScan(value);
                      if (mounted) {
                        setState(() => _autoValidateOnScan = value);
                      }
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 12),

                  // Help & FAQ Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.help_outline),
                      label: Text(l10n.helpFAQ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // About Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.info_outline),
                      label: Text(l10n.about),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Support Button (donations are voluntary only)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SupportScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.volunteer_activism),
                      label: Text(AppLocalizations.of(context)!.support),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // App Information Section
            TreeBackgroundCard(
              treeOpacity: 0.06,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        l10n.appInformation,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  ListTile(
                    leading: const Icon(Icons.pets, color: Color(0xFF2E7D32)),
                    title: Text(l10n.appTitle),
                    subtitle: FutureBuilder<String>(
                      future: VersionService.getVersionString(l10n.version),
                      builder: (context, snapshot) {
                        return Text(snapshot.data ?? l10n.version);
                      },
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.description),
                    title: Text(l10n.description),
                    subtitle: Text(l10n.enterMicrochipId),
                    contentPadding: EdgeInsets.zero,
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.public),
                    title: Text(
                      l10n.globalCoverage
                          .replaceAll('🌍 ', '')
                          .replaceAll(' • 🔍 ', ' - '),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Footer
            Text(
              l10n.madeWithLove,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
