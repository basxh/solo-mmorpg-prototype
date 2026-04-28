extends Area3D
class_name LootDropActor

signal loot_taken(all_items_taken: bool)
signal interacted(by_player: Node3D)

@export var drop_owner_id: String = ""
@export var drop_owner_name: String = "Loot"
@export var auto_despawn_time: float = 120.0  # 2 minutes

var loot_items: Array = []
var is_lootable: bool = true
var was_looted: bool = false

var _despawn_timer: float = 0.0
var _interaction_service: Node = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_input_actions()

func _input_actions() -> void:
	# Set up collision layers for interaction
	collision_layer = 8  # Loot layer
	collision_mask = 2   # Player layer

func _process(delta: float) -> void:
	_despawn_timer += delta
	if _despawn_timer >= auto_despawn_time:
		queue_free()

func set_loot_items(items: Array) -> void:
	loot_items = items.duplicate(true)
	is_lootable = loot_items.size() > 0

func add_loot_item(item: Dictionary) -> void:
	loot_items.append(item.duplicate(true))
	is_lootable = true

func can_loot() -> bool:
	return is_lootable and not was_looted and loot_items.size() > 0

func interact(by_player: Node3D) -> bool:
	if not can_loot():
		return false
	
	was_looted = true
	emit_signal("interacted", by_player)
	
	# Give loot to player's inventory
	var inventory_service: Node = by_player.get("inventory_service") if by_player.has("inventory_service") else null
	
	if inventory_service:
		var taken_all: bool = true
		for item in loot_items:
			var result: Dictionary = inventory_service.add_item(
				item.get("item_id", ""),
				item.get("quantity", 1),
				item
			)
			if not result.get("success", false):
				taken_all = false
			break
		
		emit_signal("loot_taken", taken_all)
		
		# If all items taken, despawn
		if taken_all:
			queue_free()
			return true
	else:
		# No inventory service, just mark as looted
		emit_signal("loot_taken", false)
	
	return true

func loot_all(by_player: Node3D) -> Dictionary:
	var result: Dictionary = {
		"items": [],
		"failed": [],
		"success": false
	}
	
	if not can_loot():
		return result
	
	var inventory_service: Node = by_player.get("inventory_service") if by_player.has("inventory_service") else null
	if not inventory_service:
		return result
	
	was_looted = true
	
	for item in loot_items:
		var add_result: Dictionary = inventory_service.add_item(
			item.get("item_id", ""),
			item.get("quantity", 1),
			item
		)
		if add_result.get("success", false):
			result["items"].append(item)
		else:
			result["failed"].append(item)
	
	is_lootable = result["failed"].size() > 0
	result["success"] = result["items"].size() > 0
	
	emit_signal("loot_taken", result["failed"].size() == 0)
	emit_signal("interacted", by_player)
	
	if result["failed"].size() == 0:
		queue_free()
	else:
		# Remove taken items from loot
		loot_items = result["failed"].duplicate(true)
	
	return result

func get_loot_info() -> Dictionary:
	return {
		"drop_owner_id": drop_owner_id,
		"drop_owner_name": drop_owner_name,
		"items": loot_items.duplicate(true),
		"can_loot": can_loot(),
		"is_lootable": is_lootable
	}

func _on_body_entered(body: Node3D) -> void:
	# Could trigger auto-loot on proximity if configured
	pass

func get_interaction_prompt() -> String:
	if loot_items.size() == 1:
		return "Loot %s (%s)" % [loot_items[0].get("name", "Item"), drop_owner_name]
	return "Loot %s (%d items)" % [drop_owner_name, loot_items.size()]
