# Wrath of Verath — Game Design Document
> Godot 4.4 roguelike deckbuilder built on the [Slay-The-Robot framework](https://github.com/DesirePathGames/Slay-The-Robot)

---

## Overview
A Slay the Spire-style deckbuilder set on Verath — a planet that is itself an ancient intelligence. Three playable characters, each from a different faction, descend through 4 acts discovering the planet is alive, aware, and has been watching them.

---

## The World: Verath
A planet that shouldn't exist. Every survey said it was dead rock. The deeper you go, the more it becomes clear — Verath *thinks*. It has been thinking for millions of years, alone, waiting. The factions came for its resources. None of them understood what they were drilling into.

**Vethite** — a crystalline energy mineral found only on Verath. Warm to the touch. Gets stranger the deeper you go.

---

## Factions

| Faction | Character | Description |
|---|---|---|
| **Helion Compact** | Vanguard | Corporate-military alliance. Controls orbital infrastructure. Extracting Vethite, no questions asked. |
| **The Meridian Collective** | Architect | Coalition of engineers and scientists. First to notice the planet is *responding* to drilling. |
| **Phantom Cell** | Wraith | Ghost network of operatives. Hired by unknown party to retrieve something specific from Verath's core. |

---

## Act Structure

### Act 1 — Threshold
**Location:** Verath Station / Keth Moon (tidally locked, used as relay/weapons cache)
- All three factions intersect here — trading, spying, barely tolerating each other
- Something is interfering with comms from the surface
- **Boss:** The Stationmaster — Helion commander who's been on-station too long, acting strange
- **Tone:** Political tension, noir intrigue, calm before descent

### Act 2 — The Surface (player chooses biome)
**Option A — The Verdant Scar (Jungle)**
- Hyper-aggressive megaflora grown *around* ruins of a previous civilization. Arranged. Something is tending them.
- **Boss:** The Gardener — a Meridian scientist who merged with the ecosystem "to understand it better"

**Option B — The Crucible (Volcanic)**
- Helion's heaviest extraction rigs. Lava flows follow patterns. Geology responds to sound.
- **Boss:** Rig-King Soto — believes Verath is a machine and he's figured out how to operate it

### Act 3 — The Deep (Cave System)
- Miles beneath the surface. Caves are *grown, not carved* — perfect geometry, impossible smoothness
- Bioluminescent veins pulsing in slow rhythm. Verath's nervous system.
- **Boss:** The First Driller — a Phantom Cell operative who came down years ago, never came back. Still moving. Still drilling. Speaks in a language that isn't language.
- **Tone:** Horror, awe, wrongness. Faction intel breaks down here.

### Act 4 — The Mind (Verath's Core)
- Verath is a distributed consciousness evolved over geological time — mineral lattices as neurons, magma flows as synaptic pulses
- The environment reshapes itself around you based on Verath's emotional state
- **Enemies:** Echoes — perfect crystal reconstructions of enemies you've already killed. Verath has been learning.
- **Boss:** Verath, The Patient — not malicious, not benevolent. Ancient. The fight is a conversation.
- **Tone:** Transcendent, philosophical, alien. Each character's ending differs based on faction goals.

**Throughline:** The deeper you go, the more Verath changes you. Cards mutate, Components pulse with crystalline energy, event text shifts. By Act 4 the planet knows your deck better than you do.

---

## Characters

### 1. Vanguard *(Helion Compact — easy)*
Front-line combat marine in powered armor. Straightforward damage + block.
- **Unique mechanic:** Momentum — stacks as you attack, amplifies finishers, decays at turn end
- **Mech:** IRONCLAD-7 (Brawler frame)

### 2. Architect *(Meridian Collective — medium)*
Ship's engineer who deploys persistent Drones (max 3 active) that trigger effects each turn.
- **Unique mechanic:** Drone slots — shield drone, attack drone, repair drone. Upgradeable mid-combat.
- **Mech:** WEAVER-3 (Support frame)

### 3. Wraith *(Phantom Cell — hard)*
Stealth operative who manipulates discard pile and draw order.
- **Unique mechanic:** Stealth (skip enemy attack once), Exploit (bonus effects when attacking debuffed enemies)
- **Mech:** SHADE-0 (Ghost frame)

---

## Mech / Suit System
Replaces the traditional relic system. Each character starts with a bare-frame mech that grows via **Components** found throughout the run.

### Component Slots

| Slot | Function |
|---|---|
| **WEAPON** | Active attacks the mech can use (costs Power) |
| **SYSTEM** | Passive always-on effects (start/end of turn, on-hit triggers) — fills the "relic" niche |
| **ARMOR** | Defensive stats and damage mitigation |
| **CORE** | One slot. Boss reward only. Rare, run-defining. |

**Starting frame:** 2 Weapon + 2 System + 1 Armor + 0 Core slots. Expand via Frame Upgrades.

### Power Resource
- Secondary resource separate from card Energy
- Start each combat at 0 Power
- SYSTEM Components and certain cards generate Power
- WEAPON slots spend Power to fire
- Exceeding Power Capacity = **Overload** (self-damage + powerful burst effect)
- Overloading is intentional risk/reward — some builds fish for it

### Mech in Combat
- Always present alongside card play
- Each turn: normal hand + energy + **1 free Mech Action** (fires a WEAPON slot)
- SYSTEM slots trigger automatically
- WEAPON slots require spending the Mech Action

### The Three Mechs

**IRONCLAD-7 (Vanguard)**
- Passive: Each Momentum stack gained = 1 Power generated
- Overload effect: SURGE — deals damage equal to current Power to all enemies
- Signature CORE: Kinetic Amplifier — attack cards spend 1 Power for +50% damage

**WEAVER-3 (Architect)**
- Passive: Each active Drone = +1 Power Capacity
- Overload effect: OVERCLOCK — all active Drones trigger twice this turn
- Signature CORE: Drone Uplink — install a Drone into a WEAPON slot (unkillable, frees deck slot)

**SHADE-0 (Wraith)**
- Passive: Each card discarded = 1 Power generated
- Overload effect: PHASE — mech becomes untargetable for one full enemy turn
- Signature CORE: Echo Chamber — once per combat, copy last card played and execute as free Mech Action

### Finding Components
- **Elite rewards:** Always drop 1 Component (choose from 2)
- **Shops:** 2-3 Components for sale
- **Events:** Corrupted/mutated Components with upsides and downsides
- **Boss rewards:** Rare Component unique to that act's biome (CORE slot)

### Rarity Tiers
- Common
- Rare
- **Verath-Touched** — grown by the planet. Powerful but strange. Available Acts 3-4.

**Verath-Touched examples:**
- *Vethite Reactor (CORE):* Double Power Capacity. Mech deals 2 damage to you each turn. "It hums like it's breathing."
- *Memory Lattice (SYSTEM):* Replay first card from last combat for free. "It remembers."
- *Root Cannons (WEAPON):* Deal 20 damage. Costs 0 Power if enemy is debuffed. "The barrel looks organic."

---

## CORE Components (Boss Rewards)
One drops per boss. Choose 1 of 3. Act 4 COREs are given by Verath based on run behavior.

### Act 1 Cores
| Core | Effect |
|---|---|
| Helion Black Box | Play 3 cards in one turn → mech fires for free |
| Keth Resonator | Overload threshold halved, Overload damage doubled |
| Station Uplink | Start of each combat: install a random temporary Component |

### Act 2A Cores (Jungle)
| Core | Effect |
|---|---|
| Symbiotic Mesh | Regenerate 4 HP at end of turns where you played 2+ cards |
| Spore Distributor | Mech Weapon attacks apply 1 Poison to all enemies hit |
| Root Memory | First time HP drops below 50%, mech takes the next hit for you |

### Act 2B Cores (Volcanic)
| Core | Effect |
|---|---|
| Magma Tap | Gain 1 Power whenever you take damage |
| Pressure Seal | Mech blocks 6 at turn start; explodes for 10 self-damage if you play 0 cards |
| Vein Drill | After every elite, mech permanently gains +2 Weapon damage |

### Act 3 Cores
| Core | Effect |
|---|---|
| Resonance Crystal | After Overload, don't reset Power — keep the remainder |
| Echo Plating | First lethal hit per combat: survive on 1 HP, immune for one turn |
| Nerve Lattice | Gain +1 permanent Power Capacity after every combat |

### Act 4 Cores (Verath chooses based on your run)
| Core | Condition | Effect |
|---|---|---|
| The Gift | Overloaded 4+ times | Overload never deals self-damage |
| The Mirror | Blocked more than dealt | Mech copies block value as bonus damage on next attack |
| The Hunger | 10+ Components installed | All Components gain a second passive effect |
| The Silence | No damage in 3+ combats | Mech invisible until it attacks, every combat |

---

## Cinematic Boss Combat

### Fight Structure
```
INTRO CUTSCENE → PHASE 1 → INTERRUPT MOMENT → PHASE TRANSITION
→ PHASE 2 → INTERRUPT MOMENT → FINAL PHASE → DEATH CUTSCENE
```

Each phase has: new music layer, transformed background art, distinct move set, segmented HP bar.

### Interrupt Windows
When a boss telegraphs a CRITICAL ATTACK, a gold ring pulses around the boss portrait. You have 1 turn to meet an interrupt condition or suffer a severe consequence.

| Condition Type | Example | Fail Consequence |
|---|---|---|
| Card type | Play 2+ SYSTEM cards | Take 40 unblockable damage |
| Damage threshold | Deal 20+ damage | Boss gains 2 Enrage stacks |
| Mech action | Fire mech weapon | Boss applies Burn to whole deck |
| Zero cost | Play only 0-cost cards | Lose all block, take full hit |
| Survive | End turn above 50% HP | Boss skips to next phase |

### Arena Hazards (examples)
- **Act 1 — Depressurization Vents:** End of every 3rd turn, take 8 damage unless you played a Block card
- **Act 2A — Root Surge:** Start of turn, if mech has 0 Power, mech takes 6 damage
- **Act 2B — Pressure Buildup:** Every turn you don't Overload, Pressure +1. At 5, takes 15 damage and resets
- **Act 3 — Resonance Pulse:** Every 3 turns, all block is stripped (visible charging bar)
- **Act 4 — Memory Echo:** Each turn, Verath replays one card from your discard pile against you

### Phase Transitions
1. Cards freeze mid-hand
2. Boss transformation animation
3. Single line of dialogue (no skip)
4. New hazard activates / existing one intensifies
5. Music gains a new layer

### Death Cutscenes (4-6 seconds each)
- **Stationmaster:** Floats to viewport. Looks at Verath below. Smiles.
- **The Gardener:** Roots slowly release them. Jungle goes quiet for the first time.
- **Rig-King Soto:** Rig collapses into magma. Last transmission is laughter.
- **The First Driller:** Stops mid-step. Turns to you. Says one word in Verath's language. Falls.
- **Verath:** Doesn't die. Fight simply ends. Crystal goes dark. Then slowly, warmly, lights back up.

---

## Build Archetypes

### Vanguard
| Build | Identity | Key Tension |
|---|---|---|
| **Surge Striker** | Stack Momentum fast, cash out with finishers. Small aggressive deck. | Momentum decays at turn end — must plan finisher in same turn |
| **Fortress** | Stack block, deal damage back. Outlast enemies via passive thorns. | Needs enough block generation or engine collapses |

### Architect
| Build | Identity | Key Tension |
|---|---|---|
| **Drone Swarm** | Max Drone board, let it do the work. WEAVER buffs with each Drone. | Enemies that target Drones directly |
| **Chain Reaction** | 0-cost card chain engine, explosive combo turns. | Deck consistency — one bad draw breaks the chain |

### Wraith
| Build | Identity | Key Tension |
|---|---|---|
| **Ghost Protocol** | Debuff → Exploit → Stealth → repeat. Controlling and methodical. | Stealth only procs once naturally per combat |
| **Void Loop** | Discard/draw engine. Cycle deck multiple times per turn. | Need payoff cards or you're just spinning wheels |

---

## Card Reference

### Vanguard — Surge Striker
| Card | Cost | Effect |
|---|---|---|
| Blitz | 1 | Deal 8 damage. Gain 1 Momentum. |
| Chain Strike | 1 | Deal 5 damage. Gain 1 Momentum. If 3+ Momentum, draw 1. |
| Overclock Fists | 0 | Deal 3 damage. Gain 1 Momentum. Exhaust. |
| Momentum Burst | 2 | Deal 8 × Momentum damage. Reset Momentum. |
| War Cry | 1 | Gain 2 Momentum. Draw 1. |
| Afterburn | 2 | Double current Momentum. Exhaust. |

### Vanguard — Fortress
| Card | Cost | Effect |
|---|---|---|
| Bulwark | 1 | Gain 12 Block. |
| Retribution | 1 | Deal damage equal to Block gained this turn. |
| Iron Shell | 2 | Gain 16 Block. Mech gains 4 Thorns until end of turn. |
| Counterstrike | 0 | Deal 4 damage for each time hit last turn. |
| Fortress Mode | 3 | Power: Gain 6 Block automatically each turn. |
| Absorb | 1 | Gain 8 Block. Generate 1 Power. |

### Architect — Drone Swarm
| Card | Cost | Effect |
|---|---|---|
| Deploy: Shield Drone | 1 | Deploy Shield Drone. Grants 4 Block per turn. |
| Deploy: Gun Drone | 1 | Deploy Gun Drone. Deals 5 damage/turn to random enemy. |
| Deploy: Repair Drone | 2 | Deploy Repair Drone. Heals 3 HP per turn. |
| Drone Overclock | 1 | All active Drones trigger twice this turn. |
| Salvage | 0 | Destroy one Drone. Draw 2. Generate 2 Power. |
| Swarm Protocol | 2 | Power: Each Drone deployed deals 6 AOE damage. |

### Architect — Chain Reaction
| Card | Cost | Effect |
|---|---|---|
| Spark | 0 | Deal 3 damage. Draw 1. |
| Relay | 0 | Draw 1. Next card this turn costs 0. |
| Cascade | 1 | Deal 4 damage per card played this turn. |
| Feedback Loop | 1 | Power: Playing a 0-cost card gains 1 Energy at turn end. |
| Short Circuit | 0 | Discard hand. Draw that many cards. |
| Overcharge | 2 | Deal 2 damage per card in discard pile. Exhaust. |

### Wraith — Ghost Protocol
| Card | Cost | Effect |
|---|---|---|
| Hack | 1 | Apply 2 Hack (reduce enemy Attack by 2). Enter Stealth. |
| Burn Wire | 1 | Deal 6 damage. Apply 3 Burn. |
| Exploit Strike | 2 | Deal 14 damage. If enemy has any debuff, deal 20 instead. |
| Shadow Step | 0 | Enter Stealth. Exhaust. |
| Slow Toxin | 1 | Apply 2 Slow (enemy loses 1 action/turn). Draw 1. |
| Phantom Blade | 1 | Deal 8 damage. If in Stealth, hits twice. Lose Stealth. |

### Wraith — Void Loop
| Card | Cost | Effect |
|---|---|---|
| Discard Drive | 0 | Discard 1 card. Draw 2. Generate 1 Power. |
| Void Slash | 1 | Deal 5 damage + 2 per card in discard pile. |
| Recall | 1 | Shuffle discard into draw pile. Draw 3. |
| Ghost Signal | 0 | Deal damage equal to cards discarded this combat. Exhaust. |
| Burn Cache | 2 | Discard hand. Deal 6 damage per card discarded. Exhaust. |
| Echo | 1 | Copy last card in discard pile and play it for free. |

---

## Enemy Designs (Archetype Counters)

| Enemy | Counters | Key Moves |
|---|---|---|
| **Helion Suppression Unit** | Surge Striker | Momentum Drain (zeroes Momentum), Suppression Field (2 card limit), Counter Stance (gains block on your attacks) |
| **Meridian Rogue Unit** | Drone Swarm | Target Lock (destroys a Drone), EMP Burst (Drones skip next turn), Swarm Analysis (gains Attack per your Drone) |
| **Phantom Cell Breacher** | Fortress | Armor Pierce (ignores block), Shatter (removes all block, deals half as damage), Relentless (4 damage at end of YOUR turn) |
| **Helion Jammer Drone** | Chain Reaction | Interference (random card unplayable), Cost Surge (+1 Energy cost all cards), Static Burst (12 damage if you played 3+ last turn) |
| **Verath-Corrupted Sensor Node** | Ghost Protocol | Pulse Scan (removes Stealth, deals 8 if you were stealthed), Debuff Immunity (immune to one random debuff type), Exposed (half damage if not in Stealth) |
| **Phantom Cell Data Leech** | Void Loop | Cache Drain (permanently removes 5 discard cards), Memory Wipe (shuffles discard into draw), Exploit Data (deals damage = discard pile size) |

---

## Implementation Notes
- **Framework:** [Slay-The-Robot](https://github.com/DesirePathGames/Slay-The-Robot) — Godot 4.4, GDScript
- **Mech system** is new — hook into framework's interceptor/action architecture
- **SYSTEM slot Components** = always-on passives (replaces traditional relics entirely)
- **Boss phases + interrupt windows** — build on top of existing combat stat tracking
- **Momentum, Drones, Stealth** — use framework's validator system for conditional card logic
- **Verath intelligence layer** (Memory Echo, deck mutation, adaptive boss) — built on top of existing event/dialogue system
