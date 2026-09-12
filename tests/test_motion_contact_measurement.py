# 수면 접점 검사가 승인 배치 오프셋과 실제 이탈을 구분하는지 검증한다.
import unittest
from tools import analyze_voyage_motion_capture as motion


class ContactMeasurementTests(unittest.TestCase):
    def test_stern_anchor_does_not_hide_dynamic_separation(self):
        measure = getattr(motion, 'measure_contact_error', None)
        self.assertIsNotNone(measure, 'contact measurement must use an explicit expected anchor')
        frames = [{'boat': [0, -2.7, 0], 'contact': [0, -4.95, 0]},
                  {'boat': [0, -2.65, 0], 'contact': [0, -4.904, 0]}]
        self.assertAlmostEqual(measure(frames, -2.25), 0.004)
        frames[1]['contact'][1] = -5.0
        self.assertGreater(measure(frames, -2.25), 0.012)

    def test_legacy_anchor_and_wrong_anchor_still_fail(self):
        measure = getattr(motion, 'measure_contact_error', None)
        self.assertIsNotNone(measure)
        frames = [{'boat': [0, -2.7, 0], 'contact': [0, -2.705, 0]}]
        self.assertAlmostEqual(measure(frames, 0.0), 0.005)
        self.assertGreater(measure(frames, -2.25), 2.0)
