extends Node3D
class_name NpcActor

@export var npc_id: String = "marshal_renna"
@export var display_name: String = "Marshal Renna"

func apply_snapshot(snapshot: Dictionary) -> void:
	npc_id = snapshot.get("id", npc_id)
	display_name = snapshot.get("name", display_name)
	global_position = Vector3(
		snapshot.get("x", global_position.x),
		snapshot.get("y", global_position.y),
		snapshot.get("z", global_position.z)
	)
