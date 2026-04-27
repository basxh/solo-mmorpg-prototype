# Architecture

Project codename: Emberfall Online

Chosen architecture:
- Godot 4 client for fast indie 3D iteration
- SpacetimeDB authoritative backend for always-online multiplayer state
- shared JSON content for zones, quests, NPCs, items, and enemy definitions

High-level slices:
1. Client
   - rendering
   - input
   - UI/HUD
   - network replication and prediction
2. Server
   - login/session
   - world state
   - movement validation
   - combat/quests/chat
3. Shared content
   - starter zone
   - quests
   - NPCs
   - items and enemies later

Guiding principles:
- WoW/Elegon-inspired readability
- original world, lore, names, and systems details
- starter-zone-first execution
- server authoritative truth
- visible multiplayer feel early
