class_name ProgressionService
extends Node

signal level_up(new_level: int, old_level: int)
signal xp_gained(amount: int, source: String, rest_bonus_applied: bool)
signal stats_updated(stats_snapshot: Dictionary)

# Level progression
var current_level: int = 1
var current_xp: int = 0
var xp_to_next_level: int = 400

# Rest bonus system
var rest_bonus_pool: float = 0.0
var rest_bonus_multiplier: float = 1.0
const MAX_REST_BONUS: float = 2.0
const REST_ACCUMULATION_RATE: float = 1.5

# Character stats
var character_stats: CharacterStats

# XP curve data loaded from JSON
var xp_curve: Dictionary = {}
var level_data: Dictionary = {}

func _ready():
    character_stats = CharacterStats.new()
    load_xp_curve()
    update_level_data()

func load_xp_curve() -> void:
    var file = FileAccess.open("res://content/progression/xp_curve.json", FileAccess.READ)
    if file:
        var json_text: String = file.get_as_text()
        file.close()
        var json = JSON.new()
        var parse_result = json.parse(json_text)
        if parse_result == OK:
            var data: Dictionary = json.get_data()
            xp_curve = data.get("levels", {})
            rest_bonus_multiplier = data.get("rest_bonus", {}).get("accumulation_rate", 1.5)

func update_level_data() -> void:
    var level_key: String = str(current_level)
    if xp_curve.has(level_key):
        level_data = xp_curve[level_key]
        xp_to_next_level = level_data.get("xp_to_next", 0)
        character_stats.update_level_bonuses(level_data)

func gain_xp(amount: int, source: String = "unknown") -> void:
    var total_xp: int = amount
    var rest_bonus_used: bool = false
    
    # Apply rest bonus if available
    if rest_bonus_pool > 0.0:
        var bonus_amount: float = float(amount) * rest_bonus_multiplier
        var consumed_rest: float = min(bonus_amount, rest_bonus_pool)
        total_xp = amount + int(consumed_rest)
        rest_bonus_pool -= consumed_rest
        rest_bonus_used = true
    
    current_xp += total_xp
    xp_gained.emit(total_xp, source, rest_bonus_used)
    
    check_level_up()
    stats_updated.emit(character_stats.to_snapshot())

func check_level_up() -> void:
    var old_level: int = current_level
    var leveled: bool = false
    
    while xp_to_next_level > 0 and current_xp >= xp_to_next_level:
        current_xp -= xp_to_next_level
        current_level += 1
        leveled = true
        update_level_data()
    
    if leveled:
        level_up.emit(current_level, old_level)
        # Heal to full on level up
        character_stats.health = character_stats.max_health
        character_stats.mana = character_stats.max_mana

func add_rest_bonus(amount: float) -> void:
    rest_bonus_pool = min(rest_bonus_pool + amount, 1000.0)

func get_current_level() -> int:
    return current_level

func get_current_xp() -> int:
    return current_xp

func get_xp_to_next_level() -> int:
    return xp_to_next_level

func get_xp_progress_percent() -> float:
    if xp_to_next_level <= 0:
        return 100.0
    return (float(current_xp) / float(xp_to_next_level)) * 100.0

func get_rest_bonus_pool() -> float:
    return rest_bonus_pool

func get_character_stats() -> CharacterStats:
    return character_stats

func build_snapshot() -> Dictionary:
    return {
        "level": current_level,
        "current_xp": current_xp,
        "xp_to_next": xp_to_next_level,
        "xp_progress_percent": get_xp_progress_percent(),
        "rest_bonus": round(rest_bonus_pool),
        "stats": character_stats.to_snapshot()
    }

func apply_snapshot(snapshot: Dictionary) -> void:
    current_level = snapshot.get("level", 1)
    current_xp = snapshot.get("current_xp", 0)
    xp_to_next_level = snapshot.get("xp_to_next", 400)
    rest_bonus_pool = snapshot.get("rest_bonus", 0.0)
    
    var stats_snapshot: Dictionary = snapshot.get("stats", {})
    character_stats.from_snapshot(stats_snapshot)
    update_level_data()
