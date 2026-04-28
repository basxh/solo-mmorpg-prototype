extends CharacterBody3D
class_name EnemyActor

const LootDropScene = preload("res://scenes/inventory/loot_drop_actor.tscn")

@export var enemy_id: String = "hollow_wolf"
@export var display_name: String = "Hollow Wolf"
@export var max_hp: int = 24

var current_hp: int = max_hp
var is_defeated: bool = false
var has_spawned_loot: bool = false

var loot_table_service: Node = null
var loot_drop_node: Node = null

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
	
	if is_defeated and not has_spawned_loot:
		_on_death()
	
	return is_defeated

func set_loot_table_service(service: Node) -> void:
	loot_table_service = service

func _on_death() -> void:
	"""Called when enemy dies - spawn loot drop"""
	has_spawned_loot = true
	
	if loot_table_service and loot_table_service.has_method("generate_loot"):
		var loot_items: Array = loot_table_service.generate_loot(enemy_id)
		
		if loot_items.size() > 0:
			_spawn_loot_drop(loot_items)

func _spawn_loot_drop(loot_items: Array) -> void:
	"""Create loot drop actor at enemy position"""
	if LootDropScene:
		loot_drop_node = LootDropScene.instantiate()
		loot_drop_node.drop_owner_id = enemy_id
		loot_drop_node.drop_owner_name = display_name
		loot_drop_node.set_loot_items(loot_items)
		loot_drop_node.global_position = global_position
		
		# Add to parent scene
		if get_parent():
			get_parent().add_child(loot_drop_node)

func get_loot_drop() -> Node:
	return loot_drop_node
