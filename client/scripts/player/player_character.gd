extends CharacterBody3D

@export var move_speed: float = 5.5
@export var auto_loot_radius: float = 3.0

var inventory_service: Node = null
var loot_drops_in_range: Array = []

func set_facing_yaw(new_yaw_degrees: float) -> void:
	rotation_degrees.y = new_yaw_degrees

func _physics_process(_delta: float) -> void:
	var input_vector: Vector2 = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	)
	var move_direction: Vector3 = Vector3(input_vector.x, 0.0, input_vector.y)
	if move_direction.length() > 1.0:
		move_direction = move_direction.normalized()
	velocity.x = move_direction.x * move_speed
	velocity.z = move_direction.z * move_speed
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_V:
			loot_nearby()

func set_inventory_service(service: Node) -> void:
	inventory_service = service

func loot_nearby() -> void:
	"""Auto-loot all lootable corpses within range"""
	for loot_drop in loot_drops_in_range:
		if is_instance_valid(loot_drop) and loot_drop.has_method("can_loot") and loot_drop.can_loot():
			if loot_drop.has_method("loot_all"):
				loot_drop.loot_all(self)

func auto_loot() -> void:
	"""Convenience method for auto-loot"""
	loot_nearby()

func _on_loot_entered_range(loot_drop: Node) -> void:
	if not loot_drops_in_range.has(loot_drop):
		loot_drops_in_range.append(loot_drop)

func _on_loot_exited_range(loot_drop: Node) -> void:
	loot_drops_in_range.erase(loot_drop)
