extends Node3D

const SessionStore = preload("res://scripts/world/session_store.gd")
const ZoneLoader = preload("res://scripts/world/zone_loader.gd")
const NpcActorScene = preload("res://scenes/npcs/npc_actor.tscn")
const EnemyActorScene = preload("res://scenes/enemies/enemy_actor.tscn")
const PoiMarkerScene = preload("res://scenes/world/poi_marker.tscn")
const InteractionService = preload("res://scripts/interactions/interaction_service.gd")
const TargetingService = preload("res://scripts/targeting/targeting_service.gd")
const CombatService = preload("res://scripts/combat/combat_service.gd")
const AbilityQueueService = preload("res://scripts/abilities/ability_queue_service.gd")
const QuestStateService = preload("res://scripts/quests/quest_state_service.gd")
const DialogueService = preload("res://scripts/dialogue/dialogue_service.gd")

@onready var player_spawn: Marker3D = $PlayerSpawn
@onready var player_character: CharacterBody3D = $PlayerCharacter
@onready var game_hud: CanvasLayer = $GameHud
@onready var follow_camera_rig: Marker3D = $FollowCameraRig
@onready var npc_container: Node3D = $NpcContainer
@onready var enemy_container: Node3D = $EnemyContainer
@onready var marker_container: Node3D = $MarkerContainer

var session_store: SessionStore = SessionStore.get_instance()
var zone_loader: ZoneLoader = ZoneLoader.new()
var interaction_service: InteractionService = InteractionService.new()
var targeting_service: TargetingService = TargetingService.new()
var combat_service: CombatService = CombatService.new()
var ability_queue_service: AbilityQueueService = AbilityQueueService.new()
var quest_state_service: QuestStateService = QuestStateService.new()
var dialogue_service: DialogueService = DialogueService.new()

func _ready() -> void:
	var world_snapshot: Dictionary = session_store.build_world_snapshot()
	var zone_snapshot: Dictionary = zone_loader.load_zone_snapshot(str(world_snapshot.get("zone_id", "ashen_hollow")))
	add_child(interaction_service)
	add_child(targeting_service)
	add_child(combat_service)
	add_child(ability_queue_service)
	add_child(quest_state_service)
	add_child(dialogue_service)
	player_character.global_position = player_spawn.global_position
	follow_camera_rig.call("set_target", player_character)
	_spawn_stub_world_content(zone_snapshot)
	_update_world_hud(zone_snapshot, world_snapshot)
	print("World scaffold ready at spawn:", player_spawn.global_position)

func _spawn_stub_world_content(zone_snapshot: Dictionary) -> void:
	for point in zone_snapshot.get("points_of_interest", []):
		var marker: Node3D = PoiMarkerScene.instantiate()
		marker.name = "%s_marker" % point.get("id", "poi")
		marker_container.add_child(marker)
		marker.call("apply_snapshot", point)
		if point.get("category", "") == "npc":
			var npc: Node3D = NpcActorScene.instantiate()
			npc.name = point.get("id", "npc")
			npc_container.add_child(npc)
			npc.call("apply_snapshot", point)
		elif point.get("category", "") == "enemy_spawn":
			var enemy: CharacterBody3D = EnemyActorScene.instantiate()
			enemy.name = point.get("id", "enemy")
			enemy_container.add_child(enemy)
			enemy.call("apply_snapshot", point)

func _process(delta: float) -> void:
	combat_service.tick_cooldowns(delta)
	var interaction_candidates: Array = []
	for npc in npc_container.get_children():
		interaction_candidates.append({
			"id": npc.name,
			"name": str(npc.get("display_name")),
			"position": npc.global_position,
		})
	var current_interaction: Dictionary = interaction_service.update_from_player_position(player_character.global_position, interaction_candidates)
	var current_dialogue: Dictionary = {}
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

	var target_candidates: Array = []
	for enemy in enemy_container.get_children():
		if bool(enemy.get("is_defeated")):
			continue
		target_candidates.append({
			"id": enemy.name,
			"name": str(enemy.get("display_name")),
			"type": "Enemy",
			"position": enemy.global_position,
		})
	if Input.is_action_just_pressed("target_cycle"):
		targeting_service.cycle_target(player_character.global_position, target_candidates, targeting_service.current_target.get("id", ""))
	var current_target_name: String = str(targeting_service.current_target.get("name", "Enemy"))
	var current_time_seconds: float = Time.get_ticks_msec() / 1000.0
	if combat_service.consume_queued_ability(current_target_name, current_time_seconds):
		ability_queue_service.clear_queue()
	if Input.is_action_just_pressed("ui_accept") and not targeting_service.current_target.is_empty():
		combat_service.set_auto_attack_enabled(true)
		var primary_snapshot: Dictionary = combat_service.build_snapshot()
		var primary_action_locked: bool = float(primary_snapshot.get("global_action_remaining", 0.0)) > 0.0 or float(primary_snapshot.get("cast_duration", 0.0)) > 0.0
		if not primary_action_locked and float(primary_snapshot.get("cooldowns", {}).get("steady_strike", 0.0)) <= 0.0:
			combat_service.trigger_primary_ability(current_target_name)
			for enemy in enemy_container.get_children():
				if enemy.name == targeting_service.current_target.get("id", ""):
					var defeated: bool = bool(enemy.call("apply_damage", 6))
					if defeated:
						quest_state_service.register_enemy_defeat(str(enemy.get("enemy_id")))
						targeting_service.clear_target()
					break
	if Input.is_action_just_pressed("ability_slot_two"):
		ability_queue_service.queue_ability("watchers_focus")
		var combat_snapshot: Dictionary = combat_service.build_snapshot()
		var action_locked: bool = float(combat_snapshot.get("global_action_remaining", 0.0)) > 0.0 or float(combat_snapshot.get("cast_duration", 0.0)) > 0.0
		if action_locked:
			combat_service.queue_ability("watchers_focus", current_time_seconds)
		elif float(combat_snapshot.get("cooldowns", {}).get("watchers_focus", 0.0)) <= 0.0:
			combat_service.trigger_slot(1, current_target_name)
			ability_queue_service.clear_queue()

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
