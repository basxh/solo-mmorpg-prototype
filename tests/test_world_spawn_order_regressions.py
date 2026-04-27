import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]


class WorldSpawnOrderRegressionTest(unittest.TestCase):
    def test_world_root_adds_spawned_nodes_before_applying_snapshots(self):
        script = (ROOT / 'client/scripts/bootstrap/world_root.gd').read_text(encoding='utf-8')
        self.assertIn('marker_container.add_child(marker)\n\t\tmarker.call("apply_snapshot", point)', script)
        self.assertIn('npc_container.add_child(npc)\n\t\t\tnpc.call("apply_snapshot", point)', script)
        self.assertIn('enemy_container.add_child(enemy)\n\t\t\tenemy.call("apply_snapshot", point)', script)


if __name__ == '__main__':
    unittest.main()
