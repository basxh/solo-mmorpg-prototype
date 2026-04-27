extends CharacterBody3D
class_name EnemyActor

@export var enemy_id: String = "hollow_wolf"
@export var display_name: String = "Hollow Wolf"
@export var max_hp: int = 24

var current_hp: int = max_hp
var is_defeated: bool = false

func apply_snapshot(snapshot: Dictionary) -> void:
	enemy_id = snapshot.get("id", enemy_id)
	display_name = snapshot.get("name", display_name)
	max_hp = int(snapshot.get("hp", max_hp))
	current_hp = int(snapshot.get("current_hp", max_hp))
	is_defeated = bool(snapshot.get("is_defeated", false))
	visible = not is_defeated
	global_position = Vector3(
		snapshot.get("x", global_position.x),
		snapshot.get("y", global_position.y),
		snapshot.get("z", global_position.z)
	)

func apply_damage(amount: int) -> bool:
	current_hp = max(0, current_hp - amount)
	is_defeated = current_hp <= 0
	visible = not is_defeated
	return is_defeated
