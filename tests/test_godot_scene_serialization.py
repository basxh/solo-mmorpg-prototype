import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
SCENES = [
    'client/scenes/npcs/npc_actor.tscn',
    'client/scenes/enemies/enemy_actor.tscn',
    'client/scenes/player/player_character.tscn',
]


class GodotSceneSerializationTest(unittest.TestCase):
    def test_scene_files_do_not_use_runtime_new_expressions_for_meshes(self):
        invalid = []
        for path in SCENES:
            content = (ROOT / path).read_text(encoding='utf-8')
            if '.new()' in content:
                invalid.append(path)
        self.assertEqual([], invalid, f'Scene files should use serialized sub-resources instead of .new(): {invalid}')


if __name__ == '__main__':
    unittest.main()
