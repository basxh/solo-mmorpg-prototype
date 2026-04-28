extends Node

class_name DebugOverlayService

# State
var is_active: bool = false
var fps: int = 0
var simulated_ping: int = 0
var entity_count: int = 0
var npc_count: int = 0
var enemy_count: int = 0
var zone_id: String = "unknown"
var player_position: Vector3 = Vector3.ZERO
var target_id: String = ""

# Configuration
var ping_simulation_offset: int = 50
var ping_simulation_variance: int = 30

# Time tracking
var _last_ping_update: float = 0.0
var _ping_update_interval: float = 1.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	_update_fps()
	_update_ping(delta)

func toggle_is_active() -> bool:
	is_active = !is_active
	return is_active

func set_active(value: bool) -> void:
	is_active = value

func _update_fps() -> void:
	fps = Engine.get_frames_per_second()

func _update_ping(delta: float) -> void:
	_last_ping_update += delta
	if _last_ping_update >= _ping_update_interval:
		_last_ping_update = 0.0
		# Simulate realistic ping variance
		var base_ping: int = ping_simulation_offset
		var variance: int = randi() % ping_simulation_variance
		simulated_ping = base_ping + variance

func update_entity_counts(total: int, npcs: int, enemies: int) -> void:
	entity_count = total
	npc_count = npcs
	enemy_count = enemies

func update_zone(new_zone_id: String) -> void:
	zone_id = new_zone_id

func update_player_position(position: Vector3) -> void:
	player_position = position

func update_target_id(new_target_id: String) -> void:
	target_id = new_target_id

func build_snapshot() -> Dictionary:
	return {
		"is_active": is_active,
		"fps": fps,
		"ping": simulated_ping,
		"entity_count": entity_count,
		"npc_count": npc_count,
		"enemy_count": enemy_count,
		"zone_id": zone_id,
		"player_position": {
			"x": player_position.x,
			"y": player_position.y,
			"z": player_position.z,
		},
		"target_id": target_id,
	}
