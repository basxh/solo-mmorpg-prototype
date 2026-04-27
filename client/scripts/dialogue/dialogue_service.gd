extends Node
class_name DialogueService

signal dialogue_changed(snapshot: Dictionary)

const DIALOGUE_DATA := {
	"marshal_renna": {
		"greeting": "Cinderwatch stands because ordinary folk choose to stand together.",
		"farewell": "Report to Scout Elden beyond the east road.",
	},
	"scout_elden": {
		"greeting": "The wolves are getting bolder near the pines.",
		"farewell": "Keep your eyes on the old trail markers.",
	},
}

var current_snapshot: Dictionary = {}

func open_dialogue(npc_id: String) -> Dictionary:
	current_snapshot = DIALOGUE_DATA.get(npc_id, {
		"greeting": "The road is long, traveler.",
		"farewell": "Stay alert out there.",
	}).duplicate(true)
	current_snapshot["npc_id"] = npc_id
	emit_signal("dialogue_changed", current_snapshot)
	return current_snapshot

func build_turn_in_dialogue(npc_id: String, quest_title: String) -> Dictionary:
	current_snapshot = {
		"npc_id": npc_id,
		"greeting": "Well done. Your efforts are already changing the road ahead.",
		"farewell": "Quest complete: %s" % quest_title,
	}
	emit_signal("dialogue_changed", current_snapshot)
	return current_snapshot

func close_dialogue() -> void:
	current_snapshot = {}
	emit_signal("dialogue_changed", current_snapshot)
