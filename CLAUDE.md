# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Wrath of Verath** is a Godot 4.6 roguelike deckbuilder built on the [Slay-The-Robot framework](https://github.com/DesirePathGames/Slay-The-Robot). Players descend through 4 acts on Verath — a planet that is itself an ancient intelligence — using one of three characters from competing factions. The game adds a **Mech/Component system** (replacing traditional relics) and character-specific unique mechanics on top of the framework's data-driven action/interceptor architecture.

- **Engine:** Godot 4.6, GDScript, renderer `gl_compatibility`
- **Resolution:** 1200×700 (non-resizable)
- **Main scene:** `res://scenes/Root.tscn`
- **License:** MIT

## Game Design Reference

### Characters & Unique Mechanics

| Character | Faction | Difficulty | Unique Mechanic |
|-----------|---------|------------|-----------------|
| **Vanguard** | Helion Compact | Easy | **Momentum** — stacks on attacks, amplifies finishers, decays at turn end |
| **Architect** | Meridian Collective | Medium | **Drones** (max 3 active) — persistent entities that trigger effects each turn |
| **Wraith** | Phantom Cell | Hard | **Stealth** (skip one enemy attack) + **Exploit** (bonus effects vs debuffed enemies) |

### Mech / Component System (replaces Artifacts/Relics)

Each character has a persistent mech with four slot types:

| Slot | Function |
|------|----------|
| **WEAPON** | Active attacks fired once per turn as a free Mech Action (costs Power) |
| **SYSTEM** | Passive always-on effects — equivalent to the framework's artifact/relic niche |
| **ARMOR** | Defensive stats and damage mitigation |
| **CORE** | One slot; boss reward only; run-defining |

**Power** is a secondary resource (separate from card Energy). Starts each combat at 0. SYSTEM Components and certain cards generate it; WEAPON slots spend it. Exceeding Power Capacity triggers **Overload** — self-damage plus a powerful burst effect that some builds deliberately chase.

Each mech has a character-specific Overload effect:
- IRONCLAD-7 (Vanguard): SURGE — damage all enemies equal to current Power
- WEAVER-3 (Architect): OVERCLOCK — all active Drones trigger twice
- SHADE-0 (Wraith): PHASE — mech untargetable for one full enemy turn

Components are found at elite rewards (choose 1 of 2), shops, and events. Boss rewards give CORE-slot Components. Rarity tiers: Common → Rare → **Verath-Touched** (Acts 3–4 only, powerful but strange).

### Act Structure

| Act | Location | Branch |
|-----|----------|--------|
| 1 — Threshold | Verath Station / Keth Moon | — |
| 2 — The Surface | Player chooses biome | **A: Verdant Scar** (jungle) or **B: The Crucible** (volcanic) |
| 3 — The Deep | Cave system | — |
| 4 — The Mind | Verath's Core | — |

### Cinematic Boss Combat

Bosses use a structured fight format: intro cutscene → Phase 1 → interrupt window → phase transition → Phase 2 → interrupt window → final phase → death cutscene. Each phase has a new music layer, transformed background, distinct move set, and a segmented HP bar.

**Interrupt windows:** when a boss telegraphs a CRITICAL ATTACK (gold ring on portrait), the player has 1 turn to meet a condition (e.g. "play 2+ SYSTEM cards", "deal 20+ damage", "fire mech weapon") or suffer a severe consequence.

**Arena hazards** apply passive pressure throughout the fight (e.g. Resonance Pulse strips all block every 3 turns in Act 3; Memory Echo replays a player card against them each turn in Act 4).

### Implementation Mapping (GDD → Framework)

| GDD Feature | Framework Hook |
|-------------|----------------|
| SYSTEM slot Components (always-on passives) | `ArtifactData` with `artifact_first_turn_actions` / `artifact_script_path` |
| WEAPON slots (active mech attacks) | New action type + `ActionHandler` queue |
| Power / Overload resource | New status effect or mutable field on `PlayerData` |
| Momentum, Stealth, Exploit | `StatusEffectData` + `BaseActionInterceptor` for conditional logic |
| Drones (persistent per-turn entities) | Status effects with `status_effect_action_process_times` |
| Boss phases + interrupt windows | `CombatStatsData` tracking + `ActionHandler` phase triggers |
| Verath adaptive layer (Memory Echo, deck mutation) | `Signals` event bus + `DialogueOverlay` event system |
| Validators (card type, debuff present, etc.) | `scripts/validators/` — extend `BaseValidator` |

## Running the Game

There is no CLI build system. Open the project in Godot 4.6 and press **F5** (or Run → Play) to launch `scenes/Root.tscn`. There are no automated tests, no linting tools, and no CI beyond a daily GitHub Actions workflow that collects repo statistics.

## Architecture

### Autoload Singletons

Nine global singletons in `autoload/` are the backbone of the framework. They are accessible from any script without `get_node`:

| Singleton | Role |
|-----------|------|
| `Signals` | Central event bus — 60+ signals for all game events. Always connect to signals here rather than on individual nodes. |
| `Global` | Core state: current `PlayerData`, `ProfileData`, data lookup tables, run start/end logic, schema/test-data generators. |
| `Scripts` | Hardcoded string registry mapping constant names (e.g. `ACTION_ATTACK`) to script paths. Referenced by `ActionGenerator`. |
| `ActionHandler` | Executes the action stack/queue, runs interceptors, handles async timing. |
| `ActionGenerator` | Factory that constructs action objects from config dicts, and generates acts/world maps. |
| `FileLoader` | Save/load for `PlayerData`, `ProfileData`, `UserSettingsData`; loads the mod system from `external/`. |
| `Random` | Deterministic RNG — named tracks per `PlayerData` instance for reproducible runs. |
| `UIDGenerator` | Unique IDs for runtime objects. |
| `DebugLogger` | Debug logging. |

### Action System

Everything that happens in gameplay goes through **actions**. Key files:

- `scripts/actions/BaseAction.gd` — abstract base; defines `parent_combatant`, `targets`, `values`, `time_delay`, `action_tags`
- `scripts/actions/BaseAsyncAction.gd` — for actions that require waiting (animations, etc.)
- `ActionHandler.gd` queues and executes actions; calls `ActionInterceptorProcessor` before each action runs

**Value resolution hierarchy** (highest → lowest priority):
1. `Action.values` (set at instantiation)
2. `CardPlayRequest.card_values`
3. `CardData.card_values`
4. `BaseAction` default

**Adding a new action:** subclass `BaseAction` (or `BaseAsyncAction`), register its path as a constant in `Scripts.gd`, then reference it by constant in data dicts passed to `ActionGenerator.create_actions()`.

### Interceptor System

`scripts/action_interceptors/` — interceptors run before an action executes and can modify values, block execution, or duplicate actions. They are registered per-combatant and looked up by action type. Implement `BaseActionInterceptor`; use `ActionInterceptorProcessor` to apply them.

### Data Hierarchy (Three Tiers)

1. **Read-only prototypes** (`data/readonly/`) — `SerializableData` subclasses (e.g. `CardData`, `EnemyData`, `ArtifactData`). Loaded once into `Global` lookup tables. Never mutated.
2. **Prototype copies** — call `.get_prototype(true)` on a `SerializableData` instance to get a mutable duplicate for the current run.
3. **Mutable runtime data** (`data/mutable/`) — `PlayerData` (run state), `ProfileData` (win/loss history), `CombatStatsData`, `UserSettingsData`, `LocationData`, `ShopData`.

All `@export` properties on `SerializableData` subclasses auto-serialize to human-readable JSON via `FileLoader`.

### Card System

`CardData` properties of note:
- `card_play_actions` — array of action config dicts executed when the card is played
- `card_validators` — conditions checked before allowing play
- `card_values` — dict of parameters used by actions
- `card_upgraded_properties` — property overrides applied when upgraded
- Destination flags: `DISCARD`, `EXHAUST`, `DRAW_BOTTOM`, `DRAW_TOP`, `BANISH`, etc.

`CardPlayRequest` wraps an in-flight card play: the card, selected target, hand state, energy tracking, duplicate-play flag, and final destination.

### Artifact & Status Effect System

`ArtifactData` and `StatusEffectData` follow the same data-driven pattern as cards. Key fields:
- **Artifacts:** `artifact_add_actions` (on pickup), `artifact_first_turn_actions` (combat start), `artifact_max_counter_actions` (when counter fills), optional `artifact_script_path` for custom `BaseArtifact` logic.
- **Status effects:** `status_effect_decay_rate` (-1 = decay per turn, 0 = permanent, -2 = aggressive), `status_effect_action_process_times` (when to trigger), `status_effect_interceptor_ids` (interceptors to register).

### Validator System

`scripts/validators/` — 13 implementations of conditional checks used by cards and actions (card type, rarity, player health, money, deck size, etc.). Validators gate whether an action or card play proceeds.

### Game Flow

```
TitleScreen → MainMenu → NewRunMenu
  → Global.start_run() → ActionGenerateAct → Map
  → Select location → Combat | Shop | Rest | Chest | Event
  → Repeat per act → RunSummaryOverlay
```

**Combat turn loop:** draw (ActionDrawGenerator) → player plays cards from `Hand.gd` → `ActionHandler` executes each card's actions through interceptors → end turn (ActionEndTurn, status effect decay) → enemy turn → repeat.

### UI Structure

`scenes/Root.tscn` composes 48+ child scenes. Each major UI section has a dedicated controller in `scripts/ui/` (e.g. `Hand.gd`, `Combat.gd`, `Shop.gd`, `Map.gd`, `DialogueOverlay.gd`). UI components communicate via `Signals` rather than direct node references.

### Mod System

External content loads from `external/` at runtime via `FileLoader`. `mod_list.json` and `mod_info.json` control which mods are active. Mods can override data, assets, and scripts without modifying base game files.

### Addons

- `addons/smooth_scroll_container/` — momentum-based scroll widget
- `addons/label_font_auto_sizer/` — auto-scales label font to fit bounds
