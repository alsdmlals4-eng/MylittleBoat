# 현재 GDD에서 사람용 블루프린트 PDF와 source-binding receipt를 만든다.
from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path

from reportlab.lib.colors import HexColor
from reportlab.lib.utils import ImageReader
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen import canvas


ROOT = Path(__file__).resolve().parents[1]
GDD_PATH = ROOT / "docs/design/PROJECT_GDD.md"
DEFAULT_OUTPUT = ROOT / "output/pdf/MY_LITTLE_BOAT_HUMAN_GAME_BLUEPRINT_20260902.pdf"
DEFAULT_RECEIPT = ROOT / "output/pdf/MY_LITTLE_BOAT_HUMAN_GAME_BLUEPRINT_20260902.receipt.json"
PAGE_WIDTH = 1280.0
PAGE_HEIGHT = 720.0
MARGIN = 64.0

NAVY = HexColor("#123D54")
DEEP_NAVY = HexColor("#092C3E")
INK = HexColor("#163F59")
SEA = HexColor("#287A9F")
FOAM = HexColor("#DCEFF3")
PAPER = HexColor("#F7F3EC")
CARD = HexColor("#FFFFFF")
MIST = HexColor("#EAF4F7")
MUTED = HexColor("#527184")
WARM = HexColor("#EBAE55")
GREEN = HexColor("#4F9D8C")
RED = HexColor("#B55D59")

REGULAR_FONT = "MLBMalgun"
BOLD_FONT = "MLBMalgunBold"

IMAGE_INPUTS = (
    "assets/images/brand/my_little_boat_title_lockup_v1.png",
    "docs/evidence/2026-08-31-title-boat-flow/bright_title_idle_00_540x960.png",
    "docs/evidence/2026-08-31-title-boat-flow/bright_voyage_started_02_540x960.png",
    "docs/evidence/2026-09-02-forward-voyage-flow/bright_voyage_forward_flow_start_540x960.png",
    "docs/evidence/2026-09-02-forward-voyage-flow/bright_voyage_forward_flow_after_540x960.png",
    "docs/evidence/2026-09-01-look-around-foreground-split/port_flow_1800ms_540x960.png",
    "docs/evidence/2026-08-31-split-sky-sea-background/dawn_normal_540x960.png",
    "docs/evidence/2026-08-31-split-sky-sea-background/bright_normal_540x960.png",
    "docs/evidence/2026-08-31-split-sky-sea-background/sunset_normal_540x960.png",
    "docs/evidence/2026-08-31-split-sky-sea-background/night_normal_540x960.png",
    "docs/evidence/2026-09-01-bright-spring-seasonal-parallax/bright_spring_normal_540x960.png",
    "docs/evidence/2026-08-31-calm-fishing-interactions/pet_rest_together_540x960.png",
    "docs/evidence/2026-08-30-comfort-postcards/album_recent_postcards_540x960.png",
)


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def source_revision() -> str:
    return f"content-bound:{sha256_file(GDD_PATH)[:16]}:{sha256_file(Path(__file__))[:16]}"


def register_fonts() -> None:
    font_pairs = (
        (Path(r"C:\Windows\Fonts\malgun.ttf"), REGULAR_FONT),
        (Path(r"C:\Windows\Fonts\malgunbd.ttf"), BOLD_FONT),
    )
    for font_path, font_name in font_pairs:
        if not font_path.is_file():
            raise FileNotFoundError(f"Korean-capable font not found: {font_path}")
        if font_name not in pdfmetrics.getRegisteredFontNames():
            pdfmetrics.registerFont(TTFont(font_name, str(font_path)))


def clean_markdown(value: str) -> str:
    return re.sub(r"[`*_]", "", value).replace("→", "→").strip()


def section_text(gdd: str, heading: str, limit: int = 380) -> str:
    marker = f"### {heading}"
    start = gdd.find(marker)
    if start < 0:
        return ""
    body_start = start + len(marker)
    next_heading = re.search(r"\n#{1,3} ", gdd[body_start:])
    body = gdd[body_start : body_start + next_heading.start()] if next_heading else gdd[body_start:]
    lines: list[str] = []
    for line in body.splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith("|") or stripped.startswith("**상태"):
            continue
        if stripped.startswith("**"):
            stripped = stripped.replace("**", "")
        lines.append(clean_markdown(stripped.lstrip("- ")))
    compact = " ".join(lines)
    return compact[:limit].rsplit(" ", 1)[0] if len(compact) > limit else compact


def gdd_quote(gdd: str) -> str:
    match = re.search(r"### 플레이어 약속\s+>\s*“([^”]+)”", gdd, re.DOTALL)
    return clean_markdown(match.group(1)) if match else "목적지 없이, 동반자와, 잔잔한 바다를 지나며 쉰다."


def flow_lines(gdd: str) -> list[str]:
    marker = "### 확정된 첫 경험"
    start = gdd.find(marker)
    if start < 0:
        return ["타이틀 대기", "항해 시작", "같이 머무르기", "원할 때만 작은 행동"]
    code = re.search(r"```text\s*(.*?)\s*```", gdd[start:], re.DOTALL)
    if not code:
        return ["타이틀 대기", "항해 시작", "같이 머무르기", "원할 때만 작은 행동"]
    return [clean_markdown(item) for item in code.group(1).split("→") if item.strip()]


def wrap_text(value: str, font_name: str, size: float, width: float) -> list[str]:
    words = value.split()
    if not words:
        return []
    lines: list[str] = []
    line = ""
    for word in words:
        candidate = word if not line else f"{line} {word}"
        if pdfmetrics.stringWidth(candidate, font_name, size) <= width:
            line = candidate
            continue
        if line:
            lines.append(line)
            line = ""
        if pdfmetrics.stringWidth(word, font_name, size) <= width:
            line = word
            continue
        chunk = ""
        for character in word:
            if pdfmetrics.stringWidth(chunk + character, font_name, size) > width and chunk:
                lines.append(chunk)
                chunk = character
            else:
                chunk += character
        line = chunk
    if line:
        lines.append(line)
    return lines


def draw_wrapped(
    pdf: canvas.Canvas,
    text: str,
    x: float,
    y: float,
    width: float,
    size: float,
    color: HexColor = INK,
    font_name: str = REGULAR_FONT,
    leading: float | None = None,
    max_lines: int | None = None,
) -> float:
    active_leading = leading or size * 1.55
    lines = wrap_text(text, font_name, size, width)
    if max_lines is not None:
        lines = lines[:max_lines]
    pdf.setFont(font_name, size)
    pdf.setFillColor(color)
    cursor = y
    for line in lines:
        pdf.drawString(x, cursor, line)
        cursor -= active_leading
    return cursor


def draw_card(pdf: canvas.Canvas, x: float, y: float, width: float, height: float, fill: HexColor = CARD) -> None:
    pdf.setFillColor(fill)
    pdf.setStrokeColor(HexColor("#D8E3E8"))
    pdf.roundRect(x, y, width, height, 18, fill=1, stroke=1)


def draw_pill(pdf: canvas.Canvas, label: str, x: float, y: float, fill: HexColor = SEA) -> None:
    size = 12.0
    width = pdfmetrics.stringWidth(label, BOLD_FONT, size) + 28
    pdf.setFillColor(fill)
    pdf.roundRect(x, y, width, 28, 14, fill=1, stroke=0)
    pdf.setFillColor(CARD)
    pdf.setFont(BOLD_FONT, size)
    pdf.drawCentredString(x + width / 2, y + 8, label)


def draw_image_cover(
    pdf: canvas.Canvas,
    path: Path,
    x: float,
    y: float,
    width: float,
    height: float,
    radius: float = 18,
) -> None:
    image = ImageReader(str(path))
    image_width, image_height = image.getSize()
    scale = max(width / image_width, height / image_height)
    draw_width = image_width * scale
    draw_height = image_height * scale
    draw_x = x + (width - draw_width) / 2
    draw_y = y + (height - draw_height) / 2
    pdf.saveState()
    clip = pdf.beginPath()
    clip.roundRect(x, y, width, height, radius)
    pdf.clipPath(clip, stroke=0, fill=0)
    pdf.drawImage(image, draw_x, draw_y, draw_width, draw_height, mask="auto")
    pdf.restoreState()
    pdf.setStrokeColor(HexColor("#D8E3E8"))
    pdf.roundRect(x, y, width, height, radius, fill=0, stroke=1)


def draw_image_contain(
    pdf: canvas.Canvas,
    path: Path,
    x: float,
    y: float,
    width: float,
    height: float,
    fill: HexColor = MIST,
) -> None:
    pdf.setFillColor(fill)
    pdf.roundRect(x, y, width, height, 16, fill=1, stroke=0)
    image = ImageReader(str(path))
    image_width, image_height = image.getSize()
    scale = min(width / image_width, height / image_height)
    draw_width = image_width * scale
    draw_height = image_height * scale
    pdf.drawImage(
        image,
        x + (width - draw_width) / 2,
        y + (height - draw_height) / 2,
        draw_width,
        draw_height,
        mask="auto",
    )
    pdf.setStrokeColor(HexColor("#D8E3E8"))
    pdf.roundRect(x, y, width, height, 16, fill=0, stroke=1)


def draw_page_header(pdf: canvas.Canvas, index: int, eyebrow: str, title: str, subtitle: str = "") -> None:
    pdf.setFillColor(PAPER)
    pdf.rect(0, 0, PAGE_WIDTH, PAGE_HEIGHT, fill=1, stroke=0)
    draw_pill(pdf, eyebrow, MARGIN, PAGE_HEIGHT - 58)
    pdf.setFillColor(INK)
    pdf.setFont(BOLD_FONT, 32)
    pdf.drawString(MARGIN, PAGE_HEIGHT - 112, title)
    if subtitle:
        draw_wrapped(pdf, subtitle, MARGIN, PAGE_HEIGHT - 144, PAGE_WIDTH - MARGIN * 2, 15, MUTED, leading=22, max_lines=2)
    draw_footer(pdf, index)


def draw_footer(pdf: canvas.Canvas, index: int) -> None:
    pdf.setStrokeColor(HexColor("#C9DDE4"))
    pdf.line(MARGIN, 38, PAGE_WIDTH - MARGIN, 38)
    pdf.setFillColor(MUTED)
    pdf.setFont(REGULAR_FONT, 10)
    pdf.drawString(MARGIN, 20, "MY LITTLE BOAT · Current Human Game Blueprint · source: PROJECT_GDD.md")
    pdf.drawRightString(PAGE_WIDTH - MARGIN, 20, f"{index:02d} / 10")


def draw_step(pdf: canvas.Canvas, number: int, title: str, detail: str, x: float, y: float, width: float) -> None:
    draw_card(pdf, x, y, width, 142)
    pdf.setFillColor(SEA)
    pdf.circle(x + 34, y + 105, 18, fill=1, stroke=0)
    pdf.setFillColor(CARD)
    pdf.setFont(BOLD_FONT, 16)
    pdf.drawCentredString(x + 34, y + 99, str(number))
    pdf.setFillColor(INK)
    pdf.setFont(BOLD_FONT, 18)
    pdf.drawString(x + 64, y + 101, title)
    draw_wrapped(pdf, detail, x + 24, y + 70, width - 48, 13, MUTED, leading=20, max_lines=3)


def draw_cover(pdf: canvas.Canvas, gdd: str) -> None:
    pdf.setFillColor(DEEP_NAVY)
    pdf.rect(0, 0, PAGE_WIDTH, PAGE_HEIGHT, fill=1, stroke=0)
    pdf.setFillColor(SEA)
    pdf.circle(1100, 660, 230, fill=1, stroke=0)
    pdf.setFillColor(HexColor("#1D607D"))
    pdf.circle(1100, 660, 165, fill=1, stroke=0)
    brand = ROOT / IMAGE_INPUTS[0]
    pdf.drawImage(str(brand), 72, 520, 480, 120, preserveAspectRatio=True, anchor="w", mask="auto")
    pdf.setFillColor(CARD)
    pdf.setFont(BOLD_FONT, 34)
    pdf.drawString(72, 438, "파도 위에서, 함께 쉬는 시간")
    draw_wrapped(pdf, gdd_quote(gdd), 72, 394, 510, 17, FOAM, leading=27, max_lines=3)
    draw_pill(pdf, "CURRENT HUMAN BLUEPRINT · 2026.09.02", 72, 300, WARM)
    draw_image_contain(pdf, ROOT / IMAGE_INPUTS[1], 690, 82, 440, 540)
    pdf.setFillColor(FOAM)
    pdf.setFont(REGULAR_FONT, 11)
    pdf.drawString(72, 70, "GDD source-bound publication · Runtime capture is machine evidence, not Human / Device PASS")
    pdf.setFillColor(FOAM)
    pdf.setFont(BOLD_FONT, 12)
    pdf.drawRightString(PAGE_WIDTH - 72, 70, "01 / 10")
    pdf.showPage()


def draw_title_wait(pdf: canvas.Canvas, gdd: str) -> None:
    draw_page_header(pdf, 2, "FIRST 30 SECONDS", "열면 이미, 같은 보트 위에", "선택 화면보다 먼저 실제 보트·동반자·바다가 보이고, 출발은 한 번의 조용한 선택이다.")
    draw_image_contain(pdf, ROOT / IMAGE_INPUTS[1], 64, 78, 392, 474)
    draw_card(pdf, 494, 340, 722, 212)
    pdf.setFillColor(INK)
    pdf.setFont(BOLD_FONT, 23)
    pdf.drawString(526, 503, "타이틀 대기 → 항해 시작 → 쉬는 메뉴")
    draw_wrapped(
        pdf,
        "타이틀 대기에서는 보트가 잔잔히 떠 있지만 항해 시간·기억·보상은 시작하지 않는다. ‘항해 시작’ 뒤에만 같은 장면이 normal voyage로 이어진다.",
        526,
        458,
        650,
        16,
        MUTED,
        leading=26,
        max_lines=4,
    )
    steps = flow_lines(gdd)
    x_positions = (494, 737, 980)
    for index, (title, x) in enumerate(zip(steps[:3], x_positions), start=1):
        draw_card(pdf, x, 124, 214, 162, MIST)
        pdf.setFillColor(SEA)
        pdf.setFont(BOLD_FONT, 14)
        pdf.drawString(x + 20, 244, f"0{index}")
        draw_wrapped(pdf, title, x + 20, 210, 174, 17, INK, BOLD_FONT, 25, 3)
    pdf.showPage()


def draw_normal_voyage(pdf: canvas.Canvas, gdd: str) -> None:
    draw_page_header(pdf, 3, "NORMAL DIORAMA", "보트·동반자·바다는 한 장면", "첫 화면의 중심은 목표 패널이 아니라, 함께 쉬는 관계와 넓은 수평선이다.")
    draw_image_cover(pdf, ROOT / IMAGE_INPUTS[2], 64, 82, 438, 470)
    draw_card(pdf, 542, 300, 674, 252)
    pdf.setFillColor(INK)
    pdf.setFont(BOLD_FONT, 23)
    pdf.drawString(576, 500, "기본 Normal 3/4 diorama")
    draw_wrapped(pdf, section_text(gdd, "플레이어 약속", 410), 576, 457, 596, 16, MUTED, leading=27, max_lines=5)
    cards = (
        ("후면 3/4", "플레이어는 보트 뒤쪽에 기대고, 동반자는 바로 옆에 보인다."),
        ("하단 20%", "보트는 세로 화면의 하단에 머물러 넓은 바다를 가리지 않는다."),
        ("수면 접점", "waterline·ripple이 보트 bob을 따라 떠 있는 합성을 막는다."),
    )
    for index, (title, detail) in enumerate(cards):
        draw_step(pdf, index + 1, title, detail, 542 + index * 222, 94, 204)
    pdf.showPage()


def draw_forward_water(pdf: canvas.Canvas) -> None:
    draw_page_header(pdf, 4, "VOYAGE MOTION", "항해가 시작되면, 물이 앞으로 흐른다", "보트의 작은 surge와 가까운 수면의 depth-weighted 흐름이 함께 전진감을 만든다.")
    draw_image_cover(pdf, ROOT / IMAGE_INPUTS[3], 64, 98, 428, 410)
    draw_image_cover(pdf, ROOT / IMAGE_INPUTS[4], 520, 98, 428, 410)
    draw_card(pdf, 980, 98, 236, 410, MIST)
    pdf.setFillColor(SEA)
    pdf.setFont(BOLD_FONT, 18)
    pdf.drawString(1008, 458, "보이는 계약")
    draw_wrapped(pdf, "하늘은 고정, 바다만 흐름", 1008, 410, 178, 20, INK, BOLD_FONT, 31, 3)
    draw_wrapped(
        pdf,
        "타이틀 대기는 부유만 유지한다. 항해를 시작하면 가까운 물결이 수평선에서 화면 하단으로 흐르고, 고요 설정에서는 자동 움직임을 멈춘다.",
        1008,
        286,
        178,
        14,
        MUTED,
        leading=22,
        max_lines=7,
    )
    pdf.setFillColor(GREEN)
    pdf.setFont(BOLD_FONT, 13)
    pdf.drawString(64, 62, "START")
    pdf.drawString(520, 62, "+ 2.0s")
    pdf.showPage()


def draw_camera_choice(pdf: canvas.Canvas, gdd: str) -> None:
    draw_page_header(pdf, 5, "CAMERA CHOICE", "원하면 둘러보고, 원하면 바다만 본다", "시점은 바꾸지만 항해 시간·보상·저장·사운드스케이프의 의미는 바꾸지 않는다.")
    draw_image_cover(pdf, ROOT / IMAGE_INPUTS[5], 64, 88, 430, 438)
    draw_card(pdf, 532, 300, 684, 226)
    pdf.setFillColor(INK)
    pdf.setFont(BOLD_FONT, 23)
    pdf.drawString(566, 476, "둘러보기와 감상 카메라")
    draw_wrapped(pdf, section_text(gdd, "둘러보기", 420), 566, 430, 606, 15, MUTED, leading=24, max_lines=6)
    camera_cards = (
        ("Normal", "동반자·보트·바다를 함께 본다."),
        ("Look Around", "드래그로 좌·우·뒤·위를 천천히 본다."),
        ("Appreciation", "대부분의 UI를 줄여 수평선에 집중한다."),
    )
    for index, (title, detail) in enumerate(camera_cards):
        draw_card(pdf, 532 + index * 226, 102, 206, 150, CARD)
        pdf.setFillColor(SEA if index == 0 else GREEN if index == 1 else WARM)
        pdf.setFont(BOLD_FONT, 17)
        pdf.drawString(554 + index * 226, 210, title)
        draw_wrapped(pdf, detail, 554 + index * 226, 174, 160, 13, MUTED, leading=20, max_lines=3)
    pdf.showPage()


def draw_time_layers(pdf: canvas.Canvas) -> None:
    draw_page_header(pdf, 6, "TIME & LAYERS", "같은 바다, 네 가지 빛, 두 개의 움직임", "기기의 현지 시각은 분위기만 고르고, 저장·보상·진행도는 바꾸지 않는다.")
    image_paths = IMAGE_INPUTS[6:10]
    labels = ("DAWN · 새벽", "BRIGHT · 낮", "SUNSET · 노을", "NIGHT · 밤")
    for index, (relative_path, label) in enumerate(zip(image_paths, labels)):
        column = index % 2
        row = 1 - index // 2
        x = 64 + column * 588
        y = 86 + row * 222
        draw_image_cover(pdf, ROOT / relative_path, x, y, 546, 182)
        pdf.setFillColor(DEEP_NAVY)
        pdf.roundRect(x + 14, y + 14, 132, 28, 14, fill=1, stroke=0)
        pdf.setFillColor(CARD)
        pdf.setFont(BOLD_FONT, 11)
        pdf.drawCentredString(x + 80, y + 23, label)
    draw_card(pdf, 704, 86, 512, 88, CARD)
    pdf.setFillColor(INK)
    pdf.setFont(BOLD_FONT, 17)
    pdf.drawString(730, 137, "하늘은 고정 · 바다는 계속 흐름")
    draw_wrapped(pdf, "시간대는 빛과 색의 언어다. 수평선과 구름은 안정적으로 머물고, SeaBackdrop만 낮은 속도로 흐른다.", 730, 112, 450, 13, MUTED, leading=18, max_lines=2)
    pdf.showPage()


def draw_scenery(pdf: canvas.Canvas, gdd: str) -> None:
    draw_page_header(pdf, 7, "PASSING SCENERY", "섬은 멀리, 보트는 바다를 지난다", "자연경관은 도착지나 보상 노드가 아니라, 같은 장소가 살아 있다는 낮은 밀도의 배경 감각이다.")
    draw_image_cover(pdf, ROOT / IMAGE_INPUTS[10], 64, 82, 468, 438)
    draw_card(pdf, 570, 286, 646, 234)
    pdf.setFillColor(INK)
    pdf.setFont(BOLD_FONT, 22)
    pdf.drawString(604, 470, "수평선에서 조용히 지나가기")
    draw_wrapped(pdf, section_text(gdd, "흘러가는 풍경과 배경 발견 연출", 460), 604, 427, 566, 15, MUTED, leading=24, max_lines=6)
    bullets = ("낮은 밀도 · 보이지 않아도 정상", "하단 보트 항로와 겹치지 않음", "버튼·목적지·보상·과제 없음")
    for index, bullet in enumerate(bullets):
        pdf.setFillColor(GREEN)
        pdf.circle(606, 208 - index * 34, 5, fill=1, stroke=0)
        pdf.setFillColor(INK)
        pdf.setFont(REGULAR_FONT, 14)
        pdf.drawString(622, 201 - index * 34, bullet)
    pdf.showPage()


def draw_optional_actions(pdf: canvas.Canvas, gdd: str) -> None:
    draw_page_header(pdf, 8, "OPTIONAL MOMENTS", "쉬고 싶을 때만, 작은 기억을 남긴다", "아무것도 하지 않아도 완성된 휴식이며, 행동은 점수나 반복 숙제가 아니다.")
    draw_image_contain(pdf, ROOT / IMAGE_INPUTS[11], 64, 80, 314, 430)
    draw_image_contain(pdf, ROOT / IMAGE_INPUTS[12], 408, 80, 314, 430)
    draw_card(pdf, 754, 80, 462, 430, CARD)
    pdf.setFillColor(INK)
    pdf.setFont(BOLD_FONT, 22)
    pdf.drawString(786, 464, "선택할 수 있는 것")
    action_rows = (
        ("사진", "UI 없는 항해 프레임을 Album의 포스트카드로 남긴다."),
        ("조용한 낚시", "catch·무수확·취소 모두 손해 없이 끝난다."),
        ("상호작용", "동반자와 나란히 쉬거나 파도 소리를 듣는다."),
        ("꾸미기", "별도 preview에서 외형·동반자·장식을 바꾼다."),
    )
    cursor = 414
    for title, detail in action_rows:
        pdf.setFillColor(SEA)
        pdf.circle(790, cursor + 4, 5, fill=1, stroke=0)
        pdf.setFillColor(INK)
        pdf.setFont(BOLD_FONT, 15)
        pdf.drawString(808, cursor - 1, title)
        draw_wrapped(pdf, detail, 900, cursor - 1, 278, 12, MUTED, leading=18, max_lines=2)
        cursor -= 78
    pdf.showPage()


def draw_no_pressure(pdf: canvas.Canvas, gdd: str) -> None:
    draw_page_header(pdf, 9, "REST-FIRST BOUNDARY", "이 게임이 하지 않는 것", "휴식의 감정을 깨는 장치들은 화면 구성과 시스템 설계에서 함께 배제한다.")
    draw_card(pdf, 64, 340, 1152, 188, MIST)
    pdf.setFillColor(INK)
    pdf.setFont(BOLD_FONT, 30)
    pdf.drawCentredString(PAGE_WIDTH / 2, 458, "“그냥 머물러도 이미 플레이가 완성된다.”")
    boundaries = (
        ("목적지·도착 보상", "항로를 고르거나 도착을 증명할 필요가 없다."),
        ("실패·경쟁·랭킹", "전투, 실패 상태, 비교와 효율 압박을 만들지 않는다."),
        ("일일 숙제·FOMO", "매분 확인, 연속 출석, 놓친 보상과 이벤트 벌이 없다."),
        ("실시간 소셜 압박", "public feed, presence, read receipt, 인기 시스템이 없다."),
    )
    for index, (title, detail) in enumerate(boundaries):
        x = 64 + (index % 2) * 576
        y = 126 + (1 - index // 2) * 168
        draw_card(pdf, x, y, 544, 136, CARD)
        pdf.setFillColor(RED)
        pdf.setFont(BOLD_FONT, 17)
        pdf.drawString(x + 24, y + 94, title)
        draw_wrapped(pdf, detail, x + 24, y + 62, 492, 13, MUTED, leading=20, max_lines=2)
    pdf.showPage()


def draw_status(pdf: canvas.Canvas) -> None:
    draw_page_header(pdf, 10, "CURRENT STATE", "무엇이 구현됐고, 무엇은 아직 사람의 확인을 기다리는가", "문서 PASS·기계 PASS·renderer capture·Human/Device 검증을 같은 의미로 섞지 않는다.")
    draw_card(pdf, 64, 252, 548, 260, CARD)
    pdf.setFillColor(GREEN)
    pdf.setFont(BOLD_FONT, 19)
    pdf.drawString(96, 466, "Machine / Renderer evidence")
    verified = (
        "타이틀 대기와 항해 시작 흐름",
        "보트·수면 접점과 선택적 고요 모션",
        "고정 하늘·흐르는 바다·항해 전진 수면",
        "둘러보기, 시간대, 먼 자연경관, Album",
    )
    for index, item in enumerate(verified):
        pdf.setFillColor(GREEN)
        pdf.circle(100, 414 - index * 42, 5, fill=1, stroke=0)
        pdf.setFillColor(INK)
        pdf.setFont(REGULAR_FONT, 14)
        pdf.drawString(118, 407 - index * 42, item)
    draw_card(pdf, 650, 252, 566, 260, CARD)
    pdf.setFillColor(RED)
    pdf.setFont(BOLD_FONT, 19)
    pdf.drawString(682, 466, "Human / Device NOT_RUN")
    pending = (
        "실기기 첫 30초와 5분 휴식감",
        "터치 도달성·텍스트 가독성·모션 편안함",
        "오디오의 장시간 편안함과 최종 UX 판단",
    )
    for index, item in enumerate(pending):
        pdf.setFillColor(RED)
        pdf.circle(686, 414 - index * 48, 5, fill=1, stroke=0)
        pdf.setFillColor(INK)
        pdf.setFont(REGULAR_FONT, 14)
        pdf.drawString(704, 407 - index * 48, item)
    draw_card(pdf, 64, 86, 1152, 112, MIST)
    pdf.setFillColor(INK)
    pdf.setFont(BOLD_FONT, 19)
    pdf.drawString(96, 160, "현재 결론")
    draw_wrapped(pdf, "목적지 없는 항해의 현재 구현은 machine/runtime evidence까지 연결되어 있다. 실제 사람이 느끼는 편안함과 최종 승인만은 별도 gate이며, 사용자가 선언하기 전까지 이 PDF도 PASS로 바꾸지 않는다.", 96, 130, 1060, 14, MUTED, leading=21, max_lines=2)
    pdf.showPage()


def build_publication(output: Path, receipt_path: Path) -> None:
    register_fonts()
    for relative_path in IMAGE_INPUTS:
        if not (ROOT / relative_path).is_file():
            raise FileNotFoundError(f"Blueprint image input not found: {relative_path}")
    output.parent.mkdir(parents=True, exist_ok=True)
    receipt_path.parent.mkdir(parents=True, exist_ok=True)
    gdd = GDD_PATH.read_text(encoding="utf-8")
    pdf = canvas.Canvas(str(output), pagesize=(PAGE_WIDTH, PAGE_HEIGHT), pageCompression=1)
    pdf.setTitle("MY LITTLE BOAT · Current Human Game Blueprint")
    pdf.setAuthor("My Little Boat repository")
    draw_cover(pdf, gdd)
    draw_title_wait(pdf, gdd)
    draw_normal_voyage(pdf, gdd)
    draw_forward_water(pdf)
    draw_camera_choice(pdf, gdd)
    draw_time_layers(pdf)
    draw_scenery(pdf, gdd)
    draw_optional_actions(pdf, gdd)
    draw_no_pressure(pdf, gdd)
    draw_status(pdf)
    pdf.save()
    receipt = {
        "artifact": output.relative_to(ROOT).as_posix(),
        "status": "CURRENT_SOURCE_BOUND_DERIVED_PUBLICATION",
        "source_gdd": GDD_PATH.relative_to(ROOT).as_posix(),
        "gdd_sha256": sha256_file(GDD_PATH),
        "generator": Path(__file__).relative_to(ROOT).as_posix(),
        "generator_sha256": sha256_file(Path(__file__)),
        "source_revision": source_revision(),
        "page_count": 10,
        "images": {relative_path: sha256_file(ROOT / relative_path) for relative_path in IMAGE_INPUTS},
        "output_sha256": sha256_file(output),
        "publication_scope": "PROJECT_PLAYER_LAYER + SYSTEM_LAYER + CONTENT_UX_PRESENTATION_LAYER + concise current status; excludes technical receipt detail",
        "evidence_ceiling": "Machine/runtime evidence only. Human, device, accessibility, audio comfort, and release remain NOT_RUN.",
    }
    receipt_path.write_text(json.dumps(receipt, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Build the current My Little Boat Human Blueprint PDF.")
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--receipt", type=Path, default=DEFAULT_RECEIPT)
    return parser.parse_args()


if __name__ == "__main__":
    arguments = parse_args()
    build_publication(arguments.output.resolve(), arguments.receipt.resolve())
