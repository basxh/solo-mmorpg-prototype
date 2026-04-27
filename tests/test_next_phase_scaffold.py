import json
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]

REQUIRED_PATHS = [
    'client/scenes/login/login_screen.tscn',
    'client/scenes/ui/game_hud.tscn',
    'client/scenes/player/player_character.tscn',
    'client/scripts/login/login_screen.gd',
    'client/scripts/ui/game_hud.gd',
    'client/scripts/player/player_character.gd',
    'client/scripts/network/network_service.gd',
    'client/scripts/network/session_state.gd',
    'shared/content/items/starter_items.json',
    'shared/content/enemies/starter_enemies.json',
    'shared/content/abilities/starter_abilities.json',
]


class NextPhaseScaffoldTest(unittest.TestCase):
    def test_required_next_phase_files_exist(self):
        missing = [path for path in REQUIRED_PATHS if not (ROOT / path).exists()]
        self.assertEqual([], missing, f'Missing next-phase scaffold paths: {missing}')

    def test_manifest_references_core_content_groups(self):
        manifest_path = ROOT / 'shared/content/manifest.json'
        with manifest_path.open('r', encoding='utf-8') as handle:
            manifest = json.load(handle)

        self.assertIn('content_sets', manifest)
        self.assertIn('zones', manifest['content_sets'])
        self.assertIn('quests', manifest['content_sets'])
        self.assertIn('npcs', manifest['content_sets'])
        self.assertIn('items', manifest['content_sets'])
        self.assertIn('enemies', manifest['content_sets'])
        self.assertIn('abilities', manifest['content_sets'])

    def test_starter_content_has_minimal_vertical_slice_counts(self):
        enemies = json.loads((ROOT / 'shared/content/enemies/starter_enemies.json').read_text(encoding='utf-8'))
        items = json.loads((ROOT / 'shared/content/items/starter_items.json').read_text(encoding='utf-8'))
        abilities = json.loads((ROOT / 'shared/content/abilities/starter_abilities.json').read_text(encoding='utf-8'))

        self.assertGreaterEqual(len(enemies['enemies']), 4)
        self.assertGreaterEqual(len(items['items']), 4)
        self.assertGreaterEqual(len(abilities['abilities']), 2)


if __name__ == '__main__':
    unittest.main()
