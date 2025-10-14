#!/usr/bin/env python3
"""
Check localization (ARB) files for missing and extra keys compared to the
English template.

Usage:
    python tools/check_l10n.py
"""
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]
L10N = ROOT / 'lib' / 'l10n'

TEMPLATE = L10N / 'app_en.arb'
LOCALES = sorted(p for p in L10N.glob('app_*.arb') if p.name != 'app_en.arb')

 
def main():
    base = json.loads(TEMPLATE.read_text(encoding='utf-8'))
    base_keys = {k for k in base.keys() if not k.startswith('@')}
    print(f'Template: {TEMPLATE.name} ({len(base_keys)} keys)')
    problems = 0
    for loc in LOCALES:
        data = json.loads(loc.read_text(encoding='utf-8'))
        keys = {k for k in data.keys() if not k.startswith('@')}
        missing = sorted(base_keys - keys)
        extra = sorted(keys - base_keys)
        print(f'Locale {loc.name}: missing={len(missing)}, extra={len(extra)}')
        if missing:
            problems += 1
            preview = ', '.join(missing[:20])
            if len(missing) > 20:
                preview += ' ...'
            print('  Missing keys:', preview)
        if extra:
            preview = ', '.join(extra[:20])
            if len(extra) > 20:
                preview += ' ...'
            print('  Extra keys:', preview)
    if problems:
        raise SystemExit(1)

 
if __name__ == '__main__':
    main()
