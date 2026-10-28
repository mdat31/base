import 'package:flutter/material.dart';
import 'package:mod/core/l10n/l10n.dart';

/// Lists every supported locale by its native name, plus "system default".
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final Locale? value;
  final ValueChanged<Locale?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _LanguageTile(
            label: context.l10n.languageSystem,
            selected: value == null,
            onTap: () => onChanged(null),
          ),
          for (final locale in AppLocalizations.supportedLocales)
            _LanguageTile(
              label: lookupAppLocalizations(locale).languageName,
              selected: value == locale,
              onTap: () => onChanged(locale),
            ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(label),
    selected: selected,
    trailing: selected ? const Icon(Icons.check) : null,
    onTap: onTap,
  );
}
