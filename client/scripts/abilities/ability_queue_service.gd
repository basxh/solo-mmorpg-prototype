extends Node
class_name AbilityQueueService

signal ability_queued(snapshot: Dictionary)

var current_snapshot: Dictionary = {
	"queued_ability_id": "",
	"queue_window_seconds": 0.35,
}

func queue_ability(ability_id: String) -> Dictionary:
	current_snapshot["queued_ability_id"] = ability_id
	emit_signal("ability_queued", current_snapshot)
	return build_snapshot()

func clear_queue() -> void:
	current_snapshot["queued_ability_id"] = ""
	emit_signal("ability_queued", current_snapshot)

func build_snapshot() -> Dictionary:
	return current_snapshot.duplicate(true)
