#!/usr/bin/env python3
"""
Prune extra keys from non-English ARB files to match the English template.
Backs up originals alongside as *.bak.
"""
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]
L10N = ROOT / 'lib' / 'l10n'


def load_json(p: Path):
    with p.open('r', encoding='utf-8') as f:
        return json.load(f)


def save_json(p: Path, data):
    # Write pretty JSON with stable key order
    with p.open('w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2, sort_keys=True)
        f.write('\n')


def main():
    en = L10N / 'app_en.arb'
    if not en.exists():
        print('Missing English template:', en)
        return 2
    en_data = load_json(en)
    en_keys = {k for k in en_data.keys() if not k.startswith('@')}

    changed = 0
    for p in sorted(L10N.glob('app_*.arb')):
        if p.name == 'app_en.arb':
            continue
        data = load_json(p)
        keys = {k for k in data.keys() if not k.startswith('@')}
        extras = sorted(keys - en_keys)
        if not extras:
            print(f'{p.name}: OK (no extras)')
            continue
        # Backup
        bak = p.with_suffix(p.suffix + '.bak')
        bak.write_text(p.read_text(encoding='utf-8'), encoding='utf-8')
        # Prune extras
        for k in extras:
            data.pop(k, None)
            meta = '@' + k
            if meta in data:
                data.pop(meta, None)
        save_json(p, data)
        changed += 1
        print(f'{p.name}: removed {len(extras)} extra keys')

    print('Done. Files changed:', changed)
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
