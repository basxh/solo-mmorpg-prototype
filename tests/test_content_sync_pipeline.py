import json
import pathlib
import subprocess
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]

SYNCED_CLIENT_FILES = [
    'client/content/manifest.json',
    'client/content/zones/starter_zone.json',
    'client/content/points_of_interest/starter_pois.json',
]


class ContentSyncPipelineTest(unittest.TestCase):
    def test_sync_script_exists(self):
        self.assertTrue((ROOT / 'tools/sync_shared_content.py').exists())

    def test_synced_client_content_exists(self):
        missing = [path for path in SYNCED_CLIENT_FILES if not (ROOT / path).exists()]
        self.assertEqual([], missing, f'Missing synced client content: {missing}')

    def test_client_manifest_matches_shared_starter_zone(self):
        client_manifest = json.loads((ROOT / 'client/content/manifest.json').read_text(encoding='utf-8'))
        shared_manifest = json.loads((ROOT / 'shared/content/manifest.json').read_text(encoding='utf-8'))
        self.assertEqual(shared_manifest['starter_zone'], client_manifest['starter_zone'])

    def test_sync_script_runs_cleanly(self):
        result = subprocess.run(
            ['python3', 'tools/sync_shared_content.py'],
            cwd=ROOT,
            capture_output=True,
            text=True,
            check=False,
        )
        self.assertEqual(0, result.returncode, result.stderr or result.stdout)


if __name__ == '__main__':
    unittest.main()
