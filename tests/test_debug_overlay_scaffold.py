"""
Task 24: Debug Overlay Scaffold Tests
Metrics-friendly developer overlay for solo iteration speed.
"""
import pytest
import json
from pathlib import Path

REPO_ROOT = Path(__file__).parent.parent
CLIENT_ROOT = REPO_ROOT / "client"

def test_debug_overlay_service_exists():
    """DebugOverlayService GDScript sollte existieren."""
    service_path = CLIENT_ROOT / "scripts" / "debug" / "debug_overlay_service.gd"
    assert service_path.exists(), f"DebugOverlayService nicht gefunden: {service_path}"

def test_debug_overlay_ui_scene_exists():
    """DebugOverlay UI Scene sollte existieren."""
    scene_path = CLIENT_ROOT / "scenes" / "ui" / "debug_overlay.tscn"
    assert scene_path.exists(), f"DebugOverlay Scene nicht gefunden: {scene_path}"

def test_debug_overlay_script_exists():
    """DebugOverlay UI Script sollte existieren."""
    script_path = CLIENT_ROOT / "scripts" / "ui" / "debug_overlay.gd"
    assert script_path.exists(), f"DebugOverlay Script nicht gefunden: {script_path}"

def test_debug_overlay_service_has_toggle():
    """Service sollte toggle_is_active() Methode haben."""
    service_path = CLIENT_ROOT / "scripts" / "debug" / "debug_overlay_service.gd"
    content = service_path.read_text()
    assert "func toggle_is_active" in content or "var is_active" in content, "toggle_is_active() fehlt"

def test_debug_overlay_service_tracks_fps():
    """Service sollte FPS tracken."""
    service_path = CLIENT_ROOT / "scripts" / "debug" / "debug_overlay_service.gd"
    content = service_path.read_text()
    assert "fps" in content.lower() or "Engine.get_frames_per_second" in content, "FPS tracking fehlt"

def test_debug_overlay_service_tracks_ping():
    """Service sollte simulierten Ping tracken."""
    service_path = CLIENT_ROOT / "scripts" / "debug" / "debug_overlay_service.gd"
    content = service_path.read_text()
    assert "ping" in content.lower(), "Ping tracking fehlt"

def test_debug_overlay_service_tracks_entity_counts():
    """Service sollte NPC/Enemy counts tracken."""
    service_path = CLIENT_ROOT / "scripts" / "debug" / "debug_overlay_service.gd"
    content = service_path.read_text()
    assert "entity_count" in content.lower() or "npc_count" in content.lower() or "enemy_count" in content.lower(), "Entity counts fehlen"

def test_debug_overlay_service_tracks_zone():
    """Service sollte aktuelle Zone tracken."""
    service_path = CLIENT_ROOT / "scripts" / "debug" / "debug_overlay_service.gd"
    content = service_path.read_text()
    assert "zone" in content.lower() or "zone_id" in content.lower(), "Zone tracking fehlt"

def test_debug_overlay_service_tracks_position():
    """Service sollte Player Position tracken."""
    service_path = CLIENT_ROOT / "scripts" / "debug" / "debug_overlay_service.gd"
    content = service_path.read_text()
    assert "position" in content.lower() or "player_position" in content.lower() or "Vector3" in content, "Position tracking fehlt"

def test_debug_overlay_service_tracks_target_id():
    """Service sollte Target ID tracken."""
    service_path = CLIENT_ROOT / "scripts" / "debug" / "debug_overlay_service.gd"
    content = service_path.read_text()
    assert "target_id" in content.lower() or "current_target" in content.lower(), "Target ID tracking fehlt"

def test_debug_overlay_service_builds_snapshot():
    """Service sollte build_snapshot() Methode haben."""
    service_path = CLIENT_ROOT / "scripts" / "debug" / "debug_overlay_service.gd"
    content = service_path.read_text()
    assert "func build_snapshot" in content, "build_snapshot() fehlt"

def test_debug_overlay_ui_has_labels():
    """UI sollte Labels für Metriken haben."""
    scene_path = CLIENT_ROOT / "scenes" / "ui" / "debug_overlay.tscn"
    content = scene_path.read_text()
    assert "Label" in content, "DebugOverlay Scene hat keine Labels"

def test_debug_overlay_toggled_by_f1():
    """Overlay sollte per F1 toggelbar sein."""
    script_path = CLIENT_ROOT / "scripts" / "ui" / "debug_overlay.gd"
    content = script_path.read_text()
    assert "F1" in content or "debug_toggle" in content.lower() or "toggle_debug" in content.lower(), "F1 toggle fehlt"

def test_world_root_wires_debug_overlay():
    """WorldRoot sollte DebugOverlayService instantiieren."""
    world_path = CLIENT_ROOT / "scripts" / "bootstrap" / "world_root.gd"
    content = world_path.read_text()
    assert "DebugOverlayService" in content, "WorldRoot hat DebugOverlayService nicht"

def test_game_hud_includes_debug_overlay():
    """GameHUD sollte DebugOverlay als Child haben."""
    hud_path = CLIENT_ROOT / "scenes" / "ui" / "game_hud.tscn"
    content = hud_path.read_text()
    assert "debug_overlay" in content.lower() or "DebugOverlay" in content, "GameHUD hat DebugOverlay nicht"
