local self = {}

local Arenas = {}

self.x        = 320
self.y        = 240
self.xscale   = 1
self.yscale   = 1
self.rotation = 0
self.vertices = {{-75,75},{75,75},{75,-75},{-75,-75}}
self.modspeed = 10

self.currentx = self.x
self.currenty = self.y
self.currentxscale = self.xscale
self.currentyscale = self.yscale
self.currentrotation = self.rotation
self.currentvertices = {{-75,75},{75,75},{75,-75},{-75,-75}}

self.truecornerpositions = {}

self.borderwidth = 4
self.bordercolor = {0,192/255,0}
self.fillcolor   = {0,0,0}

function self.isModifying()
     return self.isMoving() or self.isResizing() or self.isRotating() or self.isDistorting()
end

function self.isMoving()
     return not (self.currentx == self.x and self.currenty == self.y)
end

function self.isResizing()
     return not (self.currentxscale == self.xscale and self.currentyscale == self.yscale)
end

function self.isRotating()
     return not (self.currentrotation == self.rotation)
end

function self.isDistorting()
     for i = 1, 4 do
          for p = 1, 2 do
               if self.vertices[i][p] ~= self.currentvertices[i][p] then
                    return true
               end
          end
     end
     return false
end

function self.Move(x,y,immediate)
     self.x = self.currentx + x
     self.y = self.currenty + y
     if immediate then
          self.currentx = self.x
          self.currenty = self.y
     end
end

function self.MoveTo(x,y,immediate)
     self.x = x
     self.y = y
     if immediate then
          self.currentx = self.x
          self.currenty = self.y
     end
end

function self.Resize(w,h,immediate)
     self.xscale = w
     self.yscale = h
     if immediate then
          self.currentxscale = self.xscale
          self.currentyscale = self.yscale
     end
end

function self.Rotate(r,immediate)
     self.rotation = r
     if immediate then self.currentrotation = self.rotation end
end

function self.Distort(vert,x,y,immediate)
     self.vertices[vert][1] = x
     self.vertices[vert][2] = y
     if immediate then
          self.currentvertices[vert][1] = x
          self.currentvertices[vert][2] = y
     end
end

function self.Hide()
end

function self.Show()
end

local CreateArena = function(args)
     local a = {}

     for k,v in pairs(args) do
          a[k] = v
     end

     a.bordersprites = {}
     a.fillsprites = {}
     a.cornersprites = {}
     for i = 1, 4 do
          a.fillsprites[i] = CreateSprite("px","Arena")
          a.cornersprites[i] = {}
          a.cornersprites[i][1] = CreateSprite("px","Arena")
          a.cornersprites[i][1].Mask("stencil")
          --a.cornersprites[i][1].color = {1,0,0,0.5}
          a.cornersprites[i][2] = CreateSprite("px","Arena")
          --a.cornersprites[i][2].color = {0,0,1,0.5}
          a.cornersprites[i][2].SetParent(a.cornersprites[i][1])
          a.bordersprites[i] = CreateSprite("px","Arena")

          if i ~= 1 then
               a.fillsprites[i].SetParent(a.fillsprites[i-1])
          end
          if i ~= 4 then
               a.fillsprites[i].Mask("stencil")
          end
     end

     table.insert(Arenas,a)
     return a
end

local TrueArena = CreateArena({truearena=true})

function self.Update()
     if Input.Menu == 1 then
          for i = 1, #heroes do
               --heroes[i].Move(math.random()*200,math.random()*200)
               heroes[i].SetAnimation("Hurt")
          end
          for i = 1, 4 do
               self.Distort(i,self.currentvertices[i][1]+math.random(-50,50),self.currentvertices[i][2]+math.random(-50,50),true)
          end
     end

     TrueArena.x = self.x
     TrueArena.y = self.y
     TrueArena.xscale = self.xscale
     TrueArena.yscale = self.yscale
     TrueArena.rotation = self.rotation
     TrueArena.vertices = self.vertices
     TrueArena.currentx = self.currentx
     TrueArena.currenty = self.currenty
     TrueArena.currentxscale = self.currentxscale
     TrueArena.currentyscale = self.currentyscale
     TrueArena.currentrotation = self.currentrotation
     TrueArena.currentvertices = self.currentvertices
     TrueArena.borderwidth = self.borderwidth
     TrueArena.bordercolor = self.bordercolor
     TrueArena.fillcolor = self.fillcolor

     self.Rotate(Input.MousePosX)

     --self.Rotate(self.rotation+1,true)
     --self.MoveTo(320+math.sin(Time.time*4)*50,240+math.sin(Time.time*8)*25,true)
     --self.Resize(1+math.sin(Time.time*3)*0.5,1+math.sin(Time.time*7)*0.5)

     --self.Distort(1,Input.MousePosX-320,Input.MousePosY-240,true)

     for _,arena in ipairs(Arenas) do

          if arena.truearena then
               if self.isMoving() then
                    local xd = self.x - self.currentx
                    if math.abs(xd) <= self.modspeed then
                         self.currentx = self.x
                    else
                         self.currentx = self.currentx + self.modspeed*sign(xd)
                    end

                    local yd = self.y - self.currenty
                    if math.abs(yd) <= self.modspeed then
                         self.currenty = self.y
                    else
                         self.currenty = self.currenty + self.modspeed*sign(yd)
                    end
               end
               if self.isRotating() then
                    local rd = self.rotation - self.currentrotation
                    if math.abs(rd) <= self.modspeed then
                         self.currentrotation = self.rotation
                    else
                         self.currentrotation = self.currentrotation + self.modspeed*sign(rd)
                    end
               end
               if self.isResizing() then
                    local xd = self.xscale - self.currentxscale
                    if math.abs(xd) <= self.modspeed then
                         self.currentxscale = self.xscale
                    else
                         self.currentxscale = self.currentxscale + self.modspeed*sign(xd)
                    end

                    local yd = self.yscale - self.currentyscale
                    if math.abs(yd) <= self.modspeed then
                         self.currentyscale = self.yscale
                    else
                         self.currentyscale = self.currentyscale + self.modspeed*sign(yd)
                    end
               end
               if self.isDistorting() then
                    for i = 1, 4 do
                         local xd = self.vertices[i][1] - self.currentvertices[i][1]
                         if math.abs(xd) <= self.modspeed then
                              self.currentvertices[i][1] = self.vertices[i][1]
                         else
                              self.currentvertices[i][1] = self.currentvertices[i][1] + self.modspeed*sign(xd)
                         end

                         local yd = self.vertices[i][2] - self.currentvertices[i][2]
                         if math.abs(yd) <= self.modspeed then
                              self.currentvertices[i][2] = self.vertices[i][2]
                         else
                              self.currentvertices[i][2] = self.currentvertices[i][2] + self.modspeed*sign(yd)
                         end
                    end
               end
          end

          local r = math.rad(arena.currentrotation)

          -- Borders
          for i = 1, 4 do

               local b = arena.bordersprites[i]
               local f = arena.fillsprites[i]
               local c = arena.cornersprites[i]
               local ov = i+1
               if ov > 4 then ov = 1 end

               local v1x = arena.currentvertices[i][1]*arena.currentxscale
               local v1y = arena.currentvertices[i][2]*arena.currentyscale
               local v2x = arena.currentvertices[ov][1]*arena.currentxscale
               local v2y = arena.currentvertices[ov][2]*arena.currentyscale


               local x1 = v1x*math.cos(r)-v1y*math.sin(r)
               local y1 = v1y*math.cos(r)+v1x*math.sin(r)

               if arena.truearena then
                    self.truecornerpositions[i] = {arena.currentx+x1,arena.currenty+y1}
               end

               local x2 = v2x*math.cos(r)-v2y*math.sin(r)
               local y2 = v2y*math.cos(r)+v2x*math.sin(r)

               local xscale = math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
               local rot = math.atan2(y2-y1,x2-x1)

               b.MoveTo(arena.currentx+lerp(x1,x2,0.5),arena.currenty+lerp(y1,y2,0.5))
               b.xscale = xscale
               b.yscale = arena.borderwidth
               b.ypivot = 0
               b.color = arena.bordercolor
               b.rotation = math.deg(rot)

               f.MoveToAbs(b.x,b.y)
               f.rotation = b.rotation+90
               f.xpivot = 1
               f.xscale = 10000
               f.yscale = 10000
               f.color = arena.fillcolor


               c[1].MoveTo(arena.currentx+x1,arena.currenty+y1)
               c[1].Scale(1000,arena.borderwidth*2)
               c[1].rotation = b.rotation
               c[1].xpivot = 1
               c[1].color = arena.bordercolor

               c[2].MoveToAbs(arena.currentx+x1,arena.currenty+y1)
               c[2].Scale(1000,arena.borderwidth*2)
               c[2].xpivot = 0
               c[2].color = arena.bordercolor

               arena.cornersprites[ov][2].rotation = b.rotation
          end

          if not arena.truearena then

          end
     end

end

return self
