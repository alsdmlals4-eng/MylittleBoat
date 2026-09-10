# 분리 후보 PNG의 실제 alpha와 외곽 여백을 읽기 전용으로 검증한다.
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

from PIL import Image


def inspect(path: Path) -> dict:
    with Image.open(path) as image:
        has_alpha = "A" in image.getbands() or "transparency" in image.info
        alpha = image.convert("RGBA").getchannel("A")
        histogram = alpha.histogram()
        bounds = alpha.getbbox()
        width, height = image.size
        corners = [alpha.getpixel(point) for point in
                   ((0, 0), (width - 1, 0), (0, height - 1), (width - 1, height - 1))]
        padded = bounds is not None and bounds[0] > 0 and bounds[1] > 0 and bounds[2] < width and bounds[3] < height
        passed = has_alpha and histogram[0] > 0 and histogram[255] > 0 and not any(corners) and padded
        return {"path": str(path), "mode": image.mode, "size": [width, height],
                "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
                "transparent_pixels": histogram[0], "opaque_pixels": histogram[255],
                "partial_alpha_pixels": sum(histogram[1:255]), "content_bounds": bounds,
                "corner_alpha": corners, "alpha_gate": "PASS" if passed else "FAIL",
                "evidence_ceiling": "Alpha and padding only; not edge quality, identity, motion, runtime or Human approval"}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("images", nargs="+", type=Path)
    args = parser.parse_args()
    results = [inspect(path) for path in args.images]
    print(json.dumps(results, ensure_ascii=False, indent=2))
    return 0 if all(item["alpha_gate"] == "PASS" for item in results) else 1


if __name__ == "__main__":
    raise SystemExit(main())
