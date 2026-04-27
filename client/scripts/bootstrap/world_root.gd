extends Node3D

const SessionStore = preload("res://scripts/world/session_store.gd")
const ZoneLoader = preload("res://scripts/world/zone_loader.gd")
const NpcActorScene = preload("res://scenes/npcs/npc_actor.tscn")
const EnemyActorScene = preload("res://scenes/enemies/enemy_actor.tscn")

@onready var player_spawn: Marker3D = $PlayerSpawn
@onready var player_character: CharacterBody3D = $PlayerCharacter
@onready var game_hud: CanvasLayer = $GameHud
@onready var follow_camera_rig: FollowCameraRig = $FollowCameraRig
@onready var npc_container: Node3D = $NpcContainer
@onready var enemy_container: Node3D = $EnemyContainer

var session_store := SessionStore.get_instance()
var zone_loader := ZoneLoader.new()

func _ready() -> void:
	var world_snapshot := session_store.build_world_snapshot()
	var zone_snapshot := zone_loader.load_zone_snapshot(world_snapshot.get("zone_id", "ashen_hollow"))
	player_character.global_position = player_spawn.global_position
	follow_camera_rig.set_target(player_character)
	_spawn_stub_world_content(zone_snapshot)
	game_hud.apply_session_snapshot({
		"zone_name": zone_snapshot.get("zone_name", world_snapshot.get("zone_name", "Ashen Hollow")),
		"character_name": world_snapshot.get("character_name", "Adventurer"),
		"quest_hint": world_snapshot.get("quest_hint", "Meet Marshal Renna in Cinderwatch Hamlet"),
		"target": {"name": "Hollow Wolf", "type": "Beast"},
		"interaction": {"name": "Marshal Renna"},
	})
	print("World scaffold ready at spawn:", player_spawn.global_position)

func _spawn_stub_world_content(zone_snapshot: Dictionary) -> void:
	for point in zone_snapshot.get("points_of_interest", []):
		if point.get("category", "") == "npc":
			var npc := NpcActorScene.instantiate()
			npc.name = point.get("id", "npc")
			npc.apply_snapshot(point)
			npc_container.add_child(npc)
		elif point.get("category", "") == "enemy_spawn":
			var enemy := EnemyActorScene.instantiate()
			enemy.name = point.get("id", "enemy")
			enemy.apply_snapshot(point)
			enemy_container.add_child(enemy)
