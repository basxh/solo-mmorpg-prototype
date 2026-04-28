import json
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]

REQUIRED_PATHS = [
    'client/scripts/inventory/inventory_service.gd',
    'client/scripts/inventory/loot_table_service.gd',
    'client/scripts/inventory/loot_drop_actor.gd',
    'client/scenes/ui/inventory_grid_panel.tscn',
    'client/scenes/ui/inventory_slot.tscn',
    'client/scripts/ui/inventory_grid_panel.gd',
    'client/scripts/ui/inventory_slot.gd',
    'client/content/items/loot_tables.json',
]


class InventoryScaffoldTest(unittest.TestCase):
    def test_required_inventory_files_exist(self):
        """Verify all inventory scaffold files exist"""
        missing = [path for path in REQUIRED_PATHS if not (ROOT / path).exists()]
        self.assertEqual([], missing, f'Missing inventory scaffold paths: {missing}')

    def test_inventory_service_defines_inventory_grid(self):
        """InventoryService must define a 2D grid structure with 20-30 slots"""
        inventory = (ROOT / 'client/scripts/inventory/inventory_service.gd').read_text(encoding='utf-8')
        self.assertIn('INVENTORY_ROWS', inventory)
        self.assertIn('INVENTORY_COLS', inventory)
        self.assertIn('inventory_grid', inventory)
        # Check for grid initialization
        self.assertIn('Array', inventory)
        self.assertIn('resize', inventory)

    def test_inventory_service_manages_item_slots(self):
        """InventoryService must have methods for slot management"""
        inventory = (ROOT / 'client/scripts/inventory/inventory_service.gd').read_text(encoding='utf-8')
        self.assertIn('add_item', inventory)
        self.assertIn('remove_item', inventory)
        self.assertIn('get_item_at', inventory)
        self.assertIn('swap_slots', inventory)
        self.assertIn('is_slot_empty', inventory)

    def test_inventory_service_handles_item_stacks(self):
        """InventoryService must support stack splitting and combining"""
        inventory = (ROOT / 'client/scripts/inventory/inventory_service.gd').read_text(encoding='utf-8')
        self.assertIn('split_stack', inventory)
        self.assertIn('combine_stacks', inventory)
        self.assertIn('max_stack', inventory)
        self.assertIn('quantity', inventory)

    def test_inventory_service_signals(self):
        """InventoryService must emit signals for inventory changes"""
        inventory = (ROOT / 'client/scripts/inventory/inventory_service.gd').read_text(encoding='utf-8')
        self.assertIn('inventory_changed', inventory)
        self.assertIn('item_added', inventory)
        self.assertIn('item_removed', inventory)

    def test_inventory_service_can_equip_items(self):
        """InventoryService must integrate with EquipmentService"""
        inventory = (ROOT / 'client/scripts/inventory/inventory_service.gd').read_text(encoding='utf-8')
        self.assertIn('EquipmentSlot', inventory)
        self.assertIn('equip_item', inventory)
        self.assertIn('can_equip', inventory)

    def test_loot_table_service_exists(self):
        """LootTableService must handle enemy drops"""
        loot = (ROOT / 'client/scripts/inventory/loot_table_service.gd').read_text(encoding='utf-8')
        self.assertIn('class_name LootTableService', loot)
        self.assertIn('generate_loot', loot)
        self.assertIn('drop_chance', loot)

    def test_loot_table_service_loads_tables(self):
        """LootTableService must load loot tables from JSON"""
        loot = (ROOT / 'client/scripts/inventory/loot_table_service.gd').read_text(encoding='utf-8')
        self.assertIn('loot_tables', loot)
        self.assertIn('get_loot_for_enemy', loot)

    def test_loot_tables_json_exists(self):
        """Loot tables JSON must exist with drop rate definitions"""
        loot_json = (ROOT / 'client/content/items/loot_tables.json').read_text(encoding='utf-8')
        parsed = json.loads(loot_json)
        self.assertIn('loot_tables', parsed)
        # At least one enemy should have loot defined
        self.assertGreater(len(parsed['loot_tables']), 0)
        # Check required fields in loot entries
        for enemy_id, entries in parsed['loot_tables'].items():
            for entry in entries:
                self.assertIn('item_id', entry)
                self.assertIn('drop_chance', entry)  # percentage 0-100

    def test_loot_drop_actor_exists(self):
        """LootDropActor must be interactable for looting corpses"""
        loot_actor = (ROOT / 'client/scripts/inventory/loot_drop_actor.gd').read_text(encoding='utf-8')
        self.assertIn('extends', loot_actor)
        self.assertIn('loot_items', loot_actor)
        self.assertIn('is_lootable', loot_actor)  # loot state

    def test_loot_drop_interaction(self):
        """LootDropActor must support interaction for looting"""
        loot_actor = (ROOT / 'client/scripts/inventory/loot_drop_actor.gd').read_text(encoding='utf-8')
        self.assertIn('interact', loot_actor)
        self.assertIn('loot_all', loot_actor)

    def test_inventory_slot_ui(self):
        """InventorySlot UI must display items and support drag-drop"""
        slot = (ROOT / 'client/scripts/ui/inventory_slot.gd').read_text(encoding='utf-8')
        self.assertIn('slot_index', slot)
        self.assertIn('set_item', slot)
        self.assertIn('clear_slot', slot)
        self.assertIn('get_drag_data', slot)
        self.assertIn('can_drop_data', slot)
        self.assertIn('drop_data', slot)

    def test_inventory_grid_panel(self):
        """InventoryGridPanel must manage the slot grid"""
        panel = (ROOT / 'client/scripts/ui/inventory_grid_panel.gd').read_text(encoding='utf-8')
        self.assertIn('inventory_slots', panel)
        self.assertIn('update_slot', panel)
        self.assertIn('apply_inventory_snapshot', panel)
        self.assertIn('toggle_inventory', panel)

    def test_inventory_grid_panel_tscn_exists(self):
        """InventoryGridPanel scene must exist with slot references"""
        panel_scene = (ROOT / 'client/scenes/ui/inventory_grid_panel.tscn').read_text(encoding='utf-8')
        self.assertIn('InventoryGridPanel', panel_scene)
        self.assertIn('inventory_slot', panel_scene.lower())

    def test_inventory_slot_tscn_exists(self):
        """InventorySlot scene must exist with button/icon nodes"""
        slot_scene = (ROOT / 'client/scenes/ui/inventory_slot.tscn').read_text(encoding='utf-8')
        self.assertIn('InventorySlot', slot_scene)

    def test_game_hud_shows_inventory(self):
        """GameHUD must reference inventory panel"""
        game_hud = (ROOT / 'client/scripts/ui/game_hud.gd').read_text(encoding='utf-8')
        self.assertIn('inventory_panel', game_hud)

    def test_world_root_wires_inventory_service(self):
        """WorldRoot must wire InventoryService"""
        world_root = (ROOT / 'client/scripts/bootstrap/world_root.gd').read_text(encoding='utf-8')
        self.assertIn('InventoryService', world_root)
        self.assertIn('inventory_service', world_root)

    def test_player_character_auto_loot(self):
        """PlayerCharacter must support auto-loot keybind"""
        player = (ROOT / 'client/scripts/player/player_character.gd').read_text(encoding='utf-8')
        self.assertIn('auto_loot', player)
        self.assertIn('Input', player)  # For keybind handling

    def test_enemy_actor_creates_loot_drop(self):
        """EnemyActor must create loot drop on death"""
        enemy = (ROOT / 'client/scripts/enemies/enemy_actor.gd').read_text(encoding='utf-8')
        self.assertIn('LootDropScene.instantiate()', enemy)
        self.assertIn('_on_death', enemy)

    def test_inventory_slot_splitting_ui(self):
        """InventorySlot must support shift-click splitting"""
        slot = (ROOT / 'client/scripts/ui/inventory_slot.gd').read_text(encoding='utf-8')
        self.assertIn('stack_split_requested', slot)  # Shift-click split signal

    def test_inventory_service_has_find_empty_slot(self):
        """InventoryService must find empty slots for looting"""
        inventory = (ROOT / 'client/scripts/inventory/inventory_service.gd').read_text(encoding='utf-8')
        self.assertIn('find_empty_slot', inventory)
        self.assertIn('has_space', inventory)


if __name__ == '__main__':
    unittest.main()
