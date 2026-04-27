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

func cycle_target(player_position: Vector3, targets: Array, current_target_id: String = "") -> Dictionary:
	if targets.is_empty():
		clear_target()
		return current_target

	var sorted_targets := targets.duplicate()
	sorted_targets.sort_custom(func(a, b):
		return player_position.distance_to(a.get("position", Vector3.ZERO)) < player_position.distance_to(b.get("position", Vector3.ZERO))
	)

	var next_index := 0
	for index in range(sorted_targets.size()):
		if sorted_targets[index].get("id", "") == current_target_id:
			next_index = (index + 1) % sorted_targets.size()
			break
	set_target(sorted_targets[next_index])
	return current_target
