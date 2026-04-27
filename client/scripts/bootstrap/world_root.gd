extends Node3D

const SessionStore = preload("res://scripts/world/session_store.gd")
const ZoneLoader = preload("res://scripts/world/zone_loader.gd")
const NpcActorScene = preload("res://scenes/npcs/npc_actor.tscn")
const EnemyActorScene = preload("res://scenes/enemies/enemy_actor.tscn")
const PoiMarkerScene = preload("res://scenes/world/poi_marker.tscn")
const InteractionService = preload("res://scripts/interactions/interaction_service.gd")
const TargetingService = preload("res://scripts/targeting/targeting_service.gd")
const CombatService = preload("res://scripts/combat/combat_service.gd")
const QuestStateService = preload("res://scripts/quests/quest_state_service.gd")
const DialogueService = preload("res://scripts/dialogue/dialogue_service.gd")

@onready var player_spawn: Marker3D = $PlayerSpawn
@onready var player_character: CharacterBody3D = $PlayerCharacter
@onready var game_hud: CanvasLayer = $GameHud
@onready var follow_camera_rig: FollowCameraRig = $FollowCameraRig
@onready var npc_container: Node3D = $NpcContainer
@onready var enemy_container: Node3D = $EnemyContainer
@onready var marker_container: Node3D = $MarkerContainer

var session_store := SessionStore.get_instance()
var zone_loader := ZoneLoader.new()
var interaction_service := InteractionService.new()
var targeting_service := TargetingService.new()
var combat_service := CombatService.new()
var quest_state_service := QuestStateService.new()
var dialogue_service := DialogueService.new()

func _ready() -> void:
	var world_snapshot := session_store.build_world_snapshot()
	var zone_snapshot := zone_loader.load_zone_snapshot(world_snapshot.get("zone_id", "ashen_hollow"))
	add_child(interaction_service)
	add_child(targeting_service)
	add_child(combat_service)
	add_child(quest_state_service)
	add_child(dialogue_service)
	player_character.global_position = player_spawn.global_position
	follow_camera_rig.set_target(player_character)
	_spawn_stub_world_content(zone_snapshot)
	_update_world_hud(zone_snapshot, world_snapshot)
	print("World scaffold ready at spawn:", player_spawn.global_position)

func _spawn_stub_world_content(zone_snapshot: Dictionary) -> void:
	for point in zone_snapshot.get("points_of_interest", []):
		var marker := PoiMarkerScene.instantiate()
		marker.name = "%s_marker" % point.get("id", "poi")
		marker.apply_snapshot(point)
		marker_container.add_child(marker)
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

func _process(_delta: float) -> void:
	var interaction_candidates := []
	for npc in npc_container.get_children():
		interaction_candidates.append({
			"id": npc.name,
			"name": npc.display_name,
			"position": npc.global_position,
		})
	var current_interaction := interaction_service.update_from_player_position(player_character.global_position, interaction_candidates)
	var current_dialogue := {}
	if Input.is_action_just_pressed("interact") and not current_interaction.is_empty():
		if current_interaction.get("id", "") == "poi_scout_elden" and bool(quest_state_service.build_snapshot().get("turn_in_ready", false)):
			quest_state_service.turn_in_wolf_quest()
			current_dialogue = dialogue_service.build_turn_in_dialogue("scout_elden", "Keep the Road Clear")
		else:
			current_dialogue = dialogue_service.open_dialogue(current_interaction.get("id", ""))
	elif current_interaction.is_empty():
		dialogue_service.close_dialogue()
		current_dialogue = {}
	else:
		current_dialogue = dialogue_service.current_snapshot

	var target_candidates := []
	for enemy in enemy_container.get_children():
		if enemy.is_defeated:
			continue
		target_candidates.append({
			"id": enemy.name,
			"name": enemy.display_name,
			"type": "Enemy",
			"position": enemy.global_position,
		})
	if Input.is_action_just_pressed("target_cycle"):
		targeting_service.cycle_target(player_character.global_position, target_candidates, targeting_service.current_target.get("id", ""))
	if Input.is_action_just_pressed("ui_accept") and not targeting_service.current_target.is_empty():
		combat_service.set_auto_attack_enabled(true)
		combat_service.trigger_primary_ability(targeting_service.current_target.get("name", "Enemy"))
		for enemy in enemy_container.get_children():
			if enemy.name == targeting_service.current_target.get("id", ""):
				var defeated := enemy.apply_damage(6)
				if defeated:
					quest_state_service.register_enemy_defeat(enemy.enemy_id)
					targeting_service.clear_target()
				break

	_update_world_hud({"zone_name": "Ashen Hollow"}, {
		"character_name": session_store.build_world_snapshot().get("character_name", "Adventurer"),
		"quest_hint": session_store.build_world_snapshot().get("quest_hint", "Meet Marshal Renna in Cinderwatch Hamlet"),
		"interaction": current_interaction,
		"target": targeting_service.current_target,
		"combat": combat_service.build_snapshot(),
		"quests": quest_state_service.build_snapshot(),
		"dialogue": current_dialogue,
	})

func _update_world_hud(zone_snapshot: Dictionary, world_snapshot: Dictionary) -> void:
	game_hud.apply_session_snapshot({
		"zone_name": zone_snapshot.get("zone_name", world_snapshot.get("zone_name", "Ashen Hollow")),
		"character_name": world_snapshot.get("character_name", "Adventurer"),
		"quest_hint": world_snapshot.get("quest_hint", "Meet Marshal Renna in Cinderwatch Hamlet"),
		"target": world_snapshot.get("target", {}),
		"interaction": world_snapshot.get("interaction", {}),
	})
