extends Node
class_name ZoneLoader

const CONTENT_ROOT: String = "res://content/"

func load_zone_snapshot(zone_id: String = "ashen_hollow") -> Dictionary:
	var manifest: Dictionary = _load_json(CONTENT_ROOT + "manifest.json")
	var zone_path: String = "zones/%s.json" % zone_id
	var zone_data: Dictionary = _load_json(CONTENT_ROOT + zone_path)
	var poi_path: String = str(zone_data.get("poi_manifest", "points_of_interest/starter_pois.json"))
	var poi_data: Dictionary = _load_json(CONTENT_ROOT + poi_path)
	return {
		"zone_id": zone_data.get("zone_id", manifest.get("starter_zone", zone_id)),
		"zone_name": zone_data.get("display_name", "Ashen Hollow"),
		"spawn_point": zone_data.get("spawn_point", {"x": 0.0, "y": 0.0, "z": 0.0}),
		"landmarks": zone_data.get("landmarks", []),
		"points_of_interest": poi_data.get("points_of_interest", []),
	}

func _load_json(path: String) -> Dictionary:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) == TYPE_DICTIONARY:
		return parsed
	return {}
