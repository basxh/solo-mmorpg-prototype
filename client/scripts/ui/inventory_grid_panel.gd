extends CanvasLayer
class_name InventoryGridPanel

signal inventory_closed()
signal inventory_opened()
signal item_equipped(slot_index: int)

@export var grid_container: GridContainer = null
@export var close_button: Button = null
@export var title_label: Label = null

const InventorySlotScript = preload("res://scripts/ui/inventory_slot.gd")
const InventoryService = preload("res://scripts/inventory/inventory_service.gd")

var inventory_service: InventoryService = null
var inventory_slots: Array = []
var is_visible: bool = false

const InventorySlotScene = preload("res://scenes/ui/inventory_slot.tscn")

func _ready() -> void:
	_initialize_slots()
	visible = false
	
	if close_button:
		close_button.pressed.connect(_on_close_pressed)

func _initialize_slots() -> void:
	if not grid_container:
		return
	
	# Clear existing
	for child in grid_container.get_children():
		child.queue_free()
	inventory_slots.clear()
	
	# Create slots
	for i in range(InventoryService.INVENTORY_SIZE):
		var slot: Button = InventorySlotScene.instantiate()
		slot.slot_index = i
		slot.slot_clicked.connect(_on_slot_clicked)
		slot.slot_drag_started.connect(_on_slot_drag_started)
		slot.slot_dropped.connect(_on_slot_dropped)
		slot.stack_split_requested.connect(_on_stack_split_requested)
		
		grid_container.add_child(slot)
		inventory_slots.append(slot)

func set_inventory_service(service: InventoryService) -> void:
	inventory_service = service
	
	# Connect to inventory signals
	inventory_service.inventory_changed.connect(_on_inventory_changed)
	inventory_service.item_added.connect(_on_item_added)
	inventory_service.item_removed.connect(_on_item_removed)
	
	# Initial refresh
	refresh_grid()

func _on_inventory_changed(slot_index: int, item: Dictionary) -> void:
	update_slot(slot_index, item)

func _on_item_added(_item_id: String, _quantity: int, slot_index: int) -> void:
	if slot_index >= 0 and slot_index < inventory_slots.size():
		var item: Dictionary = inventory_service.get_item_at(slot_index)
		update_slot(slot_index, item)

func _on_item_removed(_item_id: String, _quantity: int, slot_index: int) -> void:
	if slot_index >= 0 and slot_index < inventory_slots.size():
		update_slot(slot_index, inventory_service.get_item_at(slot_index))

func update_slot(slot_index: int, item: Dictionary) -> void:
	if slot_index < 0 or slot_index >= inventory_slots.size():
		return
	
	var slot: InventorySlot = inventory_slots[slot_index]
	slot.set_item(item)

func refresh_grid() -> void:
	if not inventory_service:
		return
	
	for i in range(InventoryService.INVENTORY_SIZE):
		var item: Dictionary = inventory_service.get_item_at(i)
		update_slot(i, item)

func apply_inventory_snapshot(snapshot: Dictionary) -> void:
	var items: Array = snapshot.get("items", [])
	
	# Clear all first
	for slot in inventory_slots:
		slot.clear_slot()
	
	# Set items
	for item in items:
		var slot_index: int = item.get("slot_index", -1)
		if slot_index >= 0 and slot_index < inventory_slots.size():
			update_slot(slot_index, item)

func _on_slot_clicked(slot_index: int, button: int) -> void:
	if button == MOUSE_BUTTON_LEFT and inventory_service:
		var item: Dictionary = inventory_service.get_item_at(slot_index)
		if not item.is_empty():
			if inventory_service.is_equippable(item):
				# Try to equip
				if inventory_service.equip_item(slot_index):
					emit_signal("item_equipped", slot_index)

func _on_slot_drag_started(from_slot: int) -> void:
	pass  # Drag started, preview shown

func _on_slot_dropped(from_slot: int, to_slot: int) -> void:
	if inventory_service:
		var from_item: Dictionary = inventory_service.get_item_at(from_slot)
		var to_item: Dictionary = inventory_service.get_item_at(to_slot)
		
		# If same item type and not full stack, try combine
		if not from_item.is_empty() and not to_item.is_empty():
			if from_item.get("item_id") == to_item.get("item_id"):
				if inventory_service.combine_stacks(from_slot, to_slot):
					return
		
		# Otherwise swap
		inventory_service.swap_slots(from_slot, to_slot)

func _on_stack_split_requested(slot_index: int, quantity: int) -> void:
	if inventory_service:
		inventory_service.split_stack(slot_index, quantity)

func toggle_inventory() -> bool:
	if visible:
		hide_inventory()
		return false
	else:
		show_inventory()
		return true

func show_inventory() -> void:
	visible = true
	is_visible = true
	emit_signal("inventory_opened")

func hide_inventory() -> void:
	visible = false
	is_visible = false
	emit_signal("inventory_closed")

func _on_close_pressed() -> void:
	hide_inventory()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			if visible:
				hide_inventory()
