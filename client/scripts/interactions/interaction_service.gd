extends Node
class_name InteractionService

signal interaction_candidate_changed(candidate: Dictionary)

var current_candidate: Dictionary = {}

func set_candidate(candidate: Dictionary) -> void:
	current_candidate = candidate.duplicate(true)
	emit_signal("interaction_candidate_changed", current_candidate)

func clear_candidate() -> void:
	current_candidate = {}
	emit_signal("interaction_candidate_changed", current_candidate)

func update_from_player_position(player_position: Vector3, candidates: Array, max_distance: float = 3.0) -> Dictionary:
	var best_candidate: Dictionary = {}
	var best_distance := max_distance
	for candidate in candidates:
		var distance := player_position.distance_to(candidate.get("position", Vector3.ZERO))
		if distance <= best_distance:
			best_distance = distance
			best_candidate = candidate
	if best_candidate.is_empty():
		clear_candidate()
	else:
		set_candidate(best_candidate)
	return current_candidate
