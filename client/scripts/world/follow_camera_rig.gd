extends Marker3D
class_name FollowCameraRig

@export var target_path: NodePath
@export var follow_distance: float = 6.0
@export var follow_height: float = 3.5
@export var smoothing: float = 6.0

var target: Node3D

func _ready() -> void:
	if not target_path.is_empty():
		target = get_node_or_null(target_path)

func set_target(node: Node3D) -> void:
	target = node

func _process(delta: float) -> void:
	if target == null:
		return
	var desired_position: Vector3 = target.global_position + Vector3(0.0, follow_height, follow_distance)
	global_position = global_position.lerp(desired_position, min(1.0, delta * smoothing))
	look_at(target.global_position + Vector3(0.0, 1.25, 0.0), Vector3.UP)
