import 'package:flutter/material.dart';
import 'package:chip_companion/widgets/tree_ui_components.dart';
import 'package:chip_companion/l10n/app_localizations.dart';
import 'package:chip_companion/widgets/tree_background.dart';

class GlossaryScreen extends StatelessWidget {
  const GlossaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: TreeBackgroundAppBar(title: Text(l10n.glossaryTitle)),
      body: TreeBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _tile(
                  context,
                  title: l10n.glossaryAboutTitle,
                  body: l10n.glossaryAboutBody,
                ),
                _tile(
                  context,
                  title: l10n.glossaryHowTitle,
                  body: l10n.glossaryHowBody,
                ),
                _tile(
                  context,
                  title: l10n.glossaryISOTitle,
                  body: l10n.glossaryISOBody,
                ),
                _tile(
                  context,
                  title: l10n.glossaryAvidTitle,
                  body: l10n.glossaryAvidBody,
                ),
                _tile(
                  context,
                  title: l10n.glossaryLegacyTitle,
                  body: l10n.glossaryLegacyBody,
                ),
                _tile(
                  context,
                  title: l10n.glossaryHexTitle,
                  body: l10n.glossaryHexBody,
                ),
                _tile(
                  context,
                  title: l10n.glossaryScanningTitle,
                  body: l10n.glossaryScanningBody,
                ),
                _tile(
                  context,
                  title: l10n.glossaryDigitsTitle,
                  body: l10n.glossaryDigitsBody,
                ),
                _tile(
                  context,
                  title: l10n.glossaryEdgeCasesTitle,
                  body: l10n.glossaryEdgeCasesBody,
                ),
                _tile(
                  context,
                  title: l10n.glossaryBeyondTitle,
                  body: l10n.glossaryBeyondBody,
                ),
                const SizedBox(height: 16),
                Card(
                  color: Colors.amber[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.glossaryDisclaimer,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
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
    );
  }

  Widget _tile(BuildContext context, {required String title, required String body}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 6),
            Text(body),
          ],
        ),
      ),
    );
  }
}
