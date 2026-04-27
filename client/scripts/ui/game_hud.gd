extends CanvasLayer

@onready var zone_label: Label = $MarginContainer/VBoxContainer/ZoneLabel
@onready var player_label: Label = $MarginContainer/VBoxContainer/PlayerLabel
@onready var quest_label: Label = $MarginContainer/VBoxContainer/QuestLabel

func apply_session_snapshot(snapshot: Dictionary) -> void:
	zone_label.text = "Zone: %s" % snapshot.get("zone_name", "Ashen Hollow")
	player_label.text = "Player: %s" % snapshot.get("character_name", "Adventurer")
	quest_label.text = "Quest: %s" % snapshot.get("quest_hint", "Meet the Marshal in Cinderwatch Hamlet")
