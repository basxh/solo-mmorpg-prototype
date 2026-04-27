import json
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]

REQUIRED_PATHS = [
    'client/scenes/ui/action_bar.tscn',
    'client/scenes/ui/quest_tracker.tscn',
    'client/scripts/combat/combat_service.gd',
    'client/scripts/ui/action_bar.gd',
    'client/scripts/ui/quest_tracker.gd',
    'client/scripts/quests/quest_state_service.gd',
    'client/content/abilities/starter_abilities.json',
    'client/content/quests/starter_chain.json',
]


class CombatQuestScaffoldTest(unittest.TestCase):
    def test_required_combat_quest_files_exist(self):
        missing = [path for path in REQUIRED_PATHS if not (ROOT / path).exists()]
        self.assertEqual([], missing, f'Missing combat/quest scaffold paths: {missing}')

    def test_starter_ability_and_quest_counts(self):
        abilities = json.loads((ROOT / 'client/content/abilities/starter_abilities.json').read_text(encoding='utf-8'))
        quests = json.loads((ROOT / 'client/content/quests/starter_chain.json').read_text(encoding='utf-8'))
        self.assertGreaterEqual(len(abilities['abilities']), 2)
        self.assertGreaterEqual(len(quests['quests']), 3)


if __name__ == '__main__':
    unittest.main()
