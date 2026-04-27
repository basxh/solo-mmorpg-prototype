extends Control

const NetworkService = preload("res://scripts/network/network_service.gd")
const SessionStore = preload("res://scripts/world/session_store.gd")

@onready var name_input: LineEdit = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/NameInput
@onready var status_label: Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/StatusLabel
@onready var connect_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ConnectButton

var network_service: NetworkService

func _ready() -> void:
	network_service = NetworkService.new()
	add_child(network_service)
	network_service.login_succeeded.connect(_on_login_succeeded)
	network_service.login_failed.connect(_on_login_failed)
	connect_button.pressed.connect(_submit_login)
	name_input.text_submitted.connect(func(_new_text: String) -> void: _submit_login())
	status_label.text = "Enter the world of Ashen Hollow."

func _submit_login() -> void:
	connect_button.disabled = true
	status_label.text = "Connecting to the frontier..."
	network_service.login(name_input.text)

func _on_login_succeeded(session_state) -> void:
	SessionStore.get_instance().store_session(session_state)
	status_label.text = "Connected as %s" % session_state.character_name
	get_tree().change_scene_to_file("res://scenes/bootstrap/world_root.tscn")

func _on_login_failed(reason: String) -> void:
	connect_button.disabled = false
	status_label.text = reason
