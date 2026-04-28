extends Node
class_name FloatingTextService

signal text_spawned(text: String, position: Vector2, type: String)

const FLOAT_SPEED: float = 50.0
const LIFE_DURATION: float = 1.2

var active_texts: Array = []

func _process(delta: float) -> void:
	var i: int = active_texts.size() - 1
	while i >= 0:
		var text_item: Dictionary = active_texts[i]
		text_item["position"].y -= FLOAT_SPEED * delta
		text_item["life"] -= delta
		text_item["alpha"] = clamp(text_item["life"] / 0.3, 0.0, 1.0)
		
		if text_item["life"] <= 0:
			active_texts.remove_at(i)
		i -= 1

func spawn_damage_number(amount: int, base_position: Vector2, is_critical: bool = false) -> void:
	var text_string: String = str(amount)
	var offset: Vector2 = Vector2(randf_range(-15, 15), -30)
	var color: String = "white" if not is_critical else "yellow"
	var scale: float = 1.0 if not is_critical else 1.3
	
	var text_item: Dictionary = {
		"text": text_string,
		"position": base_position + offset,
		"base_position": base_position,
		"life": LIFE_DURATION,
		"alpha": 1.0,
		"color": color,
		"scale": scale,
		"type": "damage",
		"is_critical": is_critical,
	}
	
	active_texts.append(text_item)
	emit_signal("text_spawned", text_string, text_item["position"], "damage")

func spawn_floating_text(text: String, base_position: Vector2, color: String = "white") -> void:
	var text_item: Dictionary = {
		"text": text,
		"position": base_position + Vector2(0, -40),
		"base_position": base_position,
		"life": LIFE_DURATION,
		"alpha": 1.0,
		"color": color,
		"scale": 1.0,
		"type": "text",
		"is_critical": false,
	}
	
	active_texts.append(text_item)
	emit_signal("text_spawned", text, text_item["position"], "text")

func spawn_heal_number(amount: int, base_position: Vector2) -> void:
	var text_item: Dictionary = {
		"text": "+" + str(amount),
		"position": base_position + Vector2(randf_range(-10, 10), -50),
		"base_position": base_position,
		"life": LIFE_DURATION,
		"alpha": 1.0,
		"color": "green",
		"scale": 1.1,
		"type": "heal",
		"is_critical": false,
	}
	
	active_texts.append(text_item)
	emit_signal("text_spawned", text_item["text"], text_item["position"], "heal")

func get_active_texts() -> Array:
	return active_texts.duplicate(false)

func clear_all() -> void:
	active_texts.clear()
