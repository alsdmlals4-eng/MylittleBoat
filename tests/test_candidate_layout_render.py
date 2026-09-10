# 후보 레이어의 실제 렌더 출력과 원본 보호 동작을 검사한다.
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
GODOT = os.environ.get('GODOT_BIN', 'C:/Users/user/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe')


@unittest.skipUnless(Path(GODOT).is_file(), 'Set GODOT_BIN for display-render test')
class CandidateLayoutRenderTest(unittest.TestCase):
    def test_render_has_requested_size_and_refuses_overwrite(self):
        # PNG 출력 누락, 잘못된 viewport 규격, 덮어쓰기 회귀를 검출한다.
        with tempfile.TemporaryDirectory(prefix='mlb-layout-test-') as directory:
            output = Path(directory) / 'layout.png'
            command = [GODOT, '--path', str(ROOT / 'tools/candidate-render-project'),
                       '--rendering-method', 'gl_compatibility', '--audio-driver', 'Dummy',
                       '--resolution', '320x240', '--script', str(ROOT / 'tools/render_candidate_layout.gd'),
                       '--', str(ROOT), str(output)]
            result = subprocess.run(command, capture_output=True, text=True, timeout=30)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            with Image.open(output) as image:
                self.assertEqual(image.size, (540, 960))
                self.assertGreater(len(image.getcolors(540 * 960) or []), 100)
                # 가까운 난간이 blue hoodie보다 앞에 있어야 하는 고정 검토 접점.
                red, _, blue = image.convert('RGB').getpixel((250, 858))
                self.assertGreater(red, blue)
            original = output.read_bytes()
            rejected = subprocess.run(command, capture_output=True, text=True, timeout=30)
            self.assertEqual(rejected.returncode, 2, rejected.stdout + rejected.stderr)
            self.assertEqual(output.read_bytes(), original)


if __name__ == '__main__':
    unittest.main()
