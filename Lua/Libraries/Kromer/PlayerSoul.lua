local self = {}

local truepos = {320,240}
local velocity = {0,0}

local wallcheck = function(xv,yv)
     local half_w = (self.sprite.width/2)-self.collisionpadding
     local half_h = (self.sprite.height/2)-self.collisionpadding

     -- Calculate cardinal collision

     if not (PointInPolygon({truepos[1]+half_w,truepos[2]},Arena.truecornerpositions) and PointInPolygon({truepos[1]-half_w,truepos[2]},Arena.truecornerpositions) and PointInPolygon({truepos[1],truepos[2]+half_h},Arena.truecornerpositions) and PointInPolygon({truepos[1],truepos[2]-half_h},Arena.truecornerpositions)) then

          -- Find farthest outside point
          local points = {
               {truepos[1],truepos[2]+half_h},
               {truepos[1]+half_w,truepos[2]},
               {truepos[1],truepos[2]-half_h},
               {truepos[1]-half_w,truepos[2]},
          }
          local ms = 0
          local mdist = 0
          for i,v in ipairs(points) do
               local d = ((v[1]-Arena.currentx)^2 + (v[2]-Arena.currenty)^2)
               if d > mdist then
                    ms = i
                    mdist = d
               end
          end

          -- Compare that side to all arena sides and find closest
          local p1 = {}
          local p2 = {}
          if ms == 1 then
               p1 = {truepos[1]-half_w,truepos[2]+half_h}
               p2 = {truepos[1]+half_w,truepos[2]+half_h}
          elseif ms == 2 then
               p1 = {truepos[1]+half_w,truepos[2]+half_h}
               p2 = {truepos[1]+half_w,truepos[2]-half_h}
          elseif ms == 3 then
               p1 = {truepos[1]-half_w,truepos[2]-half_h}
               p2 = {truepos[1]+half_w,truepos[2]-half_h}
          elseif ms == 4 then
               p1 = {truepos[1]-half_w,truepos[2]+half_h}
               p2 = {truepos[1]-half_w,truepos[2]-half_h}
          end
          local res = {}
          for i = 1, 4 do
               local ov = i+1
               if ov > 4 then ov = 1 end
               local x,y = LineIntersection(p1,p2,Arena.truecornerpositions[i],Arena.truecornerpositions[ov])
               res[#res+1] = {x,y,i,ov}
          end
          table.sort(res,function(a,b) return ((a[1]-truepos[1])^2 + (a[2]-truepos[2])^2) < ((b[1]-truepos[1])^2 + (b[2]-truepos[2])^2) end)

          -- Move parallel to line - keep momentum
          local dir = math.atan2(Arena.truecornerpositions[res[1][3]][2]-Arena.truecornerpositions[res[1][4]][2],Arena.truecornerpositions[res[1][3]][1]-Arena.truecornerpositions[res[1][4]][1])
          local og_dist = math.sqrt((xv)^2+(yv)^2)
          local og_dir = math.atan2(yv,xv)
          if math.abs(og_dir - dir) < math.abs(og_dir + dir) then
               truepos[1] = truepos[1] + math.cos(dir)*og_dist
               truepos[2] = truepos[2] + math.sin(dir)*og_dist
          else
               truepos[1] = truepos[1] - math.cos(dir)*og_dist
               truepos[2] = truepos[2] - math.sin(dir)*og_dist
          end

          local i = 10000
          --Move perpendicular to said line until we are within the bounds again.
          while not PointInPolygon(points[ms],Arena.truecornerpositions) and i > 0 do
               points = {
                    {truepos[1],truepos[2]+half_h},
                    {truepos[1]+half_w,truepos[2]},
                    {truepos[1],truepos[2]-half_h},
                    {truepos[1]-half_w,truepos[2]},
               }
               truepos[1] = truepos[1] - math.cos(dir-math.pi/2)
               truepos[2] = truepos[2] - math.sin(dir-math.pi/2)
               i = i - 1
               --self.ignorewalls = true
          end
     end
end

self.x         = 0
self.y         = 0
self.absx      = 0
self.absy      = 0
self.sprite    = CreateSprite("ut-heart","Bullet")
self.ishurting = false
self.ismoving  = false
self.collisionpadding = 3
self.ignorewalls = false

function self.SetControlOverride(override)
end

function self.Move(x, y)
     truepos[1] = truepos[1] + x
     truepos[2] = truepos[2] + y
     velocity = {velocity[1]+x,velocity[2]+y}
end
function self.MoveTo(x, y)
     local old = {truepos[1],truepos[2]}
     truepos[1] = Arena.currentx + x
     truepos[2] = Arena.currenty + y
     velocity = {velocity[1]+Arena.currentx+x-old[1],velocity[2]+Arena.currenty+y-old[2]}
end
function self.MoveToAbs(x, y)
     local old = {truepos[1],truepos[2]}
     truepos[1] = x
     truepos[2] = y
     velocity = {velocity[1]+x-old[1],velocity[2]+y-old[2]}
end

function self.Update()
     if Input.Up > 0 then self.Move(0,2) end
     if Input.Down > 0 then self.Move(0,-2) end
     if Input.Left > 0 then self.Move(-2,0) end
     if Input.Right > 0 then self.Move(2,0) end
     if not self.ignorewalls then wallcheck(velocity[1],velocity[2]) end

     self.sprite.MoveToAbs(truepos[1],truepos[2])

     self.absx = truepos[1]
     self.absy = truepos[2]
     self.x = truepos[1] - Arena.currentx
     self.y = truepos[2] - Arena.currenty

     velocity = {0,0}
end

return self
