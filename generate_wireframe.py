#!/usr/bin/env python3
"""Generates wireframe.jpg: a high-resolution wireframe of the Little Lemon Home screen."""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

SCALE = 2
PHONE_BOX = (40, 30, 660, 1470)
CANVAS_W, CANVAS_H = 1100 * SCALE, 1520 * SCALE

GREEN = (73, 94, 87)
YELLOW = (244, 206, 20)
PEACH = (238, 153, 114)
LIGHT_GRAY = (237, 239, 238)
MID_GRAY = (190, 194, 192)
CHARCOAL = (51, 51, 51)
RED = (200, 30, 30)
WHITE = (255, 255, 255)


def s(*values):
    return [int(v * SCALE) for v in values]


def font(size):
    try:
        return ImageFont.load_default(size=size * SCALE)
    except TypeError:
        return ImageFont.load_default()


def text(draw, xy, value, size=16, fill=CHARCOAL):
    draw.text(s(*xy), value, fill=fill, font=font(size))


def bar(draw, xy, width, height, fill=MID_GRAY):
    x, y = xy
    draw.rounded_rectangle(s(x, y, x + width, y + height), radius=height * SCALE // 2, fill=fill)


def box(draw, xyxy, radius, fill=None, outline=None, width=1):
    draw.rounded_rectangle(
        s(*xyxy),
        radius=radius * SCALE,
        fill=fill,
        outline=outline,
        width=width * SCALE,
    )


def annotate(draw, target, label_xy, lines):
    draw.line(s(*target, *label_xy), fill=RED, width=2 * SCALE)
    draw.ellipse(s(target[0] - 4, target[1] - 4, target[0] + 4, target[1] + 4), fill=RED)
    text(draw, label_xy, "\n".join(lines), size=15, fill=RED)


def main():
    img = Image.new("RGB", (CANVAS_W, CANVAS_H), WHITE)
    draw = ImageDraw.Draw(img)

    # Phone frame
    box(draw, PHONE_BOX, 28, outline=CHARCOAL, width=3)

    # 1. Header
    draw.ellipse(s(80, 80, 124, 124), fill=YELLOW)
    text(draw, (138, 92), "LITTLE LEMON", size=18, fill=GREEN)
    box(draw, (570, 80, 626, 136), 28, fill=LIGHT_GRAY, outline=GREEN, width=2)

    # 2. Hero
    draw.rectangle(s(41, 170, 659, 575), fill=GREEN)
    text(draw, (70, 190), "Little Lemon", size=38, fill=YELLOW)
    text(draw, (70, 245), "Chicago", size=26, fill=WHITE)
    for i, width in enumerate([300, 290, 280, 220]):
        bar(draw, (70, 320 + i * 26), width, 12, fill=LIGHT_GRAY)
    box(draw, (420, 300, 620, 460), 16, fill=PEACH)

    # Search bar
    box(draw, (70, 485, 630, 540), 8, fill=LIGHT_GRAY)
    draw.ellipse(s(92, 498, 110, 516), outline=CHARCOAL, width=2 * SCALE)
    draw.line(s(108, 514, 118, 524), fill=CHARCOAL, width=2 * SCALE)
    text(draw, (135, 504), "Search menu", size=15, fill=(120, 120, 120))

    # 3. Menu breakdown (category pills, first one active)
    text(draw, (70, 600), "ORDER FOR DELIVERY!", size=22, fill=CHARCOAL)
    pills = [("Starters", 70, 200, True), ("Mains", 220, 330, False),
             ("Desserts", 350, 470, False), ("Drinks", 490, 600, False)]
    for label, x0, x1, active in pills:
        box(draw, (x0, 650, x1, 700), 25, fill=GREEN if active else LIGHT_GRAY)
        text(draw, (x0 + 22, 664), label, size=17, fill=WHITE if active else GREEN)
    draw.line(s(70, 730, 630, 730), fill=MID_GRAY, width=1 * SCALE)

    # 4. Food menu list rows
    for row in range(3):
        y = 750 + row * 170
        text(draw, (70, y + 20), "Dish title", size=20, fill=CHARCOAL)
        bar(draw, (70, y + 58), 380, 12)
        bar(draw, (70, y + 80), 330, 12)
        text(draw, (70, y + 115), "$00.00", size=18, fill=GREEN)
        box(draw, (500, y + 20, 620, y + 140), 8, fill=PEACH)
        if row < 2:
            draw.line(s(70, y + 165, 630, y + 165), fill=LIGHT_GRAY, width=2 * SCALE)

    # Side annotations
    annotate(draw, (626, 108), (720, 80),
             ["1. Header", "Centered logo; profile", "avatar opens UserProfile"])
    annotate(draw, (620, 300), (720, 300),
             ["2. Hero", "Title, city, restaurant", "description, hero image"])
    annotate(draw, (630, 512), (720, 470),
             ["3. Search bar", "Live filter by dish name", "with clear button"])
    annotate(draw, (330, 675), (720, 620),
             ["4. Menu breakdown", "Category toggles: selected", "= green, unselected = gray"])
    annotate(draw, (330, 830), (720, 830),
             ["5. Food menu list rows", "Title, 2-line description,", "price, thumbnail; tap opens", "DetailItem"])

    out = Path(__file__).resolve().parent / "wireframe.jpg"
    img.save(out, "JPEG", quality=95, dpi=(300, 300))
    print(f"Saved {out}")


if __name__ == "__main__":
    main()
