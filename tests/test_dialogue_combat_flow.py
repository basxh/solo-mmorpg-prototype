import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]

REQUIRED_PATHS = [
    'client/scenes/ui/dialogue_panel.tscn',
    'client/scripts/ui/dialogue_panel.gd',
    'client/scripts/dialogue/dialogue_service.gd',
]


class DialogueCombatFlowTest(unittest.TestCase):
    def test_required_dialogue_flow_files_exist(self):
        missing = [path for path in REQUIRED_PATHS if not (ROOT / path).exists()]
        self.assertEqual([], missing, f'Missing dialogue flow files: {missing}')


if __name__ == '__main__':
    unittest.main()
