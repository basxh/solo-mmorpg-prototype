import json
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]

REQUIRED_PATHS = [
    'client/scripts/equipment/equipment_service.gd',
    'client/scenes/ui/equipment_slot.tscn',
    'client/scenes/ui/equipment_panel.tscn',
    'client/scripts/ui/equipment_slot.gd',
    'client/scripts/ui/equipment_panel.gd',
    'client/content/items/starter_items.json',
]


class EquipmentScaffoldTest(unittest.TestCase):
    def test_required_equipment_files_exist(self):
        missing = [path for path in REQUIRED_PATHS if not (ROOT / path).exists()]
        self.assertEqual([], missing, f'Missing equipment scaffold paths: {missing}')

    def test_equipment_service_defines_equipment_slots(self):
        equipment = (ROOT / 'client/scripts/equipment/equipment_service.gd').read_text(encoding='utf-8')
        self.assertIn('EquipmentSlot', equipment)
        self.assertIn('HEAD', equipment)
        self.assertIn('CHEST', equipment)
        self.assertIn('LEGS', equipment)
        self.assertIn('FEET', equipment)
        self.assertIn('HANDS', equipment)
        self.assertIn('WEAPON_MAIN', equipment)
        self.assertIn('WEAPON_OFF', equipment)
        self.assertIn('NECK', equipment)
        self.assertIn('RING_1', equipment)
        self.assertIn('RING_2', equipment)

    def test_equipment_service_manages_equipped_items(self):
        equipment = (ROOT / 'client/scripts/equipment/equipment_service.gd').read_text(encoding='utf-8')
        self.assertIn('equipped_items', equipment)
        self.assertIn('equip_item', equipment)
        self.assertIn('unequip_slot', equipment)
        self.assertIn('get_equipped_in_slot', equipment)
        self.assertIn('get_all_equipped', equipment)

    def test_equipment_service_calculates_stat_bonuses(self):
        equipment = (ROOT / 'client/scripts/equipment/equipment_service.gd').read_text(encoding='utf-8')
        self.assertIn('calculate_total_bonuses', equipment)
        self.assertIn('stat_bonuses', equipment)
        self.assertIn('strength', equipment)
        self.assertIn('agility', equipment)
        self.assertIn('intellect', equipment)
        self.assertIn('stamina', equipment)
        self.assertIn('armor', equipment)
        self.assertIn('attack', equipment)

    def test_equipment_slot_ui_has_slot_type(self):
        slot = (ROOT / 'client/scripts/ui/equipment_slot.gd').read_text(encoding='utf-8')
        self.assertIn('slot_type', slot)
        self.assertIn('EquipmentSlot', slot)
        self.assertIn('set_slot_type', slot)
        self.assertIn('set_item', slot)
        self.assertIn('clear_slot', slot)

    def test_equipment_panel_manages_slots(self):
        panel = (ROOT / 'client/scripts/ui/equipment_panel.gd').read_text(encoding='utf-8')
        self.assertIn('equipment_slots', panel)
        self.assertIn('EquipmentSlot', panel)
        self.assertIn('update_slot', panel)
        self.assertIn('apply_equipment_snapshot', panel)

    def test_item_instance_has_equipment_flag_and_stats(self):
        items = (ROOT / 'client/content/items/starter_items.json').read_text(encoding='utf-8')
        parsed = json.loads(items)
        for item in parsed['items']:
            self.assertIn('slot', item)
            self.assertIn('stats', item)

    def test_game_hud_shows_equipment_button(self):
        game_hud = (ROOT / 'client/scripts/ui/game_hud.gd').read_text(encoding='utf-8')
        self.assertIn('equipment_panel', game_hud)

    def test_world_root_wires_equipment_service(self):
        world_root = (ROOT / 'client/scripts/bootstrap/world_root.gd').read_text(encoding='utf-8')
        self.assertIn('EquipmentService', world_root)
        self.assertIn('equipment_service', world_root)
        self.assertIn('equipment', world_root)
        self.assertIn('equipment_open', world_root)

    def test_equipment_panel_tscn_has_slot_references(self):
        panel_scene = (ROOT / 'client/scenes/ui/equipment_panel.tscn').read_text(encoding='utf-8')
        self.assertIn('EquipmentPanel', panel_scene)
        self.assertIn('equipment_slot', panel_scene.lower())


if __name__ == '__main__':
    unittest.main()
