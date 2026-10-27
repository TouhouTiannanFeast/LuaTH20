from pathlib import Path
from lupa import lua51, luajit21
p = Path(__file__).with_name('card3_emitter.lua').read_text(encoding='ascii')
streams = [(10,-2.7488935,3.883222), (9,-.3926991,-3.883222), (7,2.7488935,-3.883222), (8,.3926991,3.883222), (14,-1.5707964,3.883222)]
for backend in (lua51, luajit21):
    lua=backend.LuaRuntime(unpack_returned_tuples=True)
    module=lua.execute(p)
    for color,origin,increment in streams:
        s=module.new(lua.table_from(dict(color=color,origin_angle=origin,increment=increment,random_angle=0)))
        for _ in range(151): s.tick(s)
        assert s.done and len(s.shots)==150 and len(s.effects)==2
        for i in (1,2,75,150):
            shot=s.shots[i]
            assert shot.tick==i-1 and shot.color==color and shot.speed==1
            assert abs(shot.radius-(i-1)*2.25)<1e-9
            expected=(((i-1)*increment+3.141592653589793)%(2*3.141592653589793))-3.141592653589793
            assert abs(shot.angle-expected)<1e-9
    print(backend.__name__, '5 streams, 750 shot events: OK')
