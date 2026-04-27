extends CharacterBody3D
class_name EnemyActor

@export var enemy_id: String = "hollow_wolf"
@export var display_name: String = "Hollow Wolf"

func apply_snapshot(snapshot: Dictionary) -> void:
	enemy_id = snapshot.get("id", enemy_id)
	display_name = snapshot.get("name", display_name)
	global_position = Vector3(
		snapshot.get("x", global_position.x),
		snapshot.get("y", global_position.y),
		snapshot.get("z", global_position.z)
	)
