import 'package:flutter/material.dart';
import 'package:chip_companion/l10n/app_localizations.dart';
import 'package:chip_companion/widgets/tree_background.dart';
import 'package:chip_companion/widgets/tree_ui_components.dart';
import 'package:chip_companion/screens/glossary_screen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.helpFAQ),
        backgroundColor: const Color(0xFFE8F5E8).withValues(alpha: 0.95),
        foregroundColor: const Color(0xFF2E7D32),
        actions: [
          IconButton(
            tooltip: 'Microchip Glossary',
            icon: const Icon(Icons.menu_book_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed('/glossary');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF2E7D32),
          unselectedLabelColor: const Color(0xFF2E7D32).withValues(alpha: 0.6),
          indicatorColor: const Color(0xFF2E7D32),
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          tabs: [
            Tab(icon: const Icon(Icons.help_outline), child: FittedBox(fit: BoxFit.scaleDown, child: Text(l10n.howToUse))),
            Tab(icon: const Icon(Icons.lightbulb_outline), child: FittedBox(fit: BoxFit.scaleDown, child: Text(l10n.tips))),
            Tab(
              icon: const Icon(Icons.build_outlined),
              child: FittedBox(fit: BoxFit.scaleDown, child: Text(l10n.troubleshooting)),
            ),
          ],
        ),
      ),
      body: TreeBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHowToUseTab(context, l10n, isTablet),
                _buildTipsTab(context, l10n, isTablet),
                _buildTroubleshootingTab(context, l10n, isTablet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHowToUseTab(
    BuildContext context,
    AppLocalizations l10n,
    bool isTablet,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isTablet ? 32.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step by Step Guide
          TreeBackgroundCard(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.list_alt, color: Color(0xFF2E7D32)),
                      const SizedBox(width: 8),
                      Text(
                        l10n.stepByStep,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF2E7D32),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildStepTile(
                    context,
                    Icons.edit,
                    l10n.step1,
                    'Find or scan your pet\'s microchip ID. You can enter it manually, scan with a Bluetooth RFID scanner (HID keyboard), or use your phone\'s NFC (if supported). Vets and shelters can scan it for you as well.',
                    isTablet,
                  ),

                  _buildStepTile(
                    context,
                    Icons.search,
                    l10n.step2,
                    'Enter or scan the ID in the input field, then tap the green "Validate microchip format" button to check the format and see suggested registries.',
                    isTablet,
                  ),

                  _buildStepTile(
                    context,
                    Icons.visibility,
                    l10n.step3,
                    'Review the validation result and recommendations. You\'ll see the chip type, optional manufacturer/country hints, and suggested registries to contact.',
                    isTablet,
                  ),

                  _buildStepTile(
                    context,
                    Icons.contact_phone,
                    l10n.step4,
                    'Contact the registry directly to get official owner contact information or update registration details. This app does not store owner data or perform official database queries.',
                    isTablet,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Supported Regions
          TreeBackgroundCard(
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
                        l10n.globalRegistries,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF2E7D32),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const ListTile(
                    leading: Text('🇮🇱', style: TextStyle(fontSize: 24)),
                    title: Text('Israel'),
                    subtitle: Text(
                      'Israeli Veterinary Association, Pet registries, Animal ID systems',
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),

                  const ListTile(
                    leading: Text('🇷🇺', style: TextStyle(fontSize: 24)),
                    title: Text('Russia'),
                    subtitle: Text(
                      'Russian Veterinary Registry, Animal Passport System, Regional databases',
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),

                  const ListTile(
                    leading: Text('🇨🇦', style: TextStyle(fontSize: 24)),
                    title: Text('Canada'),
                    subtitle: Text(
                      'Canadian Animal Registry, Provincial Pet Databases, Veterinary Registry',
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),

                  const ListTile(
                    leading: Text('🇺🇸', style: TextStyle(fontSize: 24)),
                    title: Text('USA'),
                    subtitle: Text(
                      'Pet Registry Service, Animal Database, Microchip Registry',
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),

                  const ListTile(
                    leading: Text('🇬🇧', style: TextStyle(fontSize: 24)),
                    title: Text('UK'),
                    subtitle: Text('Petlog, Animal Tracker, Anibase'),
                    contentPadding: EdgeInsets.zero,
                  ),

                  const ListTile(
                    leading: Text('🌍', style: TextStyle(fontSize: 24)),
                    title: Text('50+ Countries'),
                    subtitle: Text(
                      'Professional microchip validation and registry directory',
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool isTablet,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2E7D32),
              size: isTablet ? 24 : 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: isTablet ? 18 : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontSize: isTablet ? 14 : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsTab(
    BuildContext context,
    AppLocalizations l10n,
    bool isTablet,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isTablet ? 32.0 : 16.0),
      child: Column(
        children: [
          // Quick link to Microchip Glossary
          TreeBackgroundCard(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.menu_book_outlined,
                      size: isTablet ? 28 : 24, color: const Color(0xFF2E7D32)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Microchip Glossary',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet ? 18 : null,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Learn about ISO vs AVID vs Legacy formats, country/manufacturer prefixes, and hex-to-decimal conversion.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: isTablet ? 14 : null,
                                height: 1.3,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const GlossaryScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Open Glossary'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          _buildTipCard(
            context,
            '💡',
            'Microchip ID Formats',
            'Common formats include ISO 11784/11785 (15-digit numeric), AVID 10-digit, Legacy 9-digit, and sometimes a 15-character hexadecimal representation that converts to a 15-digit ISO number.',
            isTablet,
          ),

          _buildTipCard(
            context,
            '🔍',
            'Validation Tips',
            'Use the green "Validate microchip format" button. Try with/without spaces or dashes. For hex (letters A–F), the app can present a decimal ISO for official lookups.',
            isTablet,
          ),

          _buildTipCard(
            context,
            '📋',
            'Where to Find or Scan the ID',
            'Check vaccination records, adoption papers, insurance, or registration certificates. You can also scan with: (1) Bluetooth RFID scanners (HID keyboard profile), (2) NFC on supported phones, or (3) at a veterinary clinic/shelter.',
            isTablet,
          ),

          _buildTipCard(
            context,
            '🏥',
            'Multiple Registries',
            'Some pets may be registered with multiple services. Try different variations of the ID if needed.',
            isTablet,
          ),

          _buildTipCard(
            context,
            '📱',
            'Supported Scanner Types',
            'This app supports:\n• ✅ Bluetooth: Wireless RFID scanners (HID profile)\n• ⚠️ NFC: Phone NFC (13.56 MHz) typically cannot read implanted ISO 11784/11785 FDX‑B (134.2 kHz) microchips; it can read NDEF tags (e.g., collars/cards). From Devices → Scan with NFC, if a tag contains the chip ID in text/URL, the app extracts, populates Home, and validates.\n• ✅ Manual: Direct chip ID entry\n\nOther scanners (not officially supported by this app):\n• 🔌 USB: Keyboard‑wedge scanners may work on desktop if the OS treats them as a keyboard\n• 📶 Serial/RS‑232: Professional veterinary equipment',
            isTablet,
          ),

          _buildTipCard(
            context,
            '🌍',
            'International Travel',
            'If traveling internationally with pets, ensure microchip compatibility with destination country systems.',
            isTablet,
          ),

          _buildTipCard(
            context,
            '⚡',
            'Quick Tips for Lost Pets',
            'If you found a lost pet:\n• Scan for microchip at veterinary clinic or animal shelter\n• Search multiple databases using this app\n• Post on local lost pet Facebook groups\n• Contact animal control and local veterinarians\n• Check for ID tags or collars',
            isTablet,
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(
    BuildContext context,
    String emoji,
    String title,
    String content,
    bool isTablet,
  ) {
    return TreeBackgroundCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: TextStyle(fontSize: isTablet ? 32 : 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 18 : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: isTablet ? 14 : null,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTroubleshootingTab(
    BuildContext context,
    AppLocalizations l10n,
    bool isTablet,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isTablet ? 32.0 : 16.0),
      child: Column(
        children: [
          // Common Issues
          TreeBackgroundCard(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.help_outline, color: Colors.orange[600]),
                      const SizedBox(width: 8),
                      Text(
                        l10n.notFound,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.orange[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.tryThese,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildSolutionTile(
                    context,
                    Icons.edit,
                    'Double-check the ID number',
                    'Verify each digit carefully. Common mistakes include confusing 0/O, 1/I, 5/S, 6/G. Ensure you\'re reading from the most recent documentation.',
                    isTablet,
                  ),

                  _buildSolutionTile(
                    context,
                    Icons.format_clear,
                    'Try different formats',
                    'Remove spaces, dashes, or other characters. Try with/without leading zeros.',
                    isTablet,
                  ),

                  _buildSolutionTile(
                    context,
                    Icons.pets,
                    'Contact your veterinarian',
                    'Your veterinarian can scan the microchip again and verify the correct number and format. They have professional-grade scanners that can read all chip types.',
                    isTablet,
                  ),

                  _buildSolutionTile(
                    context,
                    Icons.schedule,
                    'Check registration timing',
                    'New registrations may take 24-48 hours to appear in search systems. Some registries update their databases weekly or monthly.',
                    isTablet,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Technical Issues
          TreeBackgroundCard(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.settings, color: Colors.red[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Technical Issues',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.red[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildSolutionTile(
                    context,
                    Icons.wifi_off,
                    'No internet connection',
                    'Check your internet connection. The app requires internet to search registries. Try switching between WiFi and mobile data.',
                    isTablet,
                  ),

                  _buildSolutionTile(
                    context,
                    Icons.refresh,
                    'Search timeout',
                    'If search takes too long, try again. Registry servers may be busy during peak hours.',
                    isTablet,
                  ),

                  _buildSolutionTile(
                    context,
                    Icons.error,
                    'App crashes or errors',
                    'Restart the app and try again. If problems persist, contact support via the About section or email the developer directly.',
                    isTablet,
                  ),

                  _buildSolutionTile(
                    context,
                    Icons.numbers,
                    'Hex vs decimal',
                    'If your scanner shows letters (A–F), it may be a hex representation. Validate first; the app will show a decimal ISO if a safe conversion is possible.',
                    isTablet,
                  ),

                  _buildSolutionTile(
                    context,
                    Icons.bluetooth,
                    'Bluetooth scanner not inputting',
                    'Ensure your scanner is paired as an HID keyboard. Tap the input field to focus it before scanning. Some scanners need a suffix like ENTER—configure in the scanner manual.',
                    isTablet,
                  ),

                  _buildSolutionTile(
                    context,
                    Icons.nfc,
                    'NFC not reading',
                    'Phone NFC (13.56 MHz) typically cannot read implanted ISO 11784/11785 FDX‑B (134.2 kHz) pet microchips. It can read NFC NDEF tags (e.g., collars/cards) that contain the chip ID in text or a URL. From Devices, tap Scan with NFC: if a tag contains the ID, we extract, populate the Home input, and you can validate.',
                    isTablet,
                  ),

                  _buildSolutionTile(
                    context,
                    Icons.usb,
                    'USB keyboard wedge scanners',
                    'On desktop, some USB RFID scanners present as a keyboard (“keyboard‑wedge”). These can type directly into the Home input when it is focused. Configure suffix (e.g., ENTER) in the scanner manual if you want auto‑submit after scan.',
                    isTablet,
                  ),

                  _buildSolutionTile(
                    context,
                    Icons.keyboard,
                    'No input captured on web',
                    'If running in a browser, click the input field to focus it before scanning. Browser security requires a focused field for HID keyboard input.',
                    isTablet,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Registry-Specific Issues
          TreeBackgroundCard(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.public, color: Colors.green[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Registry-Specific Issues',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.green[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildSolutionTile(
                    context,
                    Icons.flag,
                    'Country-specific formats',
                    'Some countries use different ID formats. Israeli and Russian chips may have unique patterns. Check with local veterinary authorities for format specifications.',
                    isTablet,
                  ),

                  _buildSolutionTile(
                    context,
                    Icons.calendar_today,
                    'Old registrations',
                    'Very old microchips (pre-2010) may not be in current digital databases.',
                    isTablet,
                  ),

                  _buildSolutionTile(
                    context,
                    Icons.merge_type,
                    'Multiple registries',
                    'This is a professional microchip validation tool and registry directory. For official pet identification and database searches, contact veterinary professionals and official registries directly.',
                    isTablet,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Contact Support
          TreeBackgroundCard(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              child: Column(
                children: [
                  Icon(
                    Icons.support_agent,
                    size: isTablet ? 48 : 40,
                    color: const Color(0xFF2E7D32),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Still Need Help?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'If you\'re still having trouble, feel free to contact us via the About section. We\'re here to help reunite pets with their families! For urgent cases, contact your local veterinary clinic or animal shelter.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolutionTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool isTablet,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: Colors.grey[600],
              size: isTablet ? 20 : 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: isTablet ? 16 : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: isTablet ? 13 : null,
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
