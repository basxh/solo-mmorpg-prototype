import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]


class LoginWorldTransitionRegressionTest(unittest.TestCase):
    def test_session_store_does_not_self_instantiate_via_unresolved_class_name(self):
        session_store = (ROOT / 'client/scripts/world/session_store.gd').read_text(encoding='utf-8')
        self.assertNotIn('SessionStore.new()', session_store)
        self.assertIn('load("res://scripts/world/session_store.gd").new()', session_store)


if __name__ == '__main__':
    unittest.main()
