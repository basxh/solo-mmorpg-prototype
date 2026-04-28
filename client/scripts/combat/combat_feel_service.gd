extends Node
class_name CombatFeelService

signal camera_shake_requested(magnitude: float, duration: float)
signal hitstop_requested(duration: float)
signal damage_dealt(target: String, amount: int, is_critical: bool)
signal damage_taken(source: String, amount: int)

var screen_shake_magnitude: float = 0.0
var screen_shake_duration: float = 0.0
var screen_shake_decay: float = 1.0
var shake_offset: Vector2 = Vector2.ZERO

var hitstop_duration: float = 0.0
var hitstop_active: bool = false

func _process(delta: float) -> void:
	if screen_shake_duration > 0:
		screen_shake_duration = max(0.0, screen_shake_duration - delta)
		var remaining: float = screen_shake_duration / max(0.01, screen_shake_magnitude * 0.2)
		var shake_magnitude: float = screen_shake_magnitude * remaining
		shake_offset.x = randf_range(-shake_magnitude, shake_magnitude)
		shake_offset.y = randf_range(-shake_magnitude, shake_magnitude)
	else:
		shake_offset = Vector2.ZERO
		screen_shake_magnitude = 0.0
	
	if hitstop_active:
		hitstop_duration = max(0.0, hitstop_duration - delta)
		hitstop_active = hitstop_duration > 0.0

func start_screen_shake(magnitude: float, duration: float, decay_rate: float = 1.0) -> void:
	screen_shake_magnitude = magnitude
	screen_shake_duration = duration
	screen_shake_decay = decay_rate
	emit_signal("camera_shake_requested", magnitude, duration)

func start_hitstop(duration: float) -> void:
	hitstop_duration = duration
	hitstop_active = true
	emit_signal("hitstop_requested", duration)

func apply_combat_feel(damage_amount: int, source: String = "", target: String = "") -> void:
	var shake_magnitude: float = min(5.0, 1.0 + damage_amount * 0.15)
	var shake_duration: float = min(0.5, 0.1 + damage_amount * 0.02)
	start_screen_shake(shake_magnitude, shake_duration, 0.8)
	
	if damage_amount >= 8:
		start_hitstop(0.08)
	
	emit_signal("damage_dealt", target, damage_amount, damage_amount >= 8)

func apply_damage_taken(damage_amount: int, source: String = "") -> void:
	var shake_magnitude: float = min(3.0, 0.5 + damage_amount * 0.1)
	var shake_duration: float = min(0.35, 0.15 + damage_amount * 0.015)
	start_screen_shake(shake_magnitude, shake_duration, 0.9)
	
	emit_signal("damage_taken", source, damage_amount)

func get_camera_offset() -> Vector2:
	return shake_offset

func is_hitstop_active() -> bool:
	return hitstop_active

func reset() -> void:
	screen_shake_magnitude = 0.0
	screen_shake_duration = 0.0
	screen_shake_decay = 1.0
	shake_offset = Vector2.ZERO
	hitstop_duration = 0.0
	hitstop_active = false
