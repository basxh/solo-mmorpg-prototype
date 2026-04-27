extends Node
class_name CombatService

signal combat_state_changed(state: Dictionary)

const ABILITY_CONTENT_PATH: String = "res://content/abilities/starter_abilities.json"

var ability_definitions: Dictionary = {}
var current_state: Dictionary = {
	"ability_slots": ["steady_strike", "watchers_focus"],
	"auto_attack_enabled": false,
	"resource_name": "Stamina",
	"resource_value": 100,
	"last_ability_used": "",
	"cooldowns": {
		"steady_strike": 0.0,
		"watchers_focus": 0.0,
	},
	"queued_ability_id": "",
	"queue_window_seconds": 0.35,
	"queue_expires_at": 0.0,
	"global_action_remaining": 0.0,
	"cast_name": "",
	"cast_progress": 0.0,
	"cast_duration": 0.0,
	"feedback": {},
}

func _ready() -> void:
	load_ability_definitions()

func load_ability_definitions() -> void:
	ability_definitions = {
		"steady_strike": {
			"name": "Steady Strike",
			"cooldown_seconds": 4.0,
			"cast_time_seconds": 0.0,
			"queue_window_seconds": 0.35,
		},
		"watchers_focus": {
			"name": "Watcher's Focus",
			"cooldown_seconds": 8.0,
			"cast_time_seconds": 1.2,
			"queue_window_seconds": 0.35,
		},
	}
	if not FileAccess.file_exists(ABILITY_CONTENT_PATH):
		return
	var ability_file: FileAccess = FileAccess.open(ABILITY_CONTENT_PATH, FileAccess.READ)
	if ability_file == null:
		return
	var parsed: Variant = JSON.parse_string(ability_file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	for ability in parsed.get("abilities", []):
		ability_definitions[str(ability.get("id", ""))] = ability

func set_auto_attack_enabled(enabled: bool) -> void:
	current_state["auto_attack_enabled"] = enabled
	emit_signal("combat_state_changed", current_state)

func queue_ability(ability_id: String, queued_at_seconds: float = 0.0) -> void:
	var definition: Dictionary = ability_definitions.get(ability_id, {}) as Dictionary
	current_state["queued_ability_id"] = ability_id
	current_state["queue_window_seconds"] = float(definition.get("queue_window_seconds", current_state.get("queue_window_seconds", 0.35)))
	current_state["queue_expires_at"] = queued_at_seconds + float(current_state.get("queue_window_seconds", 0.35))
	current_state["feedback"] = {
		"message": "%s queued" % ability_id,
	}
	emit_signal("combat_state_changed", current_state)

func tick_cooldowns(delta: float) -> void:
	var cooldowns: Dictionary = current_state.get("cooldowns", {})
	for ability_id in cooldowns.keys():
		cooldowns[ability_id] = max(float(cooldowns.get(ability_id, 0.0)) - delta, 0.0)
	current_state["cooldowns"] = cooldowns
	current_state["global_action_remaining"] = max(float(current_state.get("global_action_remaining", 0.0)) - delta, 0.0)
	if float(current_state.get("cast_duration", 0.0)) > 0.0:
		current_state["cast_progress"] = min(float(current_state.get("cast_progress", 0.0)) + delta, float(current_state.get("cast_duration", 0.0)))
		if is_equal_approx(float(current_state.get("cast_progress", 0.0)), float(current_state.get("cast_duration", 0.0))):
			current_state["cast_name"] = ""
			current_state["cast_progress"] = 0.0
			current_state["cast_duration"] = 0.0

func consume_queued_ability(target_name: String = "Enemy", current_time_seconds: float = 0.0) -> bool:
	var queued_ability_id: String = str(current_state.get("queued_ability_id", ""))
	if queued_ability_id.is_empty():
		return false
	if current_time_seconds > 0.0 and current_time_seconds > float(current_state.get("queue_expires_at", 0.0)):
		current_state["queued_ability_id"] = ""
		current_state["queue_expires_at"] = 0.0
		return false
	if float(current_state.get("global_action_remaining", 0.0)) > 0.0:
		return false
	if float(current_state.get("cast_duration", 0.0)) > 0.0:
		return false
	if float(current_state.get("cooldowns", {}).get(queued_ability_id, 0.0)) > 0.0:
		return false
	_trigger_ability(queued_ability_id, target_name)
	return true

func trigger_slot(slot_index: int, target_name: String = "Enemy") -> void:
	var slots: Array = current_state.get("ability_slots", []) as Array
	if slot_index < 0 or slot_index >= slots.size():
		return
	_trigger_ability(str(slots[slot_index]), target_name)

func trigger_primary_ability(target_name: String = "Enemy") -> void:
	trigger_slot(0, target_name)

func _trigger_ability(ability_id: String, target_name: String) -> void:
	var definition: Dictionary = ability_definitions.get(ability_id, {}) as Dictionary
	current_state["last_ability_used"] = ability_id
	current_state["cooldowns"][ability_id] = float(definition.get("cooldown_seconds", 0.0))
	current_state["queue_window_seconds"] = float(definition.get("queue_window_seconds", current_state.get("queue_window_seconds", 0.35)))
	current_state["cast_duration"] = float(definition.get("cast_time_seconds", 0.0))
	current_state["global_action_remaining"] = max(float(definition.get("cast_time_seconds", 0.0)), 0.35)
	if ability_id == "watchers_focus":
		current_state["cast_name"] = str(definition.get("name", "Watcher's Focus"))
		current_state["cast_progress"] = 0.0
		current_state["feedback"] = {
			"message": "Watcher's Focus steadies you for the next strike.",
		}
	else:
		current_state["cast_name"] = ""
		current_state["cast_progress"] = 0.0
		current_state["feedback"] = {
			"message": "Steady Strike hits %s for 6" % target_name,
		}
	if current_state.get("queued_ability_id", "") == ability_id:
		current_state["queued_ability_id"] = ""
		current_state["queue_expires_at"] = 0.0
	emit_signal("combat_state_changed", current_state)

func build_snapshot() -> Dictionary:
	return current_state.duplicate(true)
