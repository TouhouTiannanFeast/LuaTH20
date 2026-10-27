# LuaTH20

## TH20 Lua adaptation snapshot

Snapshot date: 2026-10-28. Source: MySTG `aex-0.8.22/game/mod/MySTG/stages/zuu4/th20.lua`.

Two Normal-difficulty stage implementations: `P.non3` combines TH20 `Boss3_at` and `Boss4_at`; `P.stone` adapts `BossCard7` (Stone Goddess) with four layered subphases. Eight named local helpers support them. Anonymous callbacks are excluded from that count.

This file depends on the surrounding MySTG Zuu4 runtime, pattern table, host, and game assets; it is not a standalone playable package. It substitutes HSoB projectile graphics/collision and scales the nonspell bullet speeds. The corrected boss implementation was not tested or verified; original-game parity is not established. Preserve the source file unchanged. No original game resources or extracted scripts are included in this snapshot.

SHA-256 th20.lua: AA79FF1AADFF7D209BE7DB7DC0B0309F7E3D392A803E0C6F7CE95FEFEAF92933


## ECL execution pilot

See [Chemtrail Cloud pilot](pilot/chemtrail-cloud/README.md) for an isolated, approximate local Lua simulation and interactive preview. It does not run raw ECL and has not been compared frame by frame with TH20.
