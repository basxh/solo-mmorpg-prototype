extends CanvasLayer

@onready var prompt_label: Label = $MarginContainer/PromptLabel

func apply_candidate(candidate: Dictionary) -> void:
	if candidate.is_empty():
		visible = false
		return
	visible = true
	prompt_label.text = "Interact: %s" % candidate.get("name", "Unknown")
