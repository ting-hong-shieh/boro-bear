<div align="center">

<a href="https://ting-hong-shieh.github.io/boro-bear/">
  <img src="art/previews/title-screen-v1.png" alt="Boro Bear title screen" width="100%">
</a>

<p>
  <a href="https://github.com/ting-hong-shieh/boro-bear/actions/workflows/pages.yml"><img alt="Web build" src="https://img.shields.io/github/actions/workflow/status/ting-hong-shieh/boro-bear/pages.yml?branch=main&style=flat-square&label=web%20build"></a>
  <img alt="Godot 4.7.1" src="https://img.shields.io/badge/Godot-4.7.1-478CBF?style=flat-square&logo=godotengine&logoColor=white">
  <img alt="GDScript" src="https://img.shields.io/badge/language-GDScript-478CBF?style=flat-square">
  <img alt="Web and desktop" src="https://img.shields.io/badge/platform-Web%20%7C%20Desktop-7C3AED?style=flat-square">
</p>

<p><strong>Four rooms. One broken bear. A house made of memories that is beginning to collapse.</strong></p>

<p>
  <a href="https://ting-hong-shieh.github.io/boro-bear/"><strong>▶ Play in your browser</strong></a> ·
  English · <a href="README.zh-TW.md">繁體中文</a>
</p>

</div>

**Boro Bear · 波洛熊：縫線房** is a short 2D narrative puzzle-platformer made with
Godot 4.7. Xiaomian meets Boro, a teddy bear missing all four limbs, inside a house
whose rooms are coming apart. Solve each room's mechanism, stitch Boro back together,
and reach the exit before the final collapse.

Progress is saved automatically. Each room also hides a memory thread; finding all four
unlocks the complete ending.

## Screenshots

<table>
  <tr>
    <td width="50%"><img src="art/previews/greenhouse-gameplay-v1.png" alt="Moonlit greenhouse mirror puzzle"></td>
    <td width="50%"><img src="art/previews/escape-gameplay-v1.png" alt="Final escape through the collapsing house"></td>
  </tr>
  <tr>
    <td align="center"><sub>Moonlit greenhouse · mirror puzzle</sub></td>
    <td align="center"><sub>The house awakens · final escape</sub></td>
  </tr>
</table>

## The five-part journey

1. **Flooded Basement** — read the pressure records, set three valves, and recover the
   left arm.
2. **Moonlit Greenhouse** — align three linked mirrors and recover the right arm.
3. **Silent Music Room** — replay four music boxes in the recorded order and recover
   the left leg.
4. **Rewinding Clocktower** — match three counterweights to their marked positions and
   recover the right leg.
5. **The House Awakens** — escape with the repaired Boro before the 48-second timer
   reaches zero.

## Controls

| Action | Keyboard |
| --- | --- |
| Move | `A` / `D` or arrow keys |
| Jump | `Space`, `W`, or ↑ |
| Interact / continue dialogue | `E` |
| Pause | `Esc` |
| Mute | `M` |
| Return to title from pause | `R` |
| Continue / new game on title screen | `Enter` / `N` |

### Mobile web

Play in landscape orientation. Touch controls appear on touch screens and coarse-pointer
devices: movement on the lower left, interaction and jump on the lower right, and pause
in the upper right. The game can be added to the home screen for a full-screen session.

## Run locally

Import the repository with Godot 4.7.x, open `project.godot`, and press `F6` or `F5`.

```sh
godot --path . --editor
```

To export the web build locally, install the Godot 4.7.1 export templates first:

```sh
mkdir -p build/web
godot --headless --path . --export-release Web build/web/index.html
```

Pushes to `main` are exported and deployed to GitHub Pages by GitHub Actions.

## Developer checks

Launch an individual chapter:

```sh
godot --path . -- --debug-basement
godot --path . -- --debug-greenhouse
godot --path . -- --debug-music_room
godot --path . -- --debug-clocktower
godot --path . -- --debug-escape
```

Run the complete flow and physics checks headlessly:

```sh
godot --headless --path . -- --debug-full-flow
godot --headless --path . -- --debug-physics-test
```

The flow check succeeds after all four puzzles, four repairs, the escape, and the true
ending. The physics check exercises movement and jumping against platform clearance,
one-way platforms, reachable jump height, and boundary walls.

## Project structure

- `scenes/` — main game and player scenes;
- `scripts/game.gd` — chapters, puzzles, dialogue, UI, escape, and endings;
- `scripts/game_state.gd` — cross-chapter state and JSON saves;
- `scripts/player.gd` — movement, jumping, animation, and footsteps;
- `art/` — concepts, character animation, modular Boro art, and previews;
- `audio/` — music and sound effects used by the game;
- `third_party/` — upstream assets and their accompanying licenses.

The game targets a 1280 × 720 viewport and uses Godot's GL Compatibility renderer.
See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for asset sources and licenses.
