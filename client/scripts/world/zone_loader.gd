extends Node
class_name ZoneLoader

func load_zone_snapshot(zone_data: Dictionary, poi_data: Dictionary) -> Dictionary:
	return {
		"zone_id": zone_data.get("zone_id", "ashen_hollow"),
		"zone_name": zone_data.get("display_name", "Ashen Hollow"),
		"spawn_point": zone_data.get("spawn_point", {"x": 0.0, "y": 0.0, "z": 0.0}),
		"landmarks": zone_data.get("landmarks", []),
		"points_of_interest": poi_data.get("points_of_interest", []),
	}
