extends Node
class_name QuestStateService

signal quest_state_changed(snapshot: Dictionary)

var current_snapshot := {
	"active_quests": [
		{"title": "Arrival at Cinderwatch", "objective": "Speak to Scout Elden"},
		{"title": "Keep the Road Clear", "objective": "Defeat 6 Hollow Wolves (0/6)"},
	],
}

func build_snapshot() -> Dictionary:
	return current_snapshot.duplicate(true)

func set_snapshot(snapshot: Dictionary) -> void:
	current_snapshot = snapshot.duplicate(true)
	emit_signal("quest_state_changed", current_snapshot)
