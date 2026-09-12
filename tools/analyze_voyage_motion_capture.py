# 실제 촬영 시퀀스에서 흐름 방향·연속성·접점을 측정하고 재생 미리보기를 만든다.
import argparse
import hashlib
import json
import shutil
from pathlib import Path
import numpy as np
from PIL import Image


def measure_contact_error(frames, expected_offset_y=0.0):
    return max(abs((f['contact'][1] - f['boat'][1]) - expected_offset_y) for f in frames)


def analyze(folder, contact_offset_y=0.0):
    telemetry = json.loads((folder / 'telemetry.json').read_text(encoding='utf-8'))
    frames = telemetry['frames']
    pictures = [np.asarray(Image.open(p).convert('RGB'), dtype=np.float32) / 255
                for p in sorted(folder.glob('frame_*.png'))]
    shifts = []
    # Match real ocean features away from boat/UI; measure signed passage, not pixel count.
    for i in range(0, len(pictures) - 5, 5):
        a, b = pictures[i], pictures[i + 5]
        for x, y in [(65, 520), (65, 650), (65, 815), (465, 650)]:
            patch = a[y-20:y+20, x-20:x+20]
            patch = patch - patch.mean(axis=(0, 1))
            best = (float('inf'), 0, 0)
            for dy in range(-14, 15):
                for dx in range(-10, 11):
                    sample = b[y-20+dy:y+20+dy, x-20+dx:x+20+dx]
                    sample = sample - sample.mean(axis=(0, 1))
                    mse = float(np.mean((patch - sample) ** 2))
                    if mse < best[0]:
                        best = (mse, dx, dy)
            shifts.append({'seconds': frames[i]['seconds'], 'y': y, 'x': x,
                           'dx': best[1], 'dy': best[2], 'mse': best[0],
                           'dy_per_second': best[2] / (frames[i + 5]['seconds'] - frames[i]['seconds'])})
    sky_error = max(float(np.abs(p[:360] - pictures[0][:360]).max()) for p in pictures)
    contact_gap = measure_contact_error(frames, contact_offset_y)
    deltas = [float(np.abs(b[450:850, :120] - a[450:850, :120]).mean())
              for a, b in zip(pictures, pictures[1:])]
    report = {'mode': telemetry['mode'], 'frame_count': len(frames),
              'duration_seconds': frames[-1]['seconds'] - frames[0]['seconds'],
              'foreground_frames': sum(f['foreground'] for f in frames),
              'sky_max_error': sky_error, 'contact_max_gap_delta': contact_gap,
              'expected_contact_offset_y': contact_offset_y,
              'water_step_mean': float(np.mean(deltas)), 'water_step_max': max(deltas),
              'forward_nonnegative_fraction': sum(s['dy'] >= 0 for s in shifts) / len(shifts),
              'near_median_dy': float(np.median([s['dy_per_second'] for s in shifts if s['y'] == 815])),
              'far_median_dy': float(np.median([s['dy_per_second'] for s in shifts if s['y'] == 520])),
              'shifts': shifts, 'human': 'NOT_RUN'}
    report['accepted'] = (report['foreground_frames'] == len(frames)
                          and report['duration_seconds'] >= 29.0
                          and report['sky_max_error'] < 0.01
                          and report['near_median_dy'] > 0.5
                          and report['forward_nonnegative_fraction'] >= 0.9
                          and report['water_step_mean'] > 0.0001
                          and report['contact_max_gap_delta'] < 0.012)
    return report


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('capture', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--contact-offset-y', type=float, default=0.0,
                        help='Declared asset anchor offset; legacy=0, approved stern parts=-2.25')
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=False)
    report = analyze(args.capture, args.contact_offset_y)
    root = Path(__file__).resolve().parents[1]
    report['source_sha256'] = {p: hashlib.sha256((root / p).read_bytes()).hexdigest() for p in [
        'scripts/voyage/game_scene.gd', 'assets/shaders/voyage_split_sea_flow.gdshader',
        'tests/capture_voyage_realtime_motion.gd', 'tools/analyze_voyage_motion_capture.py']}
    report['captured_frame_sha256'] = {p.name: hashlib.sha256(p.read_bytes()).hexdigest()
                                     for p in sorted(args.capture.glob('frame_*.png'))}
    (args.output / 'motion-analysis.json').write_text(json.dumps(report, indent=2), encoding='utf-8')
    shutil.copyfile(args.capture / 'telemetry.json', args.output / 'telemetry.json')
    # Encode genuine captured frames only; no drawing, in-between generation or speed-up.
    frames = [Image.open(p).convert('RGB') for p in sorted(args.capture.glob('frame_*.png'))]
    times = json.loads((args.capture / 'telemetry.json').read_text(encoding='utf-8'))['frames']
    durations = [max(1, round((b['seconds'] - a['seconds']) * 1000))
                 for a, b in zip(times, times[1:])] + [200]
    frames[0].save(args.output / 'voyage-30s.webp', save_all=True, append_images=frames[1:],
                   duration=durations, loop=0, quality=78, method=4)
    frames[50].save(args.output / 'voyage-10s.png')
    print(json.dumps({k: v for k, v in report.items() if k not in ['shifts', 'captured_frame_sha256']}, indent=2))
    raise SystemExit(0 if report['accepted'] else 1)
