#!/usr/bin/env python3
"""Trim the generated transparent masters into reusable sprite assets."""

from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
SPRITES = ROOT / "art" / "sprites"


def trim(image: Image.Image, padding: int = 24) -> Image.Image:
    alpha_box = image.getchannel("A").getbbox()
    if alpha_box is None:
        raise ValueError("image contains no visible pixels")

    left, top, right, bottom = alpha_box
    left = max(0, left - padding)
    top = max(0, top - padding)
    right = min(image.width, right + padding)
    bottom = min(image.height, bottom + padding)
    return image.crop((left, top, right, bottom))


def normalize_frame(image: Image.Image, *, jump: bool = False) -> Image.Image:
    """Place a pose on a stable 512px canvas to prevent animation jitter."""
    visible = trim(image, padding=0)
    frame = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    x = (frame.width - visible.width) // 2
    y = (frame.height - visible.height) // 2 if jump else 500 - visible.height
    frame.alpha_composite(visible, (x, y))
    return frame


def main() -> None:
    protagonist = Image.open(SPRITES / "protagonist-side-master-v1.png").convert("RGBA")
    trim(protagonist, padding=32).save(SPRITES / "protagonist-side-idle-v1.png")

    animation_master = SPRITES / "protagonist-animation-master-v1.png"
    if animation_master.exists():
        sheet = Image.open(animation_master).convert("RGBA")
        animation_dir = SPRITES / "protagonist" / "animation-v1"
        animation_dir.mkdir(parents=True, exist_ok=True)
        frame_names = [
            "idle-01.png",
            "idle-02.png",
            "walk-01.png",
            "walk-02.png",
            "walk-03.png",
            "jump-01.png",
        ]
        for index, filename in enumerate(frame_names):
            column = index % 3
            row = index // 3
            cell = sheet.crop(
                (column * 512, row * 512, (column + 1) * 512, (row + 1) * 512)
            )
            normalize_frame(cell, jump=index == 5).save(animation_dir / filename)

    teddy = Image.open(SPRITES / "teddy-modular-master-v1.png").convert("RGBA")
    teddy_dir = SPRITES / "teddy"
    teddy_dir.mkdir(parents=True, exist_ok=True)

    regions = {
        "left-arm-v1.png": (0, 0, 480, 540),
        "right-arm-v1.png": (1060, 0, 1536, 540),
        "left-leg-v1.png": (0, 540, 480, 1024),
        "right-leg-v1.png": (1060, 540, 1536, 1024),
        "body-no-limbs-v1.png": (450, 0, 1080, 1024),
    }

    pieces = {}
    for filename, region in regions.items():
        piece = trim(teddy.crop(region), padding=24)
        piece.save(teddy_dir / filename)
        pieces[filename] = piece

    states_dir = teddy_dir / "states"
    states_dir.mkdir(parents=True, exist_ok=True)
    body_position = (202, 80)
    limb_positions = {
        "left-arm-v1.png": (70, 550),
        "right-arm-v1.png": (635, 550),
        "left-leg-v1.png": (220, 820),
        "right-leg-v1.png": (490, 820),
    }
    progression = [
        [],
        ["left-arm-v1.png"],
        ["left-arm-v1.png", "right-arm-v1.png"],
        ["left-arm-v1.png", "right-arm-v1.png", "left-leg-v1.png"],
        [
            "left-arm-v1.png",
            "right-arm-v1.png",
            "left-leg-v1.png",
            "right-leg-v1.png",
        ],
    ]

    for index, attached_limbs in enumerate(progression):
        state = Image.new("RGBA", (980, 1300), (0, 0, 0, 0))
        for limb_name in attached_limbs:
            limb = pieces[limb_name]
            state.alpha_composite(limb, limb_positions[limb_name])
        state.alpha_composite(pieces["body-no-limbs-v1.png"], body_position)
        state.save(states_dir / f"repair-state-{index}-v1.png")

    repaired_master = SPRITES / "teddy-repaired-master-v1.png"
    if repaired_master.exists():
        repaired = Image.open(repaired_master).convert("RGBA")
        trim(repaired, padding=32).save(teddy_dir / "repaired-complete-v1.png")


if __name__ == "__main__":
    main()
