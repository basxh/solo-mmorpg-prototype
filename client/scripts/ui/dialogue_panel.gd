extends CanvasLayer

@onready var speaker_label: Label = $MarginContainer/VBoxContainer/SpeakerLabel
@onready var body_label: Label = $MarginContainer/VBoxContainer/BodyLabel

func apply_dialogue_snapshot(snapshot: Dictionary) -> void:
	if snapshot.is_empty():
		visible = false
		return
	visible = true
	speaker_label.text = snapshot.get("npc_id", "Unknown").replace("_", " ").capitalize()
	body_label.text = snapshot.get("greeting", "...")
