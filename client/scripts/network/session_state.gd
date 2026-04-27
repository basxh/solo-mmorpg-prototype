extends RefCounted
class_name SessionState

var character_id: String = ""
var character_name: String = ""
var endpoint: String = "ws://127.0.0.1:3000"
var zone_id: String = "ashen_hollow"
var connected: bool = false

func apply_connection_payload(payload: Dictionary) -> void:
	character_id = payload.get("character_id", "")
	character_name = payload.get("character_name", "")
	endpoint = payload.get("endpoint", endpoint)
	zone_id = payload.get("zone_id", zone_id)
	connected = true

func reset() -> void:
	character_id = ""
	character_name = ""
	zone_id = "ashen_hollow"
	connected = false
