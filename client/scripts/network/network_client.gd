extends Node
class_name NetworkClient

signal connected_to_world(connection_info: Dictionary)
signal connection_failed(reason: String)

var endpoint: String = "ws://127.0.0.1:3000"
var authenticated_character_id: String = ""

func configure(new_endpoint: String) -> void:
	endpoint = new_endpoint

func connect_to_world(character_name: String) -> void:
	if character_name.strip_edges().is_empty():
		emit_signal("connection_failed", "Character name is required.")
		return

	authenticated_character_id = "local-prototype"
	emit_signal("connected_to_world", {
		"character_id": authenticated_character_id,
		"endpoint": endpoint,
		"character_name": character_name,
	})
