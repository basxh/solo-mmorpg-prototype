import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]

REQUIRED_PATHS = [
    'client/scenes/world/poi_marker.tscn',
    'client/scripts/world/poi_marker.gd',
]


class WorldMarkerInteractionFlowTest(unittest.TestCase):
    def test_required_world_marker_files_exist(self):
        missing = [path for path in REQUIRED_PATHS if not (ROOT / path).exists()]
        self.assertEqual([], missing, f'Missing world marker files: {missing}')

    def test_project_contains_interaction_and_target_input_actions(self):
        project_text = (ROOT / 'client/project.godot').read_text(encoding='utf-8')
        self.assertIn('interact={', project_text)
        self.assertIn('target_cycle={', project_text)


if __name__ == '__main__':
    unittest.main()
