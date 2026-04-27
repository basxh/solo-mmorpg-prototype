import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
FILES = [
    'client/scripts/bootstrap/world_root.gd',
    'client/scripts/combat/combat_service.gd',
    'client/scripts/interactions/interaction_service.gd',
    'client/scripts/world/zone_loader.gd',
]


class GodotVariantInferenceRegressionTest(unittest.TestCase):
    def test_runtime_scripts_avoid_variant_style_inference_operator(self):
        offenders = []
        for path in FILES:
            content = (ROOT / path).read_text(encoding='utf-8')
            if ':=' in content:
                offenders.append(path)
        self.assertEqual([], offenders, f'Use explicit typing instead of := in Godot scripts: {offenders}')


if __name__ == '__main__':
    unittest.main()
