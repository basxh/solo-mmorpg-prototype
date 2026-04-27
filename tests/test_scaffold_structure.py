import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]

REQUIRED_PATHS = [
    'client/project.godot',
    'client/scenes/bootstrap/world_root.tscn',
    'client/scripts/network/network_client.gd',
    'server/README.md',
    'server/spacetimedb/module-layout.md',
    'shared/content/zones/starter_zone.json',
    'shared/content/quests/starter_chain.json',
    'shared/content/npcs/cinderwatch_npcs.json',
    'docs/architecture.md',
    'docs/local-development.md',
]


class ScaffoldStructureTest(unittest.TestCase):
    def test_required_scaffold_files_exist(self):
        missing = [path for path in REQUIRED_PATHS if not (ROOT / path).exists()]
        self.assertEqual([], missing, f'Missing scaffold paths: {missing}')


if __name__ == '__main__':
    unittest.main()
