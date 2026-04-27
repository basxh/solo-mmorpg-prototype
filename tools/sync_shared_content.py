#!/usr/bin/env python3
import json
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SHARED = ROOT / 'shared' / 'content'
CLIENT = ROOT / 'client' / 'content'

COPIED_DIRS = [
    'zones',
    'quests',
    'npcs',
    'items',
    'enemies',
    'abilities',
    'points_of_interest',
]


def copy_tree(source: Path, target: Path) -> None:
    if not source.exists():
        return
    if target.exists():
        shutil.rmtree(target)
    shutil.copytree(source, target)


def main() -> int:
    CLIENT.mkdir(parents=True, exist_ok=True)
    shutil.copy2(SHARED / 'manifest.json', CLIENT / 'manifest.json')
    for dirname in COPIED_DIRS:
        copy_tree(SHARED / dirname, CLIENT / dirname)

    manifest = json.loads((CLIENT / 'manifest.json').read_text(encoding='utf-8'))
    print(json.dumps({
        'starter_zone': manifest.get('starter_zone'),
        'content_sets': sorted(manifest.get('content_sets', {}).keys()),
        'client_content_root': str(CLIENT),
    }, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
