extends Node
class_name EquipmentService

signal equipment_changed(slot: int, item: Dictionary)
signal stat_bonuses_changed(bonuses: Dictionary)

enum EquipmentSlot {
	HEAD,
	CHEST,
	LEGS,
	FEET,
	HANDS,
	WEAPON_MAIN,
	WEAPON_OFF,
	NECK,
	RING_1,
	RING_2,
}

var equipped_items: Dictionary = {}
var stat_bonuses: Dictionary = {
	"strength": 0,
	"agility": 0,
	"intellect": 0,
	"stamina": 0,
	"armor": 0,
	"attack": 0,
	"spirit": 0,
}

func _ready() -> void:
	for slot in range(EquipmentSlot.size()):
		equipped_items[slot] = {}

func equip_item(item: Dictionary, slot: int) -> bool:
	if slot < 0 or slot >= EquipmentSlot.size():
		return false
	equipped_items[slot] = item.duplicate(true)
	_calculate_total_bonuses()
	emit_signal("equipment_changed", slot, item)
	return true

func unequip_slot(slot: int) -> Dictionary:
	if slot < 0 or slot >= EquipmentSlot.size():
		return {}
	var item: Dictionary = equipped_items.get(slot, {}).duplicate(true)
	equipped_items[slot] = {}
	_calculate_total_bonuses()
	emit_signal("equipment_changed", slot, {})
	return item

func get_equipped_in_slot(slot: int) -> Dictionary:
	if slot < 0 or slot >= EquipmentSlot.size():
		return {}
	return equipped_items.get(slot, {}).duplicate(true)

func get_all_equipped() -> Dictionary:
	var result: Dictionary = {}
	for slot in equipped_items.keys():
		if not equipped_items[slot].is_empty():
			result[slot] = equipped_items[slot].duplicate(true)
	return result

func calculate_total_bonuses() -> Dictionary:
	return stat_bonuses.duplicate(true)

func _calculate_total_bonuses() -> void:
	stat_bonuses = {
		"strength": 0,
		"agility": 0,
		"intellect": 0,
		"stamina": 0,
		"armor": 0,
		"attack": 0,
		"spirit": 0,
	}
	for slot in equipped_items.values():
		if slot.is_empty():
			continue
		var stats: Dictionary = slot.get("stats", {})
		for stat_name in stats.keys():
			if stat_bonuses.has(stat_name):
				stat_bonuses[stat_name] = int(stat_bonuses.get(stat_name, 0)) + int(stats.get(stat_name, 0))
	emit_signal("stat_bonuses_changed", stat_bonuses.duplicate(true))

func build_snapshot() -> Dictionary:
	return {
		"equipped": get_all_equipped(),
		"bonuses": stat_bonuses.duplicate(true),
	}

func toggle_equipment_panel() -> bool:
	var current_state: bool = bool(build_snapshot().get("equipment_open", false))
	return not current_state
