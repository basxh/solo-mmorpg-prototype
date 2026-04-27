extends Node
class_name QuestStateService

signal quest_state_changed(snapshot: Dictionary)

var current_snapshot: Dictionary = {
	"active_quests": [
		{"title": "Arrival at Cinderwatch", "objective": "Speak to Scout Elden", "completed": false},
		{"title": "Keep the Road Clear", "objective": "Defeat 6 Hollow Wolves (0/6)", "completed": false},
	],
	"wolf_kills": 0,
	"turn_in_ready": false,
}

func build_snapshot() -> Dictionary:
	return current_snapshot.duplicate(true)

func set_snapshot(snapshot: Dictionary) -> void:
	current_snapshot = snapshot.duplicate(true)
	emit_signal("quest_state_changed", current_snapshot)

func register_enemy_defeat(enemy_id: String) -> void:
	if enemy_id != "poi_hollow_wolf_pack" and enemy_id != "hollow_wolf":
		return
	current_snapshot["wolf_kills"] = min(int(current_snapshot.get("wolf_kills", 0)) + 1, 6)
	current_snapshot["active_quests"][1]["objective"] = "Defeat 6 Hollow Wolves (%d/6)" % current_snapshot["wolf_kills"]
	current_snapshot["active_quests"][1]["completed"] = current_snapshot["wolf_kills"] >= 6
	current_snapshot["turn_in_ready"] = current_snapshot["wolf_kills"] >= 6
	emit_signal("quest_state_changed", current_snapshot)

func turn_in_wolf_quest() -> Dictionary:
	if not bool(current_snapshot.get("turn_in_ready", false)):
		return build_snapshot()
	current_snapshot["active_quests"][1]["objective"] = "Return to Scout Elden for your reward"
	current_snapshot["active_quests"][1]["completed"] = true
	current_snapshot["turn_in_ready"] = false
	emit_signal("quest_state_changed", current_snapshot)
	return build_snapshot()
