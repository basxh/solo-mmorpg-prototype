extends CanvasLayer

@onready var status_label: Label = $MarginContainer/StatusLabel

func apply_combat_feedback(snapshot: Dictionary) -> void:
	if snapshot.is_empty():
		visible = false
		return
	visible = true
	status_label.text = snapshot.get("message", "Combat ready")
