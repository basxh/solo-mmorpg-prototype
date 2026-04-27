extends Node
class_name TargetingService

signal target_changed(target_snapshot: Dictionary)

var current_target: Dictionary = {}

func set_target(target_snapshot: Dictionary) -> void:
	current_target = target_snapshot.duplicate(true)
	emit_signal("target_changed", current_target)

func clear_target() -> void:
	current_target = {}
	emit_signal("target_changed", current_target)
