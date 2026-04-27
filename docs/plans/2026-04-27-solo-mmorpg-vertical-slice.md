# Solo MMORPG Vertical Slice Implementation Plan

> For Hermes: Use subagent-driven-development skill to implement this plan task-by-task.

Goal: Build an original always-online MMORPG vertical slice inspired by classic WoW-style progression and the public design direction of Elegon, with one starter zone, basic combat, quests, loot, chat, and stable multiplayer.

Architecture: Use Godot 4.x for the 3D client and UI, SpacetimeDB for the authoritative multiplayer backend, and a shared JSON-driven content layer for quests, enemies, items, and world spawns. Focus first on a single polished starter-zone vertical slice instead of trying to build a full MMO upfront.

Tech Stack:
- Client: Godot 4.x (GDScript first, C# optional later)
- Backend: SpacetimeDB
- Assets: placeholder low-poly prototype art
- Source control: git
- Documentation: markdown in docs/

Reference-derived product pillars:
- classic MMORPG feeling, not theme-park handholding
- earned progression over monetization shortcuts
- readable open-world exploration
- social features from day one: players, chat, presence
- starter content slice before massive scope expansion
- modern usability where it genuinely helps: nameplates, minimap/zone map, quest tracking, stat clarity

Non-goals for v0:
- no auction house
- no crafting professions yet
- no dungeons/raids yet
- no factions/guilds yet
- no advanced animation pipeline yet
- no full world streaming yet

Recommended repo layout:
- client/
- server/
- shared/
- docs/
- tools/

---

## Phase 0: Project foundation and scope lock

### Task 1: Create repository skeleton
Objective: Create a clean repo structure for client, server, shared data, and docs.

Files:
- Create: client/
- Create: server/
- Create: shared/
- Create: docs/
- Create: tools/
- Create: .gitignore
- Create: README.md

Step 1: Write the README and repo structure notes.
Step 2: Add a .gitignore for Godot, temp builds, and local DB artifacts.
Step 3: Commit.

### Task 2: Write the game brief
Objective: Freeze the first-playable target so the project stays small enough to ship.

Files:
- Create: docs/game-brief.md

Required brief sections:
- fantasy premise
- player fantasy
- target session length
- what “MMO feel” means in this project
- v0 vertical-slice checklist
- explicit out-of-scope list

Step 1: Write a failing review checklist inside docs/game-brief.md (missing sections marked TODO).
Step 2: Fill all sections.
Step 3: Verify all TODO markers are gone.
Step 4: Commit.

### Task 3: Write the content bible for the starter zone
Objective: Define one original starter zone rather than copying an existing game’s world.

Files:
- Create: docs/starter-zone.md

Must include:
- zone name
- biome
- enemy families (3-4 max)
- NPC roles
- quest chain overview
- loot table themes
- landmarks

Step 1: Draft the zone outline.
Step 2: Reduce enemy/NPC counts until the zone is realistically buildable.
Step 3: Commit.

---

## Phase 1: Networking and player presence foundation

### Task 4: Create backend schema document
Objective: Define authoritative multiplayer data before client implementation.

Files:
- Create: docs/network-schema.md
- Create later: server/schema/ (actual backend code)

Core entities:
- Player
- CharacterState
- NPC
- Enemy
- QuestState
- ItemInstance
- ChatMessage
- SpawnPoint

Step 1: Write schema definitions in markdown first.
Step 2: Include field lists for each entity.
Step 3: Include event flow for login, movement, combat, quest progress, and chat.
Step 4: Commit.

### Task 5: Initialize SpacetimeDB backend
Objective: Create the minimal authoritative server project.

Files:
- Create: server/README.md
- Create: server/ (SpacetimeDB project files)

Step 1: Create the backend project scaffold.
Step 2: Add a health-check / local run doc.
Step 3: Start server locally and verify it boots.
Step 4: Commit.

### Task 6: Add player session and login flow
Objective: Allow a player to connect and spawn into the starter zone.

Files:
- Modify: server/backend session files
- Create: client/login/
- Test: backend session tests if supported

Step 1: Write failing test or simulated login validation for “new player receives starter spawn state”.
Step 2: Implement minimal login/session creation.
Step 3: Verify one client can connect and receive state.
Step 4: Commit.

### Task 7: Add replicated player movement
Objective: Show multiple players moving in the same world.

Files:
- Modify: server movement handling
- Modify: client player controller/network sync
- Test: movement serialization tests

Step 1: Write failing test for movement payload validation.
Step 2: Implement server-authoritative movement updates.
Step 3: Implement interpolation for remote players on the client.
Step 4: Verify two clients can see each other move.
Step 5: Commit.

### Task 8: Add player nameplates
Objective: Make multiplayer presence readable immediately.

Files:
- Modify: client world UI/nameplate systems
- Test: client-side logic tests if feasible

Step 1: Write a small pure helper test for nameplate data generation.
Step 2: Render names and basic HP bars above players.
Step 3: Verify nameplates do not clip badly at common distances.
Step 4: Commit.

---

## Phase 2: Starter zone world and exploration

### Task 9: Build a minimal playable starter zone scene
Objective: Create one coherent 3D outdoor zone.

Files:
- Create: client/world/zones/starter_zone.tscn
- Create: client/world/zones/starter_zone.gd
- Create: shared/content/zones/starter_zone.json

Zone requirements:
- one town hub
- one road path
- one forest or field combat pocket
- one cave or ruins point of interest
- one water edge or bridge landmark

Step 1: Block out terrain and landmarks with primitives.
Step 2: Add collision and navigation constraints.
Step 3: Verify a player can run from spawn to all landmarks.
Step 4: Commit.

### Task 10: Add zone minimap and fullscreen map
Objective: Reproduce the “maps matter” usability seen in the references.

Files:
- Create: client/ui/map/
- Create: shared/content/map_markers/starter_zone.json

Step 1: Write a pure helper test for converting world markers into map-space markers.
Step 2: Implement minimap.
Step 3: Implement fullscreen zone map.
Step 4: Verify quest markers and POIs appear correctly.
Step 5: Commit.

### Task 11: Add interactable NPCs
Objective: Let players talk to quest givers and vendors.

Files:
- Create: client/npc/
- Modify: server NPC state
- Create: shared/content/npcs/*.json

Step 1: Write failing test for NPC interaction range validation.
Step 2: Implement interaction prompt and dialogue stub.
Step 3: Verify at least 3 NPCs exist in starter town.
Step 4: Commit.

---

## Phase 3: Combat and progression core

### Task 12: Add target selection and combat state
Objective: Let players target enemies cleanly.

Files:
- Create: client/combat/targeting/
- Modify: server combat validation

Step 1: Write failing test for valid target selection rules.
Step 2: Implement target acquisition.
Step 3: Add target frame UI.
Step 4: Verify target switching across multiple mobs.
Step 5: Commit.

### Task 13: Add auto attack
Objective: Create the most basic combat loop.

Files:
- Modify: client/combat/
- Modify: server combat/
- Test: combat timing tests

Step 1: Write failing test for melee attack cadence and range checks.
Step 2: Implement server-side damage loop.
Step 3: Add client feedback: swing timer, hit text, HP update.
Step 4: Verify killable starter mobs.
Step 5: Commit.

### Task 14: Add one active class ability and simple spell queueing
Objective: Introduce modern-feeling responsiveness while keeping the combat simple.

Files:
- Modify: client/actionbar/
- Modify: server/abilities/
- Create: shared/content/abilities/*.json

Step 1: Write failing test for cooldown and queue window behavior.
Step 2: Implement one instant or short-cast ability.
Step 3: Implement one-button spell queue support.
Step 4: Verify queued ability executes after current global action window.
Step 5: Commit.

### Task 15: Add enemy aggro and leash behavior
Objective: Make mobs feel like real world creatures rather than static dummies.

Files:
- Modify: server/enemies/
- Test: aggro range and leash tests

Step 1: Write failing test for aggro, chase, and leash reset.
Step 2: Implement minimal AI.
Step 3: Verify players can pull and reset mobs predictably.
Step 4: Commit.

### Task 16: Add XP, level 2, and stat growth
Objective: Make progression visible in the first session.

Files:
- Modify: server/progression/
- Modify: client/ui/player_frame/
- Create: shared/content/progression/levels.json

Step 1: Write failing test for XP threshold progression.
Step 2: Implement XP gain and level-up.
Step 3: Update stats and UI.
Step 4: Verify reaching level 2 in the starter zone is realistic.
Step 5: Commit.

### Task 17: Add loot drops and equipment
Objective: Reward combat with clear gear progression.

Files:
- Modify: server/loot/
- Modify: client/inventory/
- Create: shared/content/items/*.json

Step 1: Write failing test for drop-table roll outputs.
Step 2: Implement item drops and pickup.
Step 3: Implement 3-4 equipment slots only: weapon, chest, boots, trinket.
Step 4: Add stat tooltip clarity.
Step 5: Commit.

---

## Phase 4: Quests and starter loop

### Task 18: Add quest data model
Objective: Support simple kill, collect, and talk objectives.

Files:
- Modify: server/quests/
- Create: shared/content/quests/*.json
- Create: client/ui/quest_log/

Step 1: Write failing test for quest objective progress updates.
Step 2: Implement quest acceptance and completion state.
Step 3: Verify persistence during a session.
Step 4: Commit.

### Task 19: Add first 3 quest chain
Objective: Create the first true vertical-slice content loop.

Files:
- Create: shared/content/quests/starter_chain.json
- Modify: shared/content/npcs/*.json
- Modify: shared/content/zones/starter_zone.json

Quest chain template:
- Quest 1: talk + travel
- Quest 2: kill 6 creatures
- Quest 3: kill named miniboss or retrieve relic

Step 1: Author the quest data.
Step 2: Hook quests to NPCs and spawns.
Step 3: Verify chain can be completed from a fresh character.
Step 4: Commit.

### Task 20: Add quest tracker and compass markers
Objective: Improve usability without over-automating exploration.

Files:
- Modify: client/ui/quest_tracker/
- Modify: client/ui/map/

Step 1: Write failing test for objective-to-marker mapping helper.
Step 2: Show active quest tracker.
Step 3: Add compass or edge-of-screen direction hints.
Step 4: Verify markers do not trivialize all exploration.
Step 5: Commit.

---

## Phase 5: Social and MMO feel

### Task 21: Add local chat
Objective: Make the world feel inhabited even in a tiny playtest.

Files:
- Modify: server/chat/
- Create: client/ui/chat/

Step 1: Write failing test for chat message sanitization and radius routing.
Step 2: Implement say chat.
Step 3: Verify two clients can talk locally.
Step 4: Commit.

### Task 22: Add emotes
Objective: Add low-cost social expression early.

Files:
- Modify: client/social/
- Modify: server/social/

Step 1: Write failing test for emote command parsing.
Step 2: Implement /wave, /sit, /dance placeholder behavior.
Step 3: Verify emote broadcast to nearby players.
Step 4: Commit.

### Task 23: Add respawn and corpse return loop
Objective: Create stakes and recovery without complex systems.

Files:
- Modify: server/death/
- Modify: client/death_ui/

Step 1: Write failing test for death -> respawn state transition.
Step 2: Implement graveyard respawn or camp respawn.
Step 3: Verify players can recover and resume questing.
Step 4: Commit.

---

## Phase 6: Stability, usability, and deployment

### Task 24: Add metrics-friendly debug overlay
Objective: Make solo development iteration faster.

Files:
- Create: client/debug/

Overlay should show:
- FPS
- ping
- entity counts
- current zone
- position
- target id

Step 1: Implement overlay toggle.
Step 2: Verify information updates live.
Step 3: Commit.

### Task 25: Add basic save/persistence strategy
Objective: Ensure characters survive reconnects.

Files:
- Modify: server persistence layer
- Create: docs/persistence.md

Step 1: Write failing test for reconnecting player state restore.
Step 2: Persist character basics: level, XP, inventory, quest state, position.
Step 3: Verify reconnect restores state.
Step 4: Commit.

### Task 26: Add starter playtest checklist
Objective: Define what “ready for external testing” means.

Files:
- Create: docs/playtest-checklist.md

Checklist must include:
- new character creation
- movement replication
- kill quest completion
- level up
- loot equip
- death and respawn
- chat and emotes
- reconnect persistence

Step 1: Write checklist.
Step 2: Execute checklist manually.
Step 3: Log failures.
Step 4: Commit.

---

## Suggested first implementation milestone

If we start immediately, the smartest first milestone is:
1. repo skeleton
2. game brief
3. starter zone brief
4. backend scaffold
5. login + movement replication
6. one blocked-out 3D starter zone

That gives us a visible MMO foundation quickly instead of overdesigning.

## Recommended naming direction

Do not use Elegon, WoW, Azeroth, Elwynn, or any recognizably derivative names.
Create an original world and brand from day one.

## Immediate next action

Create the repo skeleton and the three foundational docs first:
- README.md
- docs/game-brief.md
- docs/starter-zone.md

Then initialize Godot client + SpacetimeDB server.
