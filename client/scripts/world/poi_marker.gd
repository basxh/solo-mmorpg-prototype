extends Node3D
class_name PoiMarker

@export var poi_name: String = "Point of Interest"
@export var category: String = "landmark"

@onready var label_3d: Label3D = $Label3D

func apply_snapshot(snapshot: Dictionary) -> void:
	poi_name = snapshot.get("name", poi_name)
	category = snapshot.get("category", category)
	global_position = Vector3(
		snapshot.get("x", global_position.x),
		snapshot.get("y", global_position.y),
		snapshot.get("z", global_position.z)
	)
	label_3d.text = poi_name
