extends CanvasLayer

@onready var quest_one_label: Label = $MarginContainer/VBoxContainer/QuestOneLabel
@onready var quest_two_label: Label = $MarginContainer/VBoxContainer/QuestTwoLabel

func apply_quest_snapshot(snapshot: Dictionary) -> void:
	var active_quests: Array = snapshot.get("active_quests", [])
	quest_one_label.text = active_quests[0]["objective"] if active_quests.size() > 0 else "No active quest"
	quest_two_label.text = active_quests[1]["objective"] if active_quests.size() > 1 else ""
