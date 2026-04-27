import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]


class WorldSceneLoadRegressionTest(unittest.TestCase):
    def test_world_root_scene_uses_serialized_ground_mesh(self):
        scene = (ROOT / 'client/scenes/bootstrap/world_root.tscn').read_text(encoding='utf-8')
        self.assertNotIn('PlaneMesh.new()', scene)
        self.assertIn('sub_resource type="PlaneMesh"', scene)

    def test_world_root_script_does_not_reference_custom_class_names_in_type_annotations(self):
        script = (ROOT / 'client/scripts/bootstrap/world_root.gd').read_text(encoding='utf-8')
        self.assertNotIn(': FollowCameraRig', script)
        self.assertNotIn(': NpcActor', script)
        self.assertNotIn(': EnemyActor', script)


if __name__ == '__main__':
    unittest.main()
