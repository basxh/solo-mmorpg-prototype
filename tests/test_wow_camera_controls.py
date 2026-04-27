import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]


class WowCameraControlsRegressionTest(unittest.TestCase):
    def test_follow_camera_supports_left_and_right_mouse_drag_orbit(self):
        script = (ROOT / 'client/scripts/world/follow_camera_rig.gd').read_text(encoding='utf-8')
        self.assertIn('_unhandled_input', script)
        self.assertIn('InputEventMouseMotion', script)
        self.assertIn('MOUSE_BUTTON_LEFT', script)
        self.assertIn('MOUSE_BUTTON_RIGHT', script)
        self.assertIn('yaw_degrees', script)
        self.assertIn('pitch_degrees', script)
        self.assertIn('is_left_dragging', script)
        self.assertIn('is_right_dragging', script)

    def test_right_mouse_drag_can_turn_player_facing(self):
        camera_script = (ROOT / 'client/scripts/world/follow_camera_rig.gd').read_text(encoding='utf-8')
        player_script = (ROOT / 'client/scripts/player/player_character.gd').read_text(encoding='utf-8')
        self.assertIn('target.call("set_facing_yaw"', camera_script)
        self.assertIn('func set_facing_yaw', player_script)


if __name__ == '__main__':
    unittest.main()
