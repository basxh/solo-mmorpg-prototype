extends Node3D

const NetworkClient = preload("res://scripts/network/network_client.gd")

@onready var player_spawn: Marker3D = $PlayerSpawn

var network_client: NetworkClient

func _ready() -> void:
	network_client = NetworkClient.new()
	add_child(network_client)
	network_client.connected_to_world.connect(_on_connected_to_world)
	network_client.connection_failed.connect(_on_connection_failed)
	network_client.connect_to_world("Adventurer")

func _on_connected_to_world(connection_info: Dictionary) -> void:
	print("Connected to world scaffold:", connection_info)
	print("Spawn marker at:", player_spawn.global_position)

func _on_connection_failed(reason: String) -> void:
	push_warning("Connection failed: %s" % reason)
