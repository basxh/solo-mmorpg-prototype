extends Button
class_name InventorySlot

signal slot_clicked(slot_index: int, button: int)
signal slot_drag_started(from_slot: int)
signal slot_dropped(from_slot: int, to_slot: int)
signal stack_split_requested(slot_index: int, quantity: int)

@export var slot_index: int = -1
@export var icon_texture: TextureRect = null
@export var quantity_label: Label = null

var current_item: Dictionary = {}
var is_dragging: bool = false

func _ready() -> void:
	set_item({})
	button_down.connect(_on_button_down)
	native_menu_dismissed.connect(_on_menu_dismissed)

func set_item(item: Dictionary) -> void:
	current_item = item.duplicate(true) if not item.is_empty() else {}
	_update_visuals()

func clear_slot() -> void:
	current_item = {}
	_update_visuals()

func _update_visuals() -> void:
	if current_item.is_empty():
		tooltip_text = ""
		if icon_texture:
			icon_texture.texture = null
		if quantity_label:
			quantity_label.text = ""
	else:
		tooltip_text = "%s\nQuantity: %d" % [current_item.get("name", "Unknown"), current_item.get("quantity", 1)]
		if quantity_label:
			var qty: int = current_item.get("quantity", 1)
			quantity_label.text = str(qty) if qty > 1 else ""
			quantity_label.show() if qty > 1 else quantity_label.hide()

func is_empty() -> bool:
	return current_item.is_empty()

func get_item_data() -> Dictionary:
	return current_item.duplicate(true)

func _get_drag_data(_at_position: Vector2) -> Variant:
	if current_item.is_empty():
		return null
	
	is_dragging = true
	var drag_data: Dictionary = {
		"slot_index": slot_index,
		"item": current_item.duplicate(true)
	}
	
	# Create drag preview
	var preview: TextureRect = TextureRect.new()
	preview.size = Vector2(40, 40)
	if icon_texture and icon_texture.texture:
		preview.texture = icon_texture.texture
	preview.modulate = Color(1, 1, 1, 0.7)
	set_drag_preview(preview)
	
	emit_signal("slot_drag_started", slot_index)
	return drag_data

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if typeof(data) != TYPE_DICTIONARY:
		return false
	if data.has("slot_index"):
		return data.get("slot_index", -1) != slot_index
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if typeof(data) != TYPE_DICTIONARY:
		return
	
	var from_slot: int = data.get("slot_index", -1)
	if from_slot >= 0 and from_slot != slot_index:
		emit_signal("slot_dropped", from_slot, slot_index)
	is_dragging = false

func _on_button_down() -> void:
	if Input.is_action_pressed("ui_shift"):
		# Show split dialog for stacked items
		if not current_item.is_empty():
			var qty: int = current_item.get("quantity", 1)
			if qty > 1:
				_request_stack_split()
				return
	emit_signal("slot_clicked", slot_index, MOUSE_BUTTON_LEFT)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_RIGHT:
				# Right-click to interact (equip if equippable)
				if not current_item.is_empty():
					_on_right_click()
			elif event.button_index == MOUSE_BUTTON_LEFT:
				if Input.is_key_pressed(KEY_SHIFT):
					if not current_item.is_empty():
						var qty: int = current_item.get("quantity", 1)
						if qty > 1:
							_request_stack_split()

func _on_right_click() -> void:
	# Can be extended for context menu
	pass

func _request_stack_split() -> void:
	var qty: int = current_item.get("quantity", 1)
	if qty > 1:
		var split_amount: int = qty / 2
		emit_signal("stack_split_requested", slot_index, split_amount)

func _on_menu_dismissed() -> void:
	pass

func get_drag_data(at_position: Vector2) -> Variant:
	return _get_drag_data(at_position)

func can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return _can_drop_data(at_position, data)

func drop_data(at_position: Vector2, data: Variant) -> void:
	_drop_data(at_position, data)
