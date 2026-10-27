"""Standalone local preview. Run with the project .venv Python."""
from pathlib import Path
import sys, time, tkinter as tk
from lupa import lua51
HERE=Path(__file__).resolve().parent
lua=lua51.LuaRuntime(unpack_returned_tuples=True)
lua.execute('package.path = ... .. "/?.lua;" .. package.path', HERE.as_posix())
world=lua.eval("require('card3_world')").new(12345)
root=tk.Tk();root.title('TH20 ECL pilot - Chemtrail Cloud (approximation)')
c=tk.Canvas(root,width=384,height=448,bg='#0d1321',highlightthickness=0);c.pack()
status=tk.Label(root,text='',font=('Arial',10));status.pack()
keys=set();player=[192.,388.];hits=0;cooldown=0;paused=False
colors={10:'#f68080',9:'#a3eb85',7:'#99a9ff',8:'#6ae5ed',14:'#d59fff'}
def keydown(e):
 global paused,hits,cooldown
 keys.add(e.keysym)
 if e.keysym.lower()=='x': world.clear(world)
 if e.keysym.lower()=='r': reset()
 if e.keysym.lower()=='p': paused=not paused
def reset():
 global world,hits,cooldown
 world=lua.eval("require('card3_world')").new(12345);player[:]=[192.,388.];hits=0;cooldown=0
root.bind('<KeyPress>',keydown);root.bind('<KeyRelease>',lambda e:keys.discard(e.keysym))
def frame():
 global hits,cooldown
 start=time.perf_counter()
 if not paused and world.frame<3960:
  speed=2 if ('Shift_L' in keys or 'Shift_R' in keys) else 4
  player[0]=max(2,min(382,player[0]+speed*((('Right' in keys)-( 'Left' in keys)))))
  player[1]=max(2,min(446,player[1]+speed*((('Down' in keys)-( 'Up' in keys)))))
  world.step(world);cooldown=max(0,cooldown-1)
 c.delete('all')
 for _,b in world.bullets.items():
  x,y=b.x+192,b.y
  c.create_oval(x-3,y-3,x+3,y+3,fill=colors.get(b.color,'white'),outline='')
  if not cooldown and (x-player[0])**2+(y-player[1])**2<25:
   hits+=1;cooldown=120
 c.create_oval(world.boss.x+184,world.boss.y-8,world.boss.x+200,world.boss.y+8,fill='#f9d77b',outline='')
 x,y=player;c.create_oval(x-4,y-4,x+4,y+4,fill='white',outline='');c.create_oval(x-1,y-1,x+1,y+1,fill='red',outline='')
 status.config(text=f'{world.frame/60:.1f}s / 66s | hits {hits} | arrows move, Shift slow, X clear, R reset, P pause')
 root.after(max(1,int(1000/60-(time.perf_counter()-start)*1000)),frame)
if '--smoke' in sys.argv:
 def finish_smoke():
  assert world.frame > 0, 'preview did not advance'
  print('PREVIEW_SMOKE_OK frames=', world.frame, flush=True)
  root.destroy()
 root.after(600,finish_smoke)
root.after(0,frame);root.mainloop()
