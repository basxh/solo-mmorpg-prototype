extends Node3D

const SessionStore = preload("res://scripts/world/session_store.gd")
const ZoneLoader = preload("res://scripts/world/zone_loader.gd")
const NpcActorScene = preload("res://scenes/npcs/npc_actor.tscn")
const EnemyActorScene = preload("res://scenes/enemies/enemy_actor.tscn")

const STARTER_ZONE_DATA := {
	"zone_id": "ashen_hollow",
	"display_name": "Ashen Hollow",
	"spawn_point": {"x": 0.0, "y": 0.0, "z": 0.0},
	"landmarks": [
		{"id": "cinderwatch_hamlet", "name": "Cinderwatch Hamlet", "type": "hub"},
		{"id": "old_east_road", "name": "Old East Road", "type": "road"},
		{"id": "weeping_pine_grove", "name": "Weeping Pine Grove", "type": "combat_area"},
		{"id": "shallow_ford", "name": "Shallow Ford", "type": "river_crossing"},
		{"id": "emberglass_ruins", "name": "Emberglass Ruins", "type": "poi"},
	],
}

const STARTER_POI_DATA := {
	"points_of_interest": [
		{"id": "poi_marshal_renna", "category": "npc", "template": "marshal_renna", "name": "Marshal Renna", "x": -2.0, "y": 0.0, "z": 1.0},
		{"id": "poi_scout_elden", "category": "npc", "template": "scout_elden", "name": "Scout Elden", "x": 5.0, "y": 0.0, "z": -4.0},
		{"id": "poi_hollow_wolf_pack", "category": "enemy_spawn", "template": "hollow_wolf", "name": "Hollow Wolf", "x": 12.0, "y": 0.0, "z": -8.0},
		{"id": "poi_thornmaw_alpha", "category": "enemy_spawn", "template": "thornmaw_alpha", "name": "Thornmaw Alpha", "x": 22.0, "y": 0.0, "z": -18.0},
		{"id": "poi_cinderwatch_square", "category": "landmark", "template": "cinderwatch_hamlet", "name": "Cinderwatch Hamlet", "x": 0.0, "y": 0.0, "z": 0.0},
	],
}

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
	var zone_snapshot := zone_loader.load_zone_snapshot(STARTER_ZONE_DATA, STARTER_POI_DATA)
	player_character.global_position = player_spawn.global_position
	follow_camera_rig.set_target(player_character)
	_spawn_stub_world_content(zone_snapshot)
	game_hud.apply_session_snapshot({
		"zone_name": zone_snapshot.get("zone_name", world_snapshot.get("zone_name", "Ashen Hollow")),
		"character_name": world_snapshot.get("character_name", "Adventurer"),
		"quest_hint": world_snapshot.get("quest_hint", "Meet Marshal Renna in Cinderwatch Hamlet"),
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
