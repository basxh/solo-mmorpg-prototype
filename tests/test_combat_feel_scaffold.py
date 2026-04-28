import json
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]

REQUIRED_PATHS = [
    'client/scripts/combat/combat_feel_service.gd',
    'client/scripts/player/hit_reaction_component.gd',
    'client/scripts/ui/floating_text_service.gd',
]


class CombatFeelScaffoldTest(unittest.TestCase):
    def test_required_combat_feel_files_exist(self):
        missing = [path for path in REQUIRED_PATHS if not (ROOT / path).exists()]
        self.assertEqual([], missing, f'Missing combat feel scaffold paths: {missing}')

    def test_combat_feel_service_exists_and_manages_shake_hitstop(self):
        combat_feel = (ROOT / 'client/scripts/combat/combat_feel_service.gd').read_text(encoding='utf-8')
        self.assertIn('screen_shake_magnitude', combat_feel)
        self.assertIn('screen_shake_duration', combat_feel)
        self.assertIn('screen_shake_decay', combat_feel)
        self.assertIn('hitstop_duration', combat_feel)
        self.assertIn('hitstop_active', combat_feel)
        self.assertIn('start_screen_shake', combat_feel)
        self.assertIn('start_hitstop', combat_feel)
        self.assertIn('apply_combat_feel', combat_feel)
        self.assertIn('get_camera_offset', combat_feel)
        self.assertIn('is_hitstop_active', combat_feel)

    def test_hit_reaction_component_exists_for_player(self):
        hit_reaction = (ROOT / 'client/scripts/player/hit_reaction_component.gd').read_text(encoding='utf-8')
        self.assertIn('flash_duration', hit_reaction)
        self.assertIn('knockback_force', hit_reaction)
        self.assertIn('flash_on_hit', hit_reaction)
        self.assertIn('apply_hit_reaction', hit_reaction)
        self.assertIn('damage_taken', hit_reaction)

    def test_follow_camera_rig_has_shake_integration(self):
        camera_rig = (ROOT / 'client/scripts/world/follow_camera_rig.gd').read_text(encoding='utf-8')
        self.assertIn('combat_feel_service', camera_rig)
        self.assertIn('apply_camera_offset', camera_rig)
        self.assertIn('shake_offset', camera_rig)

    def test_world_root_wires_combat_feel_events(self):
        world_root = (ROOT / 'client/scripts/bootstrap/world_root.gd').read_text(encoding='utf-8')
        self.assertIn('CombatFeelService', world_root)
        self.assertIn('combat_feel_service', world_root)
        self.assertIn('on_damage_dealt', world_root)
        self.assertIn('on_damage_taken', world_root)
        self.assertIn('combat_feel', world_root)

    def test_floating_text_service_exists(self):
        floating_text = (ROOT / 'client/scripts/ui/floating_text_service.gd').read_text(encoding='utf-8')
        self.assertIn('spawn_damage_number', floating_text)
        self.assertIn('spawn_floating_text', floating_text)

    def test_combat_service_emits_combat_events_for_feel(self):
        combat_service = (ROOT / 'client/scripts/combat/combat_service.gd').read_text(encoding='utf-8')
        self.assertIn('damage_dealt', combat_service)
        self.assertIn('damage_taken', combat_service)
        self.assertIn('emit_signal', combat_service)


if __name__ == '__main__':
    unittest.main()
