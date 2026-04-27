extends CharacterBody3D

@export var move_speed: float = 5.5

func _physics_process(_delta: float) -> void:
	var input_vector := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	)
	var move_direction := Vector3(input_vector.x, 0.0, input_vector.y)
	if move_direction.length() > 1.0:
		move_direction = move_direction.normalized()
	velocity.x = move_direction.x * move_speed
	velocity.z = move_direction.z * move_speed
	move_and_slide()
