extends Node
class_name SessionStore

const SessionState = preload("res://scripts/network/session_state.gd")

static var _instance: SessionStore

var session_state: SessionState = SessionState.new()

static func get_instance() -> SessionStore:
	if _instance == null:
		_instance = load("res://scripts/world/session_store.gd").new()
	return _instance

func store_session(new_session_state: SessionState) -> void:
	session_state = SessionState.new()
	session_state.apply_connection_payload({
		"character_id": new_session_state.character_id,
		"character_name": new_session_state.character_name,
		"endpoint": new_session_state.endpoint,
		"zone_id": new_session_state.zone_id,
	})

func build_world_snapshot() -> Dictionary:
	return {
		"character_id": session_state.character_id,
		"character_name": session_state.character_name if session_state.connected else "Adventurer",
		"zone_id": session_state.zone_id,
		"zone_name": "Ashen Hollow",
		"quest_hint": "Meet Marshal Renna in Cinderwatch Hamlet",
	}
