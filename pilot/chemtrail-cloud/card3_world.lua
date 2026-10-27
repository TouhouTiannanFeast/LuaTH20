-- Isolated preview simulation: Lua 5.1. Original screen coordinates, Y down.
-- Emission subroutine is executed by card3_emitter; all deviations are in README.
local E=require('card3_emitter')
local M={}
local streams={{10,-2.7488935,3.883222},{9,-.3926991,-3.883222},{7,2.7488935,-3.883222},{8,.3926991,3.883222},{14,-1.5707964,3.883222}}
function M.new(seed)
 local s={frame=0,boss={x=0,y=128},bullets={},tasks={},events={},rng=seed or 1, next_id=1}
 function s:random() self.rng=(self.rng*48271)%2147483647;return (self.rng-1)/2147483646 end
 function s:launch_cycle()
   -- The main/synchronous stream executes first; new async tasks start next tick.
   self.tasks={}
   for i=1,5 do self.tasks[i]={started=false,params=streams[i]} end
   self.events[#self.events+1]={kind='cycle',frame=self.frame}
 end
 function s:step()
   if self.frame>=3960 then return false end
   if self.frame>=150 and (self.frame-150)%340==0 then self:launch_cycle() end
   local phase=(self.frame-150)%340
   -- Approximation: move during the final 60 frames of each cycle.
   if self.frame>=150 and phase==280 then
      self.move={x=self.boss.x,y=self.boss.y,tx=math.max(-50,math.min(50,self.boss.x+(self:random()*2-1)*60)),ty=math.max(96,math.min(160,self.boss.y+(self:random()*2-1)*60))}
   end
   if self.move and phase>=280 then local t=math.min(1,(phase-280+1)/60);t=1-(1-t)*(1-t);self.boss.x=self.move.x+(self.move.tx-self.move.x)*t;self.boss.y=self.move.y+(self.move.ty-self.move.y)*t end
   local order={5,4,3,2,1}
   for _,i in ipairs(order) do local task=self.tasks[i]
     if task and not task.done and (i==5 or phase>0) then
       if not task.started then
         local p=task.params; task=E.new{color=p[1],origin_angle=p[2],increment=p[3],random_angle=self:random()*2*math.pi-math.pi};task.started=true;self.tasks[i]=task
       end
       local old=#task.shots;task:tick()
       for j=old+1,#task.shots do local q=task.shots[j]
         local x=self.boss.x+math.cos(q.origin_angle)*q.radius
         local y=self.boss.y+math.sin(q.origin_angle)*q.radius
         local vx=math.cos(q.angle)*q.speed;local vy=math.sin(q.angle)*q.speed
         self.bullets[#self.bullets+1]={id=self.next_id,x=x-4*vx,y=y-4*vy,vx=vx,vy=vy,age=0,color=q.color}
         self.next_id=self.next_id+1
       end
     end
   end
   local alive={}
   for _,b in ipairs(self.bullets) do
     -- ETEX type 2: linear acceleration .008 at pi/2 for 200 updates.
     if b.age<200 then b.vy=b.vy+0.008 end
     b.x=b.x+b.vx;b.y=b.y+b.vy;b.age=b.age+1
     if b.x>-224 and b.x<224 and b.y>-32 and b.y<480 and b.age<900 then alive[#alive+1]=b end
   end
   self.bullets=alive;self.frame=self.frame+1;return true
 end
 function s:clear() self.bullets={} end
 return s
end
return M

