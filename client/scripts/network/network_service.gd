extends Node
class_name NetworkService

const NetworkClient = preload("res://scripts/network/network_client.gd")
const SessionState = preload("res://scripts/network/session_state.gd")

signal login_succeeded(session_state: SessionState)
signal login_failed(reason: String)

var client: NetworkClient
var session_state := SessionState.new()

func _ready() -> void:
	client = NetworkClient.new()
	add_child(client)
	client.connected_to_world.connect(_on_connected_to_world)
	client.connection_failed.connect(_on_connection_failed)

func configure(endpoint: String) -> void:
	client.configure(endpoint)
	session_state.endpoint = endpoint

func login(character_name: String) -> void:
	client.connect_to_world(character_name)

func _on_connected_to_world(connection_info: Dictionary) -> void:
	session_state.apply_connection_payload(connection_info)
	emit_signal("login_succeeded", session_state)

func _on_connection_failed(reason: String) -> void:
	session_state.reset()
	emit_signal("login_failed", reason)
