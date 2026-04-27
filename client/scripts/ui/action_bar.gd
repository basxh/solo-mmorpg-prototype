extends CanvasLayer

@onready var slot_one_label: Label = $MarginContainer/HBoxContainer/SlotOneLabel
@onready var slot_two_label: Label = $MarginContainer/HBoxContainer/SlotTwoLabel
@onready var cooldown_label: Label = $MarginContainer/HBoxContainer/CooldownLabel
@onready var queued_label: Label = $MarginContainer/HBoxContainer/QueuedLabel

func apply_combat_snapshot(snapshot: Dictionary) -> void:
	var slots: Array = snapshot.get("ability_slots", [])
	var cooldowns: Dictionary = snapshot.get("cooldowns", {})
	var slot_one := str(slots[0] if slots.size() > 0 else "-")
	var slot_two := str(slots[1] if slots.size() > 1 else "-")
	slot_one_label.text = "1: %s" % slot_one
	slot_two_label.text = "2: %s" % slot_two
	cooldown_label.text = "cooldowns %s %.1fs | %s %.1fs" % [slot_one, float(cooldowns.get(slot_one, 0.0)), slot_two, float(cooldowns.get(slot_two, 0.0))]
	queued_label.text = "queued: %s" % snapshot.get("queued_ability_id", "-")
