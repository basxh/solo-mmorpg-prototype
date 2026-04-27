import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]

REQUIRED_PATHS = [
    'client/scenes/ui/interaction_prompt.tscn',
    'client/scenes/ui/target_frame.tscn',
    'client/scripts/ui/interaction_prompt.gd',
    'client/scripts/ui/target_frame.gd',
    'client/scripts/interactions/interaction_service.gd',
    'client/scripts/targeting/targeting_service.gd',
    'shared/content/dialogue/starter_dialogue.json',
]


class InteractionTargetingScaffoldTest(unittest.TestCase):
    def test_required_interaction_and_targeting_files_exist(self):
        missing = [path for path in REQUIRED_PATHS if not (ROOT / path).exists()]
        self.assertEqual([], missing, f'Missing interaction/targeting scaffold paths: {missing}')


if __name__ == '__main__':
    unittest.main()
