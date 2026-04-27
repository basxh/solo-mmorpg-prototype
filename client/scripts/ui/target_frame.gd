extends CanvasLayer

@onready var name_label: Label = $MarginContainer/VBoxContainer/NameLabel
@onready var type_label: Label = $MarginContainer/VBoxContainer/TypeLabel

func apply_target(target_snapshot: Dictionary) -> void:
	if target_snapshot.is_empty():
		visible = false
		return
	visible = true
	name_label.text = target_snapshot.get("name", "Unknown")
	type_label.text = target_snapshot.get("type", "Neutral")
