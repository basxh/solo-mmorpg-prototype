extends Node
class_name HitReactionComponent

signal hit_reaction_started(duration: float, source: String)
signal hit_reaction_ended()

@export var flash_duration: float = 0.15
@export var knockback_force: float = 2.0

var is_flashing: bool = false
var flash_timer: float = 0.0

func flash_on_hit() -> void:
	is_flashing = true
	flash_timer = flash_duration

func apply_hit_reaction(damage_amount: int, source: String = "") -> void:
	flash_on_hit()
	var knockback: Vector3 = Vector3.ZERO
	if not source.is_empty():
		knockback = (get_parent().global_position - get_node_or_null(NodePath(source)).global_position).normalized() * knockback_force if has_node(NodePath(source)) else Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized() * knockback_force
	else:
		knockback = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized() * (knockback_force * 0.5)
	
	if get_parent() is CharacterBody3D and knockback.length() > 0:
		get_parent().velocity += knockback
	
	emit_signal("hit_reaction_started", flash_duration, source)

func damage_taken(damage_amount: int, source: String = "") -> void:
	apply_hit_reaction(damage_amount, source)

func _process(delta: float) -> void:
	if is_flashing:
		flash_timer = max(0.0, flash_timer - delta)
		is_flashing = flash_timer > 0.0
		if not is_flashing:
			emit_signal("hit_reaction_ended")

func is_active() -> bool:
	return is_flashing
