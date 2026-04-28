extends Node
class_name InventoryService

const EquipmentService = preload("res://scripts/equipment/equipment_service.gd")

signal inventory_changed(slot_index: int, item: Dictionary)
signal item_added(item_id: String, quantity: int, slot_index: int)
signal item_removed(item_id: String, quantity: int, slot_index: int)
signal stack_split(from_slot: int, to_slot: int, quantity: int)
signal item_equipped(slot: int, item: Dictionary)

const INVENTORY_ROWS: int = 5
const INVENTORY_COLS: int = 6
const INVENTORY_SIZE: int = INVENTORY_ROWS * INVENTORY_COLS

var inventory_grid: Array = []
var equipment_service: EquipmentService = null

func _ready() -> void:
	_initialize_grid()

func _initialize_grid() -> void:
	inventory_grid.resize(INVENTORY_SIZE)
	for i in range(INVENTORY_SIZE):
		inventory_grid[i] = {}

func set_equipment_service(equipment_serv: EquipmentService) -> void:
	equipment_service = equipment_serv

func get_slot_index(row: int, col: int) -> int:
	return row * INVENTORY_COLS + col

func get_slot_position(slot_index: int) -> Dictionary:
	return {
		"row": slot_index / INVENTORY_COLS,
		"col": slot_index % INVENTORY_COLS
	}

func is_slot_empty(slot_index: int) -> bool:
	if slot_index < 0 or slot_index >= INVENTORY_SIZE:
		return false
	return inventory_grid[slot_index].is_empty()

func get_item_at(slot_index: int) -> Dictionary:
	if slot_index < 0 or slot_index >= INVENTORY_SIZE:
		return {}
	return inventory_grid[slot_index].duplicate(true)

func add_item(item_id: String, quantity: int = 1, item_data: Dictionary = {}) -> Dictionary:
	# Try to stack with existing items first
	for i in range(INVENTORY_SIZE):
		if not inventory_grid[i].is_empty():
			if inventory_grid[i].get("item_id") == item_id:
				var current_qty: int = inventory_grid[i].get("quantity", 1)
				var max_stack: int = inventory_grid[i].get("max_stack", 1)
				if current_qty < max_stack:
					var space: int = max_stack - current_qty
					var to_add: int = mini(quantity, space)
					inventory_grid[i]["quantity"] = current_qty + to_add
					quantity -= to_add
					emit_signal("inventory_changed", i, inventory_grid[i].duplicate(true))
					if quantity <= 0:
						emit_signal("item_added", item_id, item_data.get("original_quantity", quantity), i)
						return {"success": true, "slot": i, "remaining": 0}
	
	# Find empty slot for remaining quantity
	var empty_slot: int = find_empty_slot()
	if empty_slot >= 0:
		inventory_grid[empty_slot] = {
			"item_id": item_id,
			"quantity": quantity,
			"max_stack": item_data.get("max_stack", 99),
			"name": item_data.get("name", item_id),
			"slot": item_data.get("slot", ""),
			"stats": item_data.get("stats", {}),
			"rarity": item_data.get("rarity", "common"),
			"original_quantity": item_data.get("original_quantity", quantity)
		}
		emit_signal("inventory_changed", empty_slot, inventory_grid[empty_slot].duplicate(true))
		emit_signal("item_added", item_id, quantity, empty_slot)
		return {"success": true, "slot": empty_slot, "remaining": 0}
	
	return {"success": false, "slot": -1, "remaining": quantity}

func remove_item(slot_index: int, quantity: int = -1) -> Dictionary:
	if slot_index < 0 or slot_index >= INVENTORY_SIZE:
		return {}
	
	var item: Dictionary = inventory_grid[slot_index].duplicate(true)
	if item.is_empty():
		return {}
	
	var item_id: String = item.get("item_id", "")
	var current_qty: int = item.get("quantity", 1)
	
	if quantity < 0 or quantity >= current_qty:
		# Remove all
		var removed: Dictionary = inventory_grid[slot_index].duplicate(true)
		inventory_grid[slot_index] = {}
		emit_signal("inventory_changed", slot_index, {})
		emit_signal("item_removed", item_id, removed.get("quantity", 1), slot_index)
		return removed
	else:
		# Remove partial
		inventory_grid[slot_index]["quantity"] = current_qty - quantity
		emit_signal("inventory_changed", slot_index, inventory_grid[slot_index].duplicate(true))
		emit_signal("item_removed", item_id, quantity, slot_index)
		return {"item_id": item_id, "quantity": quantity}

func swap_slots(from_slot: int, to_slot: int) -> bool:
	if from_slot < 0 or from_slot >= INVENTORY_SIZE or to_slot < 0 or to_slot >= INVENTORY_SIZE:
		return false
	
	var temp: Dictionary = inventory_grid[from_slot].duplicate(true)
	inventory_grid[from_slot] = inventory_grid[to_slot].duplicate(true)
	inventory_grid[to_slot] = temp
	
	emit_signal("inventory_changed", from_slot, inventory_grid[from_slot].duplicate(true))
	emit_signal("inventory_changed", to_slot, inventory_grid[to_slot].duplicate(true))
	return true

func split_stack(from_slot: int, quantity: int) -> int:
	if from_slot < 0 or from_slot >= INVENTORY_SIZE:
		return -1
	
	var item: Dictionary = inventory_grid[from_slot]
	if item.is_empty():
		return -1
	
	var current_qty: int = item.get("quantity", 1)
	if quantity >= current_qty or quantity <= 0:
		return -1
	
	var empty_slot: int = find_empty_slot()
	if empty_slot < 0:
		return -1
	
	# Split the stack
	inventory_grid[from_slot]["quantity"] = current_qty - quantity
	var new_stack: Dictionary = item.duplicate(true)
	new_stack["quantity"] = quantity
	inventory_grid[empty_slot] = new_stack
	
	emit_signal("inventory_changed", from_slot, inventory_grid[from_slot].duplicate(true))
	emit_signal("inventory_changed", empty_slot, inventory_grid[empty_slot].duplicate(true))
	emit_signal("stack_split", from_slot, empty_slot, quantity)
	return empty_slot

func find_empty_slot() -> int:
	for i in range(INVENTORY_SIZE):
		if inventory_grid[i].is_empty():
			return i
	return -1

func has_space() -> bool:
	return find_empty_slot() >= 0

func can_add_item(item_id: String, quantity: int = 1) -> bool:
	if find_empty_slot() >= 0:
		return true
	# Check if we can stack with existing
	for i in range(INVENTORY_SIZE):
		if not inventory_grid[i].is_empty() and inventory_grid[i].get("item_id") == item_id:
			var current_qty: int = inventory_grid[i].get("quantity", 1)
			var max_stack: int = inventory_grid[i].get("max_stack", 1)
			if current_qty < max_stack:
				return true
	return false

func combine_stacks(from_slot: int, to_slot: int) -> bool:
	if from_slot < 0 or from_slot >= INVENTORY_SIZE or to_slot < 0 or to_slot >= INVENTORY_SIZE:
		return false
	if from_slot == to_slot:
		return false
	
	var from_item: Dictionary = inventory_grid[from_slot]
	var to_item: Dictionary = inventory_grid[to_slot]
	
	if from_item.is_empty() or to_item.is_empty():
		return false
	
	if from_item.get("item_id") != to_item.get("item_id"):
		return false
	
	var from_qty: int = from_item.get("quantity", 1)
	var to_qty: int = to_item.get("quantity", 1)
	var max_stack: int = to_item.get("max_stack", 1)
	
	var space: int = max_stack - to_qty
	if space <= 0:
		return false
	
	var to_move: int = mini(from_qty, space)
	inventory_grid[to_slot]["quantity"] = to_qty + to_move
	
	if from_qty <= to_move:
		inventory_grid[from_slot] = {}
		emit_signal("inventory_changed", from_slot, {})
	else:
		inventory_grid[from_slot]["quantity"] = from_qty - to_move
		emit_signal("inventory_changed", from_slot, inventory_grid[from_slot].duplicate(true))
	
	emit_signal("inventory_changed", to_slot, inventory_grid[to_slot].duplicate(true))
	return true

func is_equippable(item: Dictionary) -> bool:
	var slot: String = item.get("slot", "")
	return slot in ["head", "chest", "legs", "feet", "hands", "weapon", "boots", "trinket", "offhand", "ring"]

func can_equip(item: Dictionary) -> Dictionary:
	if not is_equippable(item):
		return {"can": false, "reason": "not_equippable"}
	if equipment_service == null:
		return {"can": false, "reason": "no_equipment_service"}
	return {"can": true, "reason": ""}

func equip_item(slot_index: int) -> bool:
	if slot_index < 0 or slot_index >= INVENTORY_SIZE:
		return false
	if equipment_service == null:
		return false
	
	var item: Dictionary = inventory_grid[slot_index]
	if item.is_empty():
		return false
	
	if not is_equippable(item):
		return false
	
	# Map item slot to equipment slot
	var item_slot: String = item.get("slot", "")
	var equip_slot: int = _map_slot_to_equipment(item_slot)
	if equip_slot < 0:
		return false
	
	# Unequip current if any and return to inventory
	var current_equipped: Dictionary = equipment_service.get_equipped_in_slot(equip_slot)
	if not current_equipped.is_empty():
		# Try to add back to inventory
		if not add_item_from_equipment(current_equipped):
			return false
	
	# Equip the item
	var success: bool = equipment_service.equip_item(item.duplicate(true), equip_slot)
	if success:
		inventory_grid[slot_index] = {}
		emit_signal("inventory_changed", slot_index, {})
		emit_signal("item_equipped", equip_slot, item.duplicate(true))
	return success

func add_item_from_equipment(item: Dictionary) -> bool:
	var result: Dictionary = add_item(
		item.get("id", "unknown"),
		1,
		item
	)
	return result.get("success", false)

func _map_slot_to_equipment(item_slot: String) -> int:
	match item_slot:
		"head": return EquipmentService.EquipmentSlot.HEAD
		"chest": return EquipmentService.EquipmentSlot.CHEST
		"legs": return EquipmentService.EquipmentSlot.LEGS
		"feet", "boots": return EquipmentService.EquipmentSlot.FEET
		"hands": return EquipmentService.EquipmentSlot.HANDS
		"weapon": return EquipmentService.EquipmentSlot.WEAPON_MAIN
		"offhand": return EquipmentService.EquipmentSlot.WEAPON_OFF
		"trinket", "neck": return EquipmentService.EquipmentSlot.NECK
		"ring": return EquipmentService.EquipmentSlot.RING_1
		_: return -1

func build_snapshot() -> Dictionary:
	var items: Array = []
	for i in range(INVENTORY_SIZE):
		if not inventory_grid[i].is_empty():
			var pos: Dictionary = get_slot_position(i)
			var item: Dictionary = inventory_grid[i].duplicate(true)
			item["slot_index"] = i
			item["row"] = pos.row
			item["col"] = pos.col
			items.append(item)
	return {
		"items": items,
		"size": INVENTORY_SIZE,
		"rows": INVENTORY_ROWS,
		"cols": INVENTORY_COLS
	}

func apply_snapshot(snapshot: Dictionary) -> void:
	_initialize_grid()
	for item in snapshot.get("items", []):
		var slot_index: int = item.get("slot_index", -1)
		if slot_index >= 0 and slot_index < INVENTORY_SIZE:
			inventory_grid[slot_index] = item.duplicate(true)
			emit_signal("inventory_changed", slot_index, inventory_grid[slot_index])
