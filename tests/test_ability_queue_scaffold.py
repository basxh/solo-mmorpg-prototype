import json
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]

REQUIRED_PATHS = [
    'client/scenes/ui/cast_bar.tscn',
    'client/scripts/ui/cast_bar.gd',
    'client/scripts/abilities/ability_queue_service.gd',
]


class AbilityQueueScaffoldTest(unittest.TestCase):
    def test_required_ability_queue_files_exist(self):
        missing = [path for path in REQUIRED_PATHS if not (ROOT / path).exists()]
        self.assertEqual([], missing, f'Missing ability queue scaffold paths: {missing}')

    def test_combat_service_tracks_cooldowns_and_queue_state(self):
        combat_service = (ROOT / 'client/scripts/combat/combat_service.gd').read_text(encoding='utf-8')
        self.assertIn('cooldowns', combat_service)
        self.assertIn('queued_ability_id', combat_service)
        self.assertIn('queue_window_seconds', combat_service)
        self.assertIn('queue_expires_at', combat_service)
        self.assertIn('queue_ability', combat_service)
        self.assertIn('tick_cooldowns', combat_service)
        self.assertIn('consume_queued_ability', combat_service)
        self.assertIn('load_ability_definitions', combat_service)
        self.assertIn('cooldown_seconds', combat_service)
        self.assertIn('cast_time_seconds', combat_service)

    def test_action_bar_and_hud_reference_cast_and_queue_feedback(self):
        action_bar = (ROOT / 'client/scripts/ui/action_bar.gd').read_text(encoding='utf-8')
        game_hud = (ROOT / 'client/scripts/ui/game_hud.gd').read_text(encoding='utf-8')
        self.assertIn('queued', action_bar)
        self.assertIn('cooldown', action_bar)
        self.assertIn('cast_bar', game_hud)

    def test_world_root_wires_direct_active_ability_and_queue_consumption(self):
        world_root = (ROOT / 'client/scripts/bootstrap/world_root.gd').read_text(encoding='utf-8')
        self.assertIn('ability_slot_two', world_root)
        self.assertIn('trigger_slot(1', world_root)
        self.assertIn('consume_queued_ability', world_root)
        self.assertIn('Time.get_ticks_msec', world_root)
        self.assertIn('global_action_remaining', world_root)

    def test_starter_abilities_include_queue_window_and_cast_time(self):
        abilities = json.loads((ROOT / 'client/content/abilities/starter_abilities.json').read_text(encoding='utf-8'))
        for ability in abilities['abilities']:
            self.assertIn('queue_window_seconds', ability)
            self.assertIn('cast_time_seconds', ability)


if __name__ == '__main__':
    unittest.main()
