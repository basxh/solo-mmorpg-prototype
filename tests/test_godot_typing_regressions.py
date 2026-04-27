import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]


class GodotTypingRegressionTest(unittest.TestCase):
    def test_world_root_explicitly_types_enemy_apply_damage_result(self):
        world_root = (ROOT / 'client/scripts/bootstrap/world_root.gd').read_text(encoding='utf-8')
        self.assertIn('var defeated: bool = bool(enemy.apply_damage(6))', world_root)


if __name__ == '__main__':
    unittest.main()
