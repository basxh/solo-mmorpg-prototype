extends Marker3D
class_name FollowCameraRig

@export var target_path: NodePath
@export var follow_distance: float = 6.0
@export var follow_height: float = 3.5
@export var smoothing: float = 6.0
@export var mouse_sensitivity: float = 0.15
@export var min_pitch_degrees: float = -35.0
@export var max_pitch_degrees: float = 55.0

var target: Node3D
var yaw_degrees: float = 0.0
var pitch_degrees: float = -12.0
var is_left_dragging: bool = false
var is_right_dragging: bool = false

var combat_feel_service: Node = null
var shake_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	if not target_path.is_empty():
		target = get_node_or_null(target_path)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func set_target(node: Node3D) -> void:
	target = node
	yaw_degrees = node.rotation_degrees.y

func set_combat_feel_service(service) -> void:
	combat_feel_service = service

func apply_camera_offset(offset: Vector2) -> void:
	shake_offset = offset

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button: InputEventMouseButton = event
		if mouse_button.button_index == MOUSE_BUTTON_LEFT:
			is_left_dragging = mouse_button.pressed
		elif mouse_button.button_index == MOUSE_BUTTON_RIGHT:
			is_right_dragging = mouse_button.pressed
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if is_left_dragging or is_right_dragging else Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseMotion and (is_left_dragging or is_right_dragging):
		var motion: InputEventMouseMotion = event
		yaw_degrees -= motion.relative.x * mouse_sensitivity
		pitch_degrees = clamp(pitch_degrees - motion.relative.y * mouse_sensitivity, min_pitch_degrees, max_pitch_degrees)
		if is_right_dragging and target != null:
			target.call("set_facing_yaw", yaw_degrees)

func _process(delta: float) -> void:
	if target == null:
		return
	
	if combat_feel_service != null:
		shake_offset = combat_feel_service.get_camera_offset()
	
	var yaw_radians: float = deg_to_rad(yaw_degrees)
	var pitch_radians: float = deg_to_rad(pitch_degrees)
	var orbit_offset: Vector3 = Vector3(
		sin(yaw_radians) * cos(pitch_radians),
		sin(pitch_radians),
		cos(yaw_radians) * cos(pitch_radians)
	) * follow_distance
	var desired_position: Vector3 = target.global_position + Vector3(0.0, follow_height, 0.0) + orbit_offset
	
	if shake_offset.length() > 0.0:
		desired_position.x += shake_offset.x * 0.01
		desired_position.y += shake_offset.y * 0.01
	
	global_position = global_position.lerp(desired_position, min(1.0, delta * smoothing))
	look_at(target.global_position + Vector3(0.0, 1.25, 0.0), Vector3.UP)
