# Production art generation notes — batch 02

Generated with the built-in image generation tool on 2026-07-21. The approved protagonist and teddy concept sheets were used as locked visual references.

## Hub room

Output: `hub-room-concept-v1.png`

Prompt:

> Design a one-screen central hub for a 1280×720 2D puzzle-platform adventure. It is the abandoned storybook playroom where the protagonist first meets and repeatedly returns to repair the teddy bear. Show faded floral wallpaper, wooden floor, a central circular rug and patched cushion, cracked ceiling, boarded window, old toys, and four visually distinct exits suggesting basement pipes, greenhouse vines, music, and attic clockwork. Use a strict orthographic side view with a readable walkable floor, open center, warm central lamplight, cool moonlit edges, and hand-painted watercolor with subtle cut-paper depth. Match the approved caramel, cream, dusty rose, teal, and blue-gray palette. Environment only; no characters, text, UI, logo, watermark, isometric view, photorealism, or obstructive clutter.

## Basement pressure puzzle

Output: `basement-pressure-concept-v1.png`

Prompt:

> Design the first playable basement level as a strict orthographic 16:9 side cutaway. Build a clear left-to-right water-pressure puzzle with exactly three large valve wheels at different heights, a central analog pressure gauge, leaking tank, corroded copper pipes, shallow teal water, platforms, ladders, and a locked cage at the far right containing exactly one patched plush arm. Use dim amber utility lamps, cold teal water, oxidized copper, umber, cream, and dusty red in the approved watercolor storybook style. Preserve readable navigation and negative space. No characters, enemies, text, labels, UI, logo, watermark, isometric view, gore, or excessive darkness.

## Protagonist isolated master

Sources and outputs:

- Chroma source: `../source/protagonist-side-chroma-v1.png`
- Transparent master: `../sprites/protagonist-side-master-v1.png`
- Trimmed sprite: `../sprites/protagonist-side-idle-v1.png`

Prompt:

> Recreate the approved child protagonist as exactly one clean, full-body, right-facing strict side-profile neutral standing pose. Preserve the bear hood, caramel patched coat, cream front panel, faded red bow, muted teal satchel, brown cropped trousers, socks, and patched shoes. Match the approved watercolor and cut-paper style without redesigning. Place the character on a perfectly flat solid #00ff00 chroma-key background with generous padding, separated limbs, a crisp closed outline, and no shadow, floor, reflection, text, labels, extra poses, objects, characters, or green within the subject.

## Teddy modular master

Sources and outputs:

- Chroma source: `../source/teddy-modular-chroma-v1.png`
- Transparent master: `../sprites/teddy-modular-master-v1.png`
- Individual transparent pieces: `../sprites/teddy/`

Prompt:

> Recreate the approved broken teddy as exactly five separate game pieces: one front-facing head-and-torso with all four limbs missing, one left arm, one right arm, one left leg, and one right leg. Preserve its warm worn brown plush, cream muzzle, faded red bow, gray-blue patch, stitched sockets, sad expression, and unique limb patches. Arrange the pieces with generous spacing on a perfectly flat solid #00ff00 chroma-key background. Keep clean, closed, non-overlapping silhouettes and consistent connection points. No shadows, text, labels, logo, watermark, extra teddy, extra limbs, gore, bones, realistic fur strands, or green within the pieces.

## Protagonist animation key poses

Sources and outputs:

- Chroma source: `../source/protagonist-animation-chroma-v1.png`
- Transparent master: `../sprites/protagonist-animation-master-v1.png`
- Normalized 512×512 frames: `../sprites/protagonist/animation-v1/`

Prompt:

> Create exactly six separate right-facing side-profile poses of the approved child protagonist: neutral idle, subtle breathing idle, walk contact with forward foot, walk passing pose, opposite walk contact, and compact upward jump. Preserve the exact identity, hood, clothing, patches, satchel, proportions, palette, and watercolor cut-paper rendering. Arrange two rows of three poses at identical scale with large even gaps on a perfectly flat solid #00ff00 chroma-key background. No overlap, left-facing or three-quarter poses, redesigns, extra limbs, motion blur, shadows, text, labels, numbers, logo, watermark, background texture, or green within the character.

## Fully repaired teddy

Sources and outputs:

- Chroma source: `../source/teddy-repaired-chroma-v1.png`
- Transparent master: `../sprites/teddy-repaired-master-v1.png`
- Trimmed final sprite: `../sprites/teddy/repaired-complete-v1.png`

Prompt:

> Create exactly one complete front-facing seated version of the approved teddy after all four limbs have been carefully sewn back on. Preserve the warm worn plush, cream muzzle, sad but relieved expression, torn right ear with harmless cotton, forehead patch, faded red bow, belly patch, plaid and blue arm patches, and cream and red leg patches. All four limbs must be naturally attached with closed stitched joins and no visible sockets. Match the approved watercolor cut-paper style on a perfectly flat solid #00ff00 chroma-key background. No shadows, text, labels, logo, watermark, detached or extra limbs, gore, bones, monster features, photorealistic fur, background texture, or green in the subject.

## Transparency processing

The built-in image generator produced flat chroma-key sources. They were converted locally with `remove_chroma_key.py` using border auto-key sampling, soft matte, thresholds 12/220, and despill. `tools/prepare_sprite_assets.py` trims, splits, normalizes, and recreates the derived sprite files.
