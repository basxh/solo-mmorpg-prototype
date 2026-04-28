extends CanvasLayer

class_name DebugOverlay

@onready var panel_container: PanelContainer = $PanelContainer
@onready var fps_label: Label = $PanelContainer/MarginContainer/VBoxContainer/FPSLabel
@onready var ping_label: Label = $PanelContainer/MarginContainer/VBoxContainer/PingLabel
@onready var zone_label: Label = $PanelContainer/MarginContainer/VBoxContainer/ZoneLabel
@onready var pos_label: Label = $PanelContainer/MarginContainer/VBoxContainer/PosLabel
@onready var entities_label: Label = $PanelContainer/MarginContainer/VBoxContainer/EntitiesLabel
@onready var target_label: Label = $PanelContainer/MarginContainer/VBoxContainer/TargetLabel
@onready var toggle_timer: Timer = $ToggleTimer

var debug_service: Node = null

func _ready() -> void:
	panel_container.visible = false
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F1:
			toggle_visibility()

func toggle_visibility() -> void:
	if toggle_timer.is_stopped():
		if debug_service:
			var active: bool = debug_service.toggle_is_active()
			panel_container.visible = active
		else:
			panel_container.visible = !panel_container.visible
		toggle_timer.start()

func set_debug_service(service: Node) -> void:
	debug_service = service
	if debug_service:
		panel_container.visible = debug_service.is_active

func apply_debug_snapshot(snapshot: Dictionary) -> void:
	if not panel_container.visible and not snapshot.get("is_active", false):
		return
	
	fps_label.text = "FPS: %d" % snapshot.get("fps", 0)
	ping_label.text = "Ping: %dms" % snapshot.get("ping", 0)
	zone_label.text = "Zone: %s" % snapshot.get("zone_id", "unknown")
	
	var pos: Dictionary = snapshot.get("player_position", {"x": 0, "y": 0, "z": 0})
	pos_label.text = "Pos: %.1f, %.1f, %.1f" % [pos.get("x", 0.0), pos.get("y", 0.0), pos.get("z", 0.0)]
	
	var total: int = snapshot.get("entity_count", 0)
	var npcs: int = snapshot.get("npc_count", 0)
	var enemies: int = snapshot.get("enemy_count", 0)
	entities_label.text = "Entities: %d (NPCs: %d, Enemies: %d)" % [total, npcs, enemies]
	
	var target: String = snapshot.get("target_id", "")
	target_label.text = "Target: %s" % (target if target != "" else "none")

func is_overlay_visible() -> bool:
	return panel_container.visible
