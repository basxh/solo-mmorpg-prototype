class_name CharacterStats
extends RefCounted

# Primary attributes
var strength: int = 10
var agility: int = 10
var intellect: int = 10
var spirit: int = 10
var stamina: int = 10

# Secondary stats derived from primaries + equipment + level
var health: int = 100
var max_health: int = 100
var mana: int = 100
var max_mana: int = 100

var armor: int = 0
var attack_power: int = 0
var spell_power: int = 0

var crit_chance: float = 0.05
var haste: float = 0.0
var dodge: float = 0.03

# Level-based bonuses
var level_health_bonus: int = 0
var level_mana_bonus: int = 0

func _init():
    pass

func calculate_secondary_stats(equipment_stats: Dictionary = {}) -> void:
    # Base calculations from primary stats
    var base_attack_power: int = strength * 2 + agility
    var base_spell_power: int = intellect * 2
    var base_armor: int = agility
    var base_crit: float = agility * 0.001
    var base_dodge: float = agility * 0.001
    
    # Add equipment bonuses
    attack_power = base_attack_power + equipment_stats.get("attack", 0)
    spell_power = base_spell_power + equipment_stats.get("spell_power", 0)
    armor = base_armor + equipment_stats.get("armor", 0)
    
    # Add level-based health/mana bonuses
    max_health = 100 + (stamina * 10) + level_health_bonus
    max_mana = 100 + (intellect * 10) + level_mana_bonus
    
    # Calculate crit and dodge with diminishing returns
    crit_chance = 0.05 + base_crit + equipment_stats.get("crit", 0)
    if crit_chance > 0.75:
        crit_chance = 0.75
    
    dodge = 0.03 + base_dodge + equipment_stats.get("dodge", 0) + (agility * 0.0005)
    if dodge > 0.50:
        dodge = 0.50
    
    # Haste from equipment only (or special buffs)
    haste = equipment_stats.get("haste", 0.0)

func update_level_bonuses(level_data: Dictionary) -> void:
    level_health_bonus = level_data.get("health_bonus", 0)
    level_mana_bonus = level_data.get("mana_bonus", 0)
    max_health = 100 + (stamina * 10) + level_health_bonus
    max_mana = 100 + (intellect * 10) + level_mana_bonus

func to_snapshot() -> Dictionary:
    return {
        "strength": strength,
        "agility": agility,
        "intellect": intellect,
        "spirit": spirit,
        "stamina": stamina,
        "health": health,
        "max_health": max_health,
        "mana": mana,
        "max_mana": max_mana,
        "armor": armor,
        "attack_power": attack_power,
        "spell_power": spell_power,
        "crit_chance": round(crit_chance * 10000) / 100,
        "haste": round(haste * 100),
        "dodge": round(dodge * 10000) / 100
    }

func from_snapshot(snapshot: Dictionary) -> void:
    strength = snapshot.get("strength", 10)
    agility = snapshot.get("agility", 10)
    intellect = snapshot.get("intellect", 10)
    spirit = snapshot.get("spirit", 10)
    stamina = snapshot.get("stamina", 10)
    health = snapshot.get("health", health)
    mana = snapshot.get("mana", mana)
    armor = snapshot.get("armor", 0)
    attack_power = snapshot.get("attack_power", 0)
    spell_power = snapshot.get("spell_power", 0)
    crit_chance = snapshot.get("crit_chance", 0.05) / 100.0
    haste = snapshot.get("haste", 0.0) / 100.0
    dodge = snapshot.get("dodge", 0.03) / 100.0
