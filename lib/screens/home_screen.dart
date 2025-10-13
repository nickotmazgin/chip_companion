import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chip_companion/l10n/app_localizations.dart';
import 'package:chip_companion/services/settings_service.dart';
import 'package:chip_companion/services/purchase_service.dart';
import 'package:chip_companion/services/microchip_lookup_service.dart';
import 'package:chip_companion/widgets/chip_result_card.dart';
import 'package:chip_companion/widgets/registry_info_card.dart';
import 'package:chip_companion/widgets/tree_background.dart';
import 'package:chip_companion/widgets/tree_ui_components.dart';
import 'package:chip_companion/screens/settings_screen.dart';
import 'package:chip_companion/screens/help_screen.dart';
import 'package:chip_companion/screens/about_screen.dart';
import 'package:chip_companion/screens/glossary_screen.dart';
import 'package:chip_companion/screens/support_screen.dart';
import 'package:chip_companion/automation_bridge.dart';

class HomeScreen extends StatefulWidget {
  final SettingsService settingsService;
  final PurchaseService purchaseService;
  final String? scannedChipId;
  final VoidCallback? onChipIdCleared;

  const HomeScreen({
    super.key,
    required this.settingsService,
    required this.purchaseService,
    this.scannedChipId,
    this.onChipIdCleared,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _chipIdController = TextEditingController();
  final _chipIdFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  MicrochipLookupResult? _result;
  bool _isValidating = false;

  @override
  void initState() {
    super.initState();
    // Register automation hooks for web screenshot generator
    AutomationBridge.setChipId = (String chipId) {
      if (!mounted) return;
      _chipIdController.text = chipId;
      setState(() {
        _result = null;
      });
      AutomationBridge.debugLog('setChipId($chipId)');
    };
    AutomationBridge.focusInput = () {
      if (!mounted) return;
      _chipIdFocusNode.requestFocus();
      AutomationBridge.debugLog('focusInput()');
    };
    AutomationBridge.validateChip = () {
      if (!mounted) return;
      AutomationBridge.debugLog('validateChip()');
      _validateChipId();
    };
    // Auto-focus the input when the page is shown to help HID scanners
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _chipIdFocusNode.requestFocus();
      }
    });
    // Set scanned chip ID if provided and auto-validate
    if (widget.scannedChipId != null) {
      _chipIdController.text = widget.scannedChipId!;
      // Schedule validation after the first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (widget.settingsService.autoValidateOnScan) {
            _validateChipId();
          } else {
            // Keep focus on input for manual confirmation
            _chipIdFocusNode.requestFocus();
          }
        }
      });
    }
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle scanned chip ID updates
    if (widget.scannedChipId != null && 
        widget.scannedChipId != oldWidget.scannedChipId) {
      _chipIdController.text = widget.scannedChipId!;
      // Auto-validate the scanned chip ID
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (widget.settingsService.autoValidateOnScan) {
            _validateChipId();
          } else {
            _chipIdFocusNode.requestFocus();
          }
        }
      });
    }
  }

  @override
  void dispose() {
    // Unregister automation hooks if this screen is going away
    if (AutomationBridge.setChipId != null) AutomationBridge.setChipId = null;
    if (AutomationBridge.focusInput != null) AutomationBridge.focusInput = null;
    if (AutomationBridge.validateChip != null) AutomationBridge.validateChip = null;
    _chipIdController.dispose();
    _chipIdFocusNode.dispose();
    super.dispose();
  }

  Future<void> _validateChipId() async {
    final l10n = AppLocalizations.of(context)!;
    if (!mounted) return; // Add this check
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isValidating = true;
      _result = null;
    });

    // Add slight delay for better UX
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final result = await MicrochipLookupService.validateChipFormat(
        _chipIdController.text.trim(),
      );

      if (!mounted) return; // Add this critical check

      setState(() {
        _result = result;
        _isValidating = false;
      });

      // Provide haptic feedback
      HapticFeedback.lightImpact();
      // Focus input again so operators can scan the next chip immediately
      if (mounted) {
        _chipIdFocusNode.requestFocus();
      }
    } catch (e) {
      if (!mounted) return; // Add this check
      setState(() {
        _isValidating = false;
      });
      _showErrorSnackBar(l10n.validationErrorOccurred);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _clearResults() {
    setState(() {
      _chipIdController.clear();
      _result = null;
    });
    // Clear scanned chip ID if callback is provided
    widget.onChipIdCleared?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: TreeBackgroundAppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _navigateToScreen(const HelpScreen()),
            tooltip: l10n.helpTitle,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToScreen(
              SettingsScreen(settingsService: widget.settingsService),
            ),
            tooltip: l10n.settingsTitle,
          ),
          PopupMenuButton<String>(
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'about',
                child: Text(l10n.about),
              ),
              PopupMenuItem<String>(
                value: 'support',
                child: Text(l10n.support),
              ),
              PopupMenuItem<String>(
                value: 'glossary',
                child: Text(l10n.glossaryTitle),
              ),
            ],
            onSelected: (value) {
              if (value == 'about') {
                _navigateToScreen(const AboutScreen());
              } else if (value == 'support') {
                _navigateToScreen(const SupportScreen());
              } else if (value == 'glossary') {
                _navigateToScreen(const GlossaryScreen());
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: TreeBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildWelcomeCard(l10n),
                    const SizedBox(height: 24),
                    _buildInputSection(l10n),
                    const SizedBox(height: 24),
                    if (_isValidating) _buildLoadingCard(),
                    if (_result != null) ...[
                      ChipResultCard(result: _result!),
                      const SizedBox(height: 16),
                      if (_result!.suggestedRegistries.isNotEmpty)
                        RegistryInfoCard(registries: _result!.suggestedRegistries),
                    ],
                    const SizedBox(height: 32),
                    _buildDisclaimerCard(l10n),
                    const SizedBox(height: 24),
                    _buildDeveloperFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildWelcomeCard(AppLocalizations l10n) {
    return TreeBackgroundCard(
      elevation: 6,
      treeOpacity: 0.12,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.pets,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.professionalMicrochipValidator,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 28,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.validateChipFormatsAndFindRegistries,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 20,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(AppLocalizations l10n) {
    return TreeBackgroundCard(
      elevation: 6,
      treeOpacity: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.formatValidation,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                shadows: [
                  Shadow(
                    color: Colors.white.withValues(alpha: 0.8),
                    blurRadius: 1,
                    offset: const Offset(0.5, 0.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              label: l10n.microchipIdInputField,
              hint: l10n.enterMicrochipIdToValidate,
              child: TextFormField(
                controller: _chipIdController,
                focusNode: _chipIdFocusNode,
                decoration: InputDecoration(
                  labelText: l10n.enterChipId,
                  hintText: l10n.chipIdHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.tag),
                  suffixIcon: _chipIdController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearResults,
                        )
                      : null,
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Fa-f\s\-]')),
                  LengthLimitingTextInputFormatter(20),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.invalidInput;
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) _result = null;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              label: _isValidating
                  ? l10n.validatingMicrochipFormat
                  : l10n.validateMicrochipFormat,
              button: true,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1B5E20).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TreeBackgroundButton(
                  text: _isValidating
                      ? l10n.validatingMicrochipFormat
                      : l10n.validateMicrochipFormat,
                  onPressed: _isValidating ? null : _validateChipId,
                  icon: _isValidating
                      ? Icons.hourglass_empty
                      : Icons.verified_outlined,
                  backgroundColor: _isValidating
                      ? const Color(0xFF795548)
                      : const Color(0xFF1B5E20),
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  elevation: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 6,
      color: Colors.white.withValues(alpha: 0.95),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.validatingFormat,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
                shadows: [
                  Shadow(
                    color: Colors.white.withValues(alpha: 0.8),
                    blurRadius: 1,
                    offset: const Offset(0.5, 0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimerCard(AppLocalizations l10n) {
    return TreeBackgroundCard(
      elevation: 6,
      treeOpacity: 0.18,
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.disclaimer,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperFooter() {
    final l10n = AppLocalizations.of(context)!;
    return TreeBackgroundCard(
      treeOpacity: 0.06,
      elevation: 2,
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF1B5E20).withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              l10n.developedBy,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1B5E20),
                fontSize: 16,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: [
                      GestureDetector(
                        onTap: () => _navigateToScreen(const SupportScreen()),
                        child: Text(
                          l10n.supportThisApp,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
              _buildFooterLink(
                l10n.contactDeveloper,
                'mailto:NickOtmazgin.Dev@gmail.com',
              ),
              _buildFooterLink(
                l10n.sourceCodeOnGitHub,
                'https://github.com/nickotmazgin/chip_companion',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.copyrightNotice,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.version,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text, String url) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cannot open link')),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error launching URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot open link')),
        );
      }
    }
  }

  void _navigateToScreen(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
