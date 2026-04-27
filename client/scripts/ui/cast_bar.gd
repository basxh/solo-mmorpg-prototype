extends CanvasLayer

@onready var cast_name_label: Label = $MarginContainer/VBoxContainer/CastNameLabel
@onready var cast_progress_label: Label = $MarginContainer/VBoxContainer/CastProgressLabel

func apply_cast_snapshot(snapshot: Dictionary) -> void:
	var cast_name: String = str(snapshot.get("cast_name", ""))
	if cast_name.is_empty():
		visible = false
		return
	visible = true
	cast_name_label.text = "Casting: %s" % cast_name
	cast_progress_label.text = "%.1f / %.1fs" % [float(snapshot.get("cast_progress", 0.0)), float(snapshot.get("cast_duration", 0.0))]
