# TH20 ECL pilot: Nina, Chemtrail Cloud

Target: st07bs.ecl, BossCard3 / BossCard3_at, spell ID 105, 真実「ケムトレイルクラウド」.

## Run

Install Python 3 with Tkinter and Lupa (`py -3 -m pip install lupa` on Windows), then run `py -3 preview.py` in this folder or double-click Preview.cmd. Arrow keys move, Shift slows, X clears the screen, R restarts, P pauses. Run `py -3 test_emitter.py` and `py -3 test_world.py` for checks.

## Scope

An isolated Lua 5.1 simulation transcribes a narrow firing-subroutine instruction subset, schedules four asynchronous streams and one synchronous stream, repeats the pattern, approximates boss movement, and emits bullets for the 3,960-frame phase. It approximates birth offset and acceleration. The world does not execute ECL files and is not integrated with MLforDanmu or AEX+.

Random state/call order, floating point rounding, angle wrapping, frame order, script scheduling, boss movement, bounds and bullet removal are not verified against original TH20. Graphics, collision and clearing are placeholders. Original sprite, ANM, health, shooting, bomb behavior and complete combat are not included. This is a previewable approximation, not a faithful or complete port.

The emitter tests check five parameter sets and 750 local events under Lua 5.1 and LuaJIT 2.1. The world test advances 3,960 frames and checks 12 scheduled cycles under both. A GUI smoke check was run locally. These are internal consistency checks; original game comparison is outstanding.

References: the locally extracted st07bs.ecl and the [Oracatt/Touhou20 ECL VM](https://github.com/Oracatt/Touhou20/tree/main/source_reconstruction/ecl_vm), [bullet system](https://github.com/Oracatt/Touhou20/tree/main/source_reconstruction/bullet_system), and [enemy shot handler](https://github.com/Oracatt/Touhou20/blob/main/source_reconstruction/gameplay/enemy_shot.cpp). No external code was copied. Original game data and assets are not included.

Next: compare an independently captured same-input/seed trace; replace approximations; implement source-driven ECL parsing and connect the shared runtime and AEX+; then validate combat and cleanup.
