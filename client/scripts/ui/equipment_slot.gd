extends Panel
class_name EquipmentSlotUI

@onready var slot_icon: TextureRect = $SlotIcon
@onready var slot_label: Label = $SlotLabel

var slot_type: int = -1
var current_item: Dictionary = {}

func _ready() -> void:
	if slot_icon == null:
		slot_icon = TextureRect.new()
		add_child(slot_icon)
	if slot_label == null:
		slot_label = Label.new()
		add_child(slot_label)
	clear_slot()

func set_slot_type(new_slot_type: int) -> void:
	slot_type = new_slot_type
	_update_slot_label()

func set_item(item: Dictionary) -> void:
	current_item = item.duplicate(true)
	_update_visuals()

func clear_slot() -> void:
	current_item = {}
	_update_visuals()

func _update_slot_label() -> void:
	var slot_names: Dictionary = {
		0: "Head",
		1: "Chest",
		2: "Legs",
		3: "Feet",
		4: "Hands",
		5: "Main Hand",
		6: "Off Hand",
		7: "Neck",
		8: "Ring 1",
		9: "Ring 2",
	}
	if slot_label:
		slot_label.text = slot_names.get(slot_type, "Unknown")

func _update_visuals() -> void:
	if current_item.is_empty():
		if slot_label:
			slot_label.text = "Empty"
	else:
		if slot_label:
			var item_name: String = current_item.get("name", "Unknown Item")
			slot_label.text = item_name
