-- Restricted ECL-inspired execution probe for st07bs BossCard3_at.
-- Input is a manually transcribed subset, not an ECL parser.
local M = {}
local function wrap(a) return (a + math.pi) % (2 * math.pi) - math.pi end
local program = {
  {'reset'}, {'aim_mode',3}, {'sprite',10,'color'}, {'count',1,1},
  {'angle',1.5707964,0}, {'speed',1,0},
  {'effect',0,1,1,-9999994,-9999994,-9999994},
  {'effect',0,2,200,-9999994,0.008,1.5707964},
  {'init'}, {'offset','origin_angle','radius'}, {'angle','heading',0.10471976},
  {'fire'}, {'advance'}, {'wait',1}, {'loop'}
}
local function value(t,x) if type(x)=='string' then return assert(t[x],x) end return x end
function M.new(args)
  assert(type(args)=='table' and type(args.random_angle)=='number', 'provide sampled random angle')
  local s={pc=1,time=0,wait=0,count=0,color=args.color,origin_angle=args.origin_angle,
    increment=args.increment,heading=args.random_angle,radius=0,shots={},effects={}}
  function s:tick()
    if self.done then return end
    if self.wait>0 then self.wait=self.wait-1; if self.wait>0 then self.time=self.time+1; return end end
    while not self.done do
      local op=program[self.pc]; local name=op[1]
      if name=='reset' then self.shooter={}
      elseif name=='aim_mode' then self.shooter.aim_mode=op[2]
      elseif name=='sprite' then self.shooter.sprite=op[2]; self.shooter.color=value(self,op[3])
      elseif name=='count' then self.shooter.count={op[2],op[3]}
      elseif name=='angle' then self.shooter.angle=value(self,op[2]); self.shooter.spread=op[3]
      elseif name=='speed' then self.shooter.speed=op[2]
      elseif name=='effect' then self.effects[#self.effects+1]={op[2],op[3],op[4],op[5],op[6],op[7]}
      elseif name=='init' then self.count=0
      elseif name=='offset' then self.shooter.offset_angle=value(self,op[2]); self.shooter.offset_radius=value(self,op[3])
      elseif name=='fire' then
        self.shots[#self.shots+1]={tick=self.time,angle=self.shooter.angle,radius=self.shooter.offset_radius,
          origin_angle=self.shooter.offset_angle,color=self.shooter.color,speed=self.shooter.speed}
      elseif name=='advance' then self.heading=wrap(self.heading+self.increment); self.radius=self.radius+2.25
      elseif name=='wait' then self.wait=op[2]; self.pc=self.pc+1; break
      elseif name=='loop' then self.count=self.count+1; if self.count<150 then self.pc=10 else self.done=true end
      else error('unsupported operation: '..tostring(name)) end
      if name~='loop' then self.pc=self.pc+1 end
    end
    self.time=self.time+1
  end
  return s
end
return M
