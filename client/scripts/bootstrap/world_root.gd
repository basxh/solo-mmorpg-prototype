extends Node3D

@onready var player_spawn: Marker3D = $PlayerSpawn
@onready var player_character: CharacterBody3D = $PlayerCharacter
@onready var game_hud: CanvasLayer = $GameHud

func _ready() -> void:
	player_character.global_position = player_spawn.global_position
	game_hud.apply_session_snapshot({
		"zone_name": "Ashen Hollow",
		"character_name": "Adventurer",
		"quest_hint": "Meet Marshal Renna in Cinderwatch Hamlet",
	})
	print("World scaffold ready at spawn:", player_spawn.global_position)
