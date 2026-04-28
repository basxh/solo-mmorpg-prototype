extends CanvasLayer

@onready var panel_container: PanelContainer = $PanelContainer
@onready var level_value_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HeaderSection/LevelValue
@onready var xp_progress_bar: ProgressBar = $PanelContainer/MarginContainer/VBoxContainer/HeaderSection/XpBarContainer/XpProgress
@onready var xp_value_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HeaderSection/XpBarContainer/XpValue
@onready var rest_bonus_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HeaderSection/RestBonusLabel

# Stats section labels
@onready var strength_value: Label = $PanelContainer/MarginContainer/VBoxContainer/StatsGridContainer/StrengthRow/StrengthValue
@onready var agility_value: Label = $PanelContainer/MarginContainer/VBoxContainer/StatsGridContainer/AgilityRow/AgilityValue
@onready var intellect_value: Label = $PanelContainer/MarginContainer/VBoxContainer/StatsGridContainer/IntellectRow/IntellectValue
@onready var spirit_value: Label = $PanelContainer/MarginContainer/VBoxContainer/StatsGridContainer/SpiritRow/SpiritValue
@onready var stamina_value: Label = $PanelContainer/MarginContainer/VBoxContainer/StatsGridContainer/StaminaRow/StaminaValue

# Derived stats
@onready var health_value: Label = $PanelContainer/MarginContainer/VBoxContainer/DerivedStatsGrid/HealthRow/HealthValue
@onready var mana_value: Label = $PanelContainer/MarginContainer/VBoxContainer/DerivedStatsGrid/ManaRow/ManaValue
@onready var armor_value: Label = $PanelContainer/MarginContainer/VBoxContainer/DerivedStatsGrid/ArmorRow/ArmorValue
@onready var attack_power_value: Label = $PanelContainer/MarginContainer/VBoxContainer/DerivedStatsGrid/AttackPowerRow/AttackPowerValue
@onready var spell_power_value: Label = $PanelContainer/MarginContainer/VBoxContainer/DerivedStatsGrid/SpellPowerRow/SpellPowerValue

# Crit/Haste/Dodge
@onready var crit_value: Label = $PanelContainer/MarginContainer/VBoxContainer/DerivedStatsGrid/CritRow/CritValue
@onready var haste_value: Label = $PanelContainer/MarginContainer/VBoxContainer/DerivedStatsGrid/HasteRow/HasteValue
@onready var dodge_value: Label = $PanelContainer/MarginContainer/VBoxContainer/DerivedStatsGrid/DodgeRow/DodgeValue

var is_visible: bool = false

func _ready():
    panel_container.visible = false

func toggle_visibility():
    is_visible = not is_visible
    panel_container.visible = is_visible

func show_panel():
    is_visible = true
    panel_container.visible = true

func hide_panel():
    is_visible = false
    panel_container.visible = false

func apply_progression_snapshot(snapshot: Dictionary) -> void:
    var level: int = snapshot.get("level", 1)
    var current_xp: int = snapshot.get("current_xp", 0)
    var xp_to_next: int = snapshot.get("xp_to_next", 400)
    var xp_percent: float = snapshot.get("xp_progress_percent", 0.0)
    var rest_bonus: float = snapshot.get("rest_bonus", 0.0)
    
    level_value_label.text = str(level)
    xp_progress_bar.value = xp_percent
    xp_value_label.text = "%d / %d" % [current_xp, xp_to_next]
    
    if rest_bonus > 0:
        rest_bonus_label.text = "Rest Bonus: +%d%% XP" % int(rest_bonus)
        rest_bonus_label.visible = true
    else:
        rest_bonus_label.visible = false
    
    var stats: Dictionary = snapshot.get("stats", {})
    apply_stats_snapshot(stats)

func apply_stats_snapshot(stats: Dictionary) -> void:
    # Primary stats
    strength_value.text = str(stats.get("strength", 10))
    agility_value.text = str(stats.get("agility", 10))
    intellect_value.text = str(stats.get("intellect", 10))
    spirit_value.text = str(stats.get("spirit", 10))
    stamina_value.text = str(stats.get("stamina", 10))
    
    # Derived stats
    health_value.text = "%d / %d" % [stats.get("health", 100), stats.get("max_health", 100)]
    mana_value.text = "%d / %d" % [stats.get("mana", 100), stats.get("max_mana", 100)]
    armor_value.text = str(stats.get("armor", 0))
    attack_power_value.text = str(stats.get("attack_power", 0))
    spell_power_value.text = str(stats.get("spell_power", 0))
    
    # Percentage stats
    var crit_percent: float = stats.get("crit_chance", 5.0)
    crit_value.text = "%.2f%%" % crit_percent
    
    var haste_percent: float = stats.get("haste", 0.0)
    haste_value.text = "%.1f%%" % haste_percent
    
    var dodge_percent: float = stats.get("dodge", 3.0)
    dodge_value.text = "%.2f%%" % dodge_percent
