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
