extends Node
class_name LootTableService

signal loot_generated(enemy_id: String, loot: Array)

var loot_tables: Dictionary = {}
var loot_table_data: Dictionary = {}

func _ready() -> void:
	_load_loot_tables()

func _load_loot_tables() -> void:
	var file: FileAccess = FileAccess.open("res://content/items/loot_tables.json", FileAccess.READ)
	if file:
		var json_string: String = file.get_as_text()
		var json: JSON = JSON.new()
		var parse_result: int = json.parse(json_string)
		if parse_result == OK:
			var data: Dictionary = json.get_data()
			loot_table_data = data.get("loot_tables", {})
		file.close()
	else:
		push_warning("LootTableService: Could not load loot_tables.json")

func get_loot_for_enemy(enemy_id: String) -> Array:
	var entries: Array = loot_table_data.get(enemy_id, [])
	var result: Array = []
	
	for entry in entries:
		var drop_chance: float = entry.get("drop_chance", 0.0)
		if _roll_drop_chance(drop_chance):
			var min_qty: int = entry.get("min_quantity", 1)
			var max_qty: int = entry.get("max_quantity", min_qty)
			var quantity: int = randi_range(min_qty, max_qty)
			result.append({
				"item_id": entry.get("item_id", ""),
				"quantity": quantity,
				"name": entry.get("name", entry.get("item_id", "Unknown")),
				"rarity": entry.get("rarity", "common"),
				"stats": entry.get("stats", {}),
				"slot": entry.get("slot", "")
			})
	
	emit_signal("loot_generated", enemy_id, result)
	return result

func _roll_drop_chance(chance: float) -> bool:
	return randf() * 100.0 <= chance

func roll_loot(enemy_id: String) -> Array:
	return get_loot_for_enemy(enemy_id)

func get_drop_rate(item_id: String, enemy_id: String) -> float:
	var entries: Array = loot_table_data.get(enemy_id, [])
	for entry in entries:
		if entry.get("item_id", "") == item_id:
			return entry.get("drop_chance", 0.0)
	return 0.0

func generate_loot(enemy_id: String, enemy_level: int = 1) -> Array:
	var base_loot: Array = get_loot_for_enemy(enemy_id)
	
	# Could apply level-based modifiers here
	for item in base_loot:
		item["source_level"] = enemy_level
	
	return base_loot

func has_loot_table(enemy_id: String) -> bool:
	return loot_table_data.has(enemy_id)

func get_all_loot_table_ids() -> Array:
	return loot_table_data.keys()

func reload_loot_tables() -> void:
	_load_loot_tables()
