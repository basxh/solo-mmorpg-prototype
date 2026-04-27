extends CanvasLayer

@onready var zone_label: Label = $MarginContainer/VBoxContainer/ZoneLabel
@onready var player_label: Label = $MarginContainer/VBoxContainer/PlayerLabel
@onready var quest_label: Label = $MarginContainer/VBoxContainer/QuestLabel
@onready var target_frame: CanvasLayer = $TargetFrame
@onready var interaction_prompt: CanvasLayer = $InteractionPrompt
@onready var action_bar: CanvasLayer = $ActionBar
@onready var quest_tracker: CanvasLayer = $QuestTracker
@onready var dialogue_panel: CanvasLayer = $DialoguePanel
@onready var combat_feedback: CanvasLayer = $CombatFeedback
@onready var cast_bar: CanvasLayer = $CastBar

func apply_session_snapshot(snapshot: Dictionary) -> void:
	zone_label.text = "Zone: %s" % snapshot.get("zone_name", "Ashen Hollow")
	player_label.text = "Player: %s" % snapshot.get("character_name", "Adventurer")
	quest_label.text = "Quest: %s" % snapshot.get("quest_hint", "Meet the Marshal in Cinderwatch Hamlet")
	if snapshot.has("target"):
		target_frame.apply_target(snapshot.get("target", {}))
	if snapshot.has("interaction"):
		interaction_prompt.apply_candidate(snapshot.get("interaction", {}))
	if snapshot.has("combat"):
		action_bar.apply_combat_snapshot(snapshot.get("combat", {}))
		combat_feedback.apply_combat_feedback(snapshot.get("combat", {}).get("feedback", {}))
		cast_bar.apply_cast_snapshot(snapshot.get("combat", {}))
	if snapshot.has("quests"):
		quest_tracker.apply_quest_snapshot(snapshot.get("quests", {}))
	if snapshot.has("dialogue"):
		dialogue_panel.apply_dialogue_snapshot(snapshot.get("dialogue", {}))
