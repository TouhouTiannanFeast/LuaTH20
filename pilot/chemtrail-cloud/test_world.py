from pathlib import Path
from lupa import lua51, luajit21
import json
here=Path(__file__).parent
for backend in (lua51,luajit21):
    l=backend.LuaRuntime(unpack_returned_tuples=True)
    l.execute('package.path = ... .. "/?.lua;" .. package.path',here.resolve().as_posix())
    w=l.eval("require('card3_world')").new(12345)
    snapshots={}; samples={180,240,360,480,600,900,1200}
    for _ in range(3960):
        assert w.step(w)
        if w.frame in samples:
            snapshots[w.frame]=[(b.x,b.y,b.color) for _,b in w.bullets.items()]
    assert not w.step(w)
    cycles=[v.frame for _,v in w.events.items()]
    assert cycles==list(range(150,3960,340)), cycles
    assert all(len(snapshots[n])>0 for n in samples)
    print(backend.__name__, 'completed 3960 frames; cycles',len(cycles),'spawned',w.next_id-1)
    if backend==lua51:
        (here/'preview-snapshots.json').write_text(json.dumps(snapshots),encoding='utf8')
        (here/'diagnostics.json').write_text(json.dumps({'duration_frames':3960,'cycle_frames':cycles,'spawned':w.next_id-1,'snapshot_counts':{str(k):len(v) for k,v in snapshots.items()},'reference_parity_verified':False},indent=2),encoding='utf8')
