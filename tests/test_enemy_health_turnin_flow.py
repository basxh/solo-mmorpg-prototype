import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]

REQUIRED_PATHS = [
    'client/scenes/ui/combat_feedback.tscn',
    'client/scripts/ui/combat_feedback.gd',
]


class EnemyHealthTurnInFlowTest(unittest.TestCase):
    def test_required_enemy_health_feedback_files_exist(self):
        missing = [path for path in REQUIRED_PATHS if not (ROOT / path).exists()]
        self.assertEqual([], missing, f'Missing enemy health feedback files: {missing}')

    def test_enemy_actor_tracks_health_fields(self):
        enemy_actor = (ROOT / 'client/scripts/enemies/enemy_actor.gd').read_text(encoding='utf-8')
        self.assertIn('current_hp', enemy_actor)
        self.assertIn('max_hp', enemy_actor)
        self.assertIn('is_defeated', enemy_actor)

    def test_dialogue_service_supports_quest_turn_in(self):
        dialogue_service = (ROOT / 'client/scripts/dialogue/dialogue_service.gd').read_text(encoding='utf-8')
        self.assertIn('build_turn_in_dialogue', dialogue_service)


if __name__ == '__main__':
    unittest.main()
