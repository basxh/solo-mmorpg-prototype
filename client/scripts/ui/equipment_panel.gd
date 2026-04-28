extends CanvasLayer
class_name EquipmentPanel

@onready var margin_container: MarginContainer = $MarginContainer
@onready var grid_container: GridContainer = $MarginContainer/VBoxContainer/GridContainer

var equipment_slots: Dictionary = {}

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

func _ready() -> void:
	_initialize_slots()
	visible = false

func _initialize_slots() -> void:
	# Equipment slots are initialized by the scene layout
	pass

func update_slot(slot_type: int, item: Dictionary) -> void:
	if equipment_slots.has(slot_type):
		var slot_ui = equipment_slots[slot_type]
		if item.is_empty():
			slot_ui.clear_slot()
		else:
			slot_ui.set_item(item)

func apply_equipment_snapshot(snapshot: Dictionary) -> void:
	var equipped: Dictionary = snapshot.get("equipped", {})
	for slot_type in equipped.keys():
		update_slot(int(slot_type), equipped.get(slot_type, {}))
	visible = snapshot.get("equipment_open", false)

func open_panel() -> void:
	visible = true

func close_panel() -> void:
	visible = false

func toggle_visibility() -> void:
	visible = not visible
