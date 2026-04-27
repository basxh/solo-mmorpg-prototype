extends Node
class_name CombatService

signal combat_state_changed(state: Dictionary)

var current_state := {
	"ability_slots": ["steady_strike", "watchers_focus"],
	"auto_attack_enabled": false,
	"resource_name": "Stamina",
	"resource_value": 100,
}

func set_auto_attack_enabled(enabled: bool) -> void:
	current_state["auto_attack_enabled"] = enabled
	emit_signal("combat_state_changed", current_state)

func build_snapshot() -> Dictionary:
	return current_state.duplicate(true)
