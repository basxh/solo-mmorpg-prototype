"""
Task 27: Character Progression Scaffold Tests
Tests for level system, XP gain, character stats, and character panel.
"""

import os
import sys
import json
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))


class TestCharacterProgressionScaffold(unittest.TestCase):
    """Verify Task 27 character progression system scaffold is complete."""

    def test_progression_service_script_exists(self):
        """Progression service script must exist."""
        path = os.path.join(
            REPO_ROOT, "client", "scripts", "progression", "progression_service.gd"
        )
        self.assertTrue(os.path.isfile(path), f"Missing: {path}")

    def test_character_stats_script_exists(self):
        """Character stats data structure script must exist."""
        path = os.path.join(
            REPO_ROOT, "client", "scripts", "progression", "character_stats.gd"
        )
        self.assertTrue(os.path.isfile(path), f"Missing: {path}")

    def test_character_panel_scene_exists(self):
        """Character panel UI scene must exist."""
        path = os.path.join(
            REPO_ROOT, "client", "scenes", "ui", "character_panel.tscn"
        )
        self.assertTrue(os.path.isfile(path), f"Missing: {path}")

    def test_character_panel_script_exists(self):
        """Character panel UI script must exist."""
        path = os.path.join(
            REPO_ROOT, "client", "scripts", "ui", "character_panel.gd"
        )
        self.assertTrue(os.path.isfile(path), f"Missing: {path}")

    def test_xp_curve_json_exists(self):
        """XP curve JSON must exist."""
        path = os.path.join(
            REPO_ROOT, "shared", "content", "progression", "xp_curve.json"
        )
        self.assertTrue(os.path.isfile(path), f"Missing: {path}")

    def test_xp_curve_has_levels(self):
        """XP curve must define levels 1-60 with requirements."""
        path = os.path.join(
            REPO_ROOT, "shared", "content", "progression", "xp_curve.json"
        )
        with open(path, "r") as f:
            data = json.load(f)
        self.assertIn("levels", data)
        levels = data["levels"]
        self.assertEqual(len(levels), 60)
        for i in range(1, 61):
            level_key = str(i)
            self.assertIn(level_key, levels)
            self.assertIn("xp_required", levels[level_key])
            self.assertIn("xp_to_next", levels[level_key])

    def test_level_formula_type_defined(self):
        """XP curve should have formula type for level calculation."""
        path = os.path.join(
            REPO_ROOT, "shared", "content", "progression", "xp_curve.json"
        )
        with open(path, "r") as f:
            data = json.load(f)
        self.assertIn("level_formula", data)
        self.assertEqual(data["level_formula"], "exponential")

    def test_progression_service_classname(self):
        """Progression service must define class_name ProgressionService."""
        path = os.path.join(
            REPO_ROOT, "client", "scripts", "progression", "progression_service.gd"
        )
        with open(path, "r") as f:
            content = f.read()
        self.assertIn("class_name ProgressionService", content)

    def test_character_panel_instantiable(self):
        """Character panel scene must be loadable format."""
        path = os.path.join(
            REPO_ROOT, "client", "scenes", "ui", "character_panel.tscn"
        )
        with open(path, "r") as f:
            content = f.read()
        self.assertIn("[gd_scene", content)
        self.assertIn("CanvasLayer", content)

    def test_character_panel_has_level_display(self):
        """Character panel must have level label."""
        path = os.path.join(
            REPO_ROOT, "client", "scenes", "ui", "character_panel.tscn"
        )
        with open(path, "r") as f:
            content = f.read()
        self.assertTrue(
            "level_value" in content.lower() or "LevelValue" in content,
            "Missing level_value label"
        )

    def test_character_panel_has_xp_display(self):
        """Character panel must have XP progress display."""
        path = os.path.join(
            REPO_ROOT, "client", "scenes", "ui", "character_panel.tscn"
        )
        with open(path, "r") as f:
            content = f.read()
        self.assertTrue(
            "xp_progress" in content.lower() or "XpProgress" in content or "XPProgress" in content,
            "Missing xp_progress element"
        )

    def test_character_panel_has_stats_display(self):
        """Character panel must display core stats."""
        path = os.path.join(
            REPO_ROOT, "client", "scenes", "ui", "character_panel.tscn"
        )
        with open(path, "r") as f:
            content = f.read().lower()
        self.assertIn("strength", content)
        self.assertIn("stamina", content)
        self.assertIn("agility", content)

    def test_progression_service_signals(self):
        """Progression service must emit level_up and xp_gained signals."""
        path = os.path.join(
            REPO_ROOT, "client", "scripts", "progression", "progression_service.gd"
        )
        with open(path, "r") as f:
            content = f.read()
        self.assertIn('signal level_up', content)
        self.assertIn('signal xp_gained', content)

    def test_progression_service_methods(self):
        """Progression service must have key methods."""
        path = os.path.join(
            REPO_ROOT, "client", "scripts", "progression", "progression_service.gd"
        )
        with open(path, "r") as f:
            content = f.read()
        self.assertIn("func gain_xp", content)
        self.assertIn("func get_current_level()", content)
        self.assertIn("func get_xp_to_next_level()", content)

    def test_hud_integrates_progression(self):
        """Game HUD must integrate character panel."""
        hud_scene_path = os.path.join(
            REPO_ROOT, "client", "scenes", "ui", "game_hud.tscn"
        )
        hud_script_path = os.path.join(
            REPO_ROOT, "client", "scripts", "ui", "game_hud.gd"
        )

        with open(hud_scene_path, "r") as f:
            scene_content = f.read()

        with open(hud_script_path, "r") as f:
            script_content = f.read()

        self.assertIn("character_panel", scene_content)
        self.assertIn("CharacterPanel", scene_content)
        self.assertIn("set_progression_service", script_content)


if __name__ == "__main__":
    unittest.main()
