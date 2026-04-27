extends CanvasLayer

@onready var slot_one_label: Label = $MarginContainer/HBoxContainer/SlotOneLabel
@onready var slot_two_label: Label = $MarginContainer/HBoxContainer/SlotTwoLabel

func apply_combat_snapshot(snapshot: Dictionary) -> void:
	var slots: Array = snapshot.get("ability_slots", [])
	slot_one_label.text = "1: %s" % (slots[0] if slots.size() > 0 else "-")
	slot_two_label.text = "2: %s" % (slots[1] if slots.size() > 1 else "-")
