import json
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]

REQUIRED_PATHS = [
    'client/scenes/world/follow_camera_rig.tscn',
    'client/scenes/npcs/npc_actor.tscn',
    'client/scenes/enemies/enemy_actor.tscn',
    'client/scripts/world/follow_camera_rig.gd',
    'client/scripts/world/session_store.gd',
    'client/scripts/world/zone_loader.gd',
    'client/scripts/npcs/npc_actor.gd',
    'client/scripts/enemies/enemy_actor.gd',
    'shared/content/points_of_interest/starter_pois.json',
]


class WorldGameplayScaffoldTest(unittest.TestCase):
    def test_required_world_gameplay_files_exist(self):
        missing = [path for path in REQUIRED_PATHS if not (ROOT / path).exists()]
        self.assertEqual([], missing, f'Missing world gameplay scaffold paths: {missing}')

    def test_starter_zone_contains_runtime_bindable_spawn_and_landmark_data(self):
        zone = json.loads((ROOT / 'shared/content/zones/starter_zone.json').read_text(encoding='utf-8'))
        self.assertIn('spawn_point', zone)
        self.assertIn('landmarks', zone)
        self.assertGreaterEqual(len(zone['landmarks']), 5)
        self.assertIn('poi_manifest', zone)

    def test_poi_manifest_contains_runtime_scene_categories(self):
        pois = json.loads((ROOT / 'shared/content/points_of_interest/starter_pois.json').read_text(encoding='utf-8'))
        categories = {entry['category'] for entry in pois['points_of_interest']}
        self.assertIn('npc', categories)
        self.assertIn('enemy_spawn', categories)
        self.assertIn('landmark', categories)


if __name__ == '__main__':
    unittest.main()
