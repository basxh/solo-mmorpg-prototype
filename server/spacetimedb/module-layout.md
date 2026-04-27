# SpacetimeDB module layout

Recommended server layout once the backend toolchain is installed:

- server/spacetimedb/src/lib.rs
  - module entrypoint
- server/spacetimedb/src/player.rs
  - player session/state tables
- server/spacetimedb/src/movement.rs
  - movement reducers and validation
- server/spacetimedb/src/chat.rs
  - local chat and routing
- server/spacetimedb/src/combat.rs
  - target selection, auto attack, abilities
- server/spacetimedb/src/quests.rs
  - quest acceptance and progress reducers
- server/spacetimedb/src/loot.rs
  - drops, pickups, equipment state
- server/spacetimedb/src/content.rs
  - shared content loading and ids

Authoritative event flow:
1. client login request
2. player record fetch or create
3. starter zone spawn packet
4. movement updates validated server-side
5. chat/combat/quest updates replicated to interested players

Important rule:
The server owns world truth. The client predicts only for feel, never for authority.
