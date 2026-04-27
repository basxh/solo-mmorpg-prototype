# Local Development

Current environment status:
- Godot: not installed in this environment
- SpacetimeDB: not installed in this environment
- Rust/Cargo: not installed in this environment

This repository is scaffolded so implementation can begin immediately once the toolchain is available.

Recommended setup on a dev machine:
1. Install Godot 4.x
2. Install Rust + Cargo
3. Install SpacetimeDB CLI/runtime
4. Open client/project.godot in Godot
5. Initialize the real backend inside server/spacetimedb/

First run target:
- open the world_root scene
- verify client bootstrap prints a successful local scaffold connection
- replace the fake network client with the real backend transport

Immediate next coding priorities:
- client login scene
- client controllable player character
- real backend session reducer
- replicated movement state
