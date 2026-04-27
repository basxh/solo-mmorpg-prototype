import pathlib
import re
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
SCRIPT_ROOT = ROOT / 'client' / 'scripts'
VAR_INFERENCE_PATTERN = re.compile(
    r'^(?:\s*@\w+(?:\([^\n]*\))?\s+)*(?:\s*static\s+)?var\s+[^:\n]+(?:\s*:=\s*|\s*=\s*)',
    re.MULTILINE,
)


class GodotVariantInferenceRegressionTest(unittest.TestCase):
    def test_runtime_scripts_avoid_variant_style_inference_operator_for_variables(self):
        offenders = []
        for path in SCRIPT_ROOT.rglob('*.gd'):
            content = path.read_text(encoding='utf-8')
            if VAR_INFERENCE_PATTERN.search(content):
                offenders.append(str(path.relative_to(ROOT)))
        self.assertEqual([], offenders, f'Use explicit typing instead of := for GDScript variables: {offenders}')


if __name__ == '__main__':
    unittest.main()
