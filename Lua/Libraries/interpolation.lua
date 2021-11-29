--KyYay's interpolation library
local self = {}
local moving = {}
self.loopmode = "CAP"

function self.applyloopmode(t)
	if self.loopmode == "CAP" then
		return math.max(math.min(t,1),0)
	elseif self.loopmode == "REFLECT" then
		return math.min(t%2,-t%2)
	end
	return t
end

function self.linear(s,e,t)
	t = self.applyloopmode(t)
	return s+(e-s)*t
end

function self.easeinout(s,e,t)
	t = self.applyloopmode(t)
	return s+(e-s)*(-math.cos(t*math.pi)+1)*0.5
end

function self.easein(s,e,t)
	t = self.applyloopmode(t)
	return s+(e-s)*(-math.cos(t*math.pi*0.5)+1)
end

function self.easeout(s,e,t)
	t = self.applyloopmode(t)
	return s+(e-s)*(math.sin(t*math.pi*0.5))
end

function self.easeoutin(s,e,t)
	t = self.applyloopmode(t)
	if t < 0.5 then
		return self.easeout(s,s+(e-s)*0.5,t*2)
	else
		return self.easein(s+(e-s)*0.5,e,(t-0.5)*2)
	end
end

function self.bouncein(s,e,t)
	return self.bounceout(e,s,1-t)
end

function self.bounceout(s,e,t)
	t = self.applyloopmode(t)
	local scale = 1
	local offset = -1/3
	local reps = 0
	while (t-(offset+2/3*scale) > 0 and reps < 25) do
		offset = offset+2/3*scale
		scale = scale*0.5
		reps = reps + 1
	end
	t = t-offset
	return s+(e-s)*(1-math.sin(t*math.pi*1.5/scale)*scale)
end

function self.bounceinout(s,e,t)
	t = self.applyloopmode(t)
	if t < 0.5 then
		return self.bouncein(s,s+(e-s)*0.5,t*2)
	else
		return self.bounceout(s+(e-s)*0.5,e,(t-0.5)*2)
	end
end

function self.lightbouncein(s,e,t)
	return self.lightbounceout(e,s,1-t)
end

function self.lightbounceout(s,e,t)
	t = self.applyloopmode(t)
	local scale = 1
	local offset = -1/3
	local reps = 0
	while (t-(offset+2/3*scale) > 0 and reps < 25) do
		offset = offset+2/3*scale
		scale = scale*0.5
		reps = reps + 1
	end
	t = t-offset
	return s+(e-s)*(1-math.sin(t*math.pi*1.5/scale)*scale^2)
end

function self.lightbounceinout(s,e,t)
	t = self.applyloopmode(t)
	if t < 0.5 then
		return self.lightbouncein(s,s+(e-s)*0.5,t*2)
	else
		return self.lightbounceout(s+(e-s)*0.5,e,(t-0.5)*2)
	end
end

function self.stronginout(s,e,t)
	return s+(e-s)*(-math.cos(self.easeinout(0,1,t)*math.pi)+1)*0.5
end

function self.strongin(s,e,t)
	t = self.applyloopmode(t)
	return s+(e-s)*(-math.cos(self.easein(0,1,t)*math.pi*0.5)+1)
end

function self.strongout(s,e,t)
	t = self.applyloopmode(t)
	return s+(e-s)*(math.sin(self.easeout(0,1,t)*math.pi*0.5))
end

function self.strongoutin(s,e,t)
	t = self.applyloopmode(t)
	if t < 0.5 then
		return self.strongout(s,s+(e-s)*0.5,t*2)
	else
		return self.strongin(s+(e-s)*0.5,e,(t-0.5)*2)
	end
end

function self.gentlein(s,e,t)
	return s+(e-s)*(math.sin(self.easein(0,1,t)*math.pi*0.5))
end

function self.gentleout(s,e,t)
	return s+(e-s)*(-math.cos(self.easeout(0,1,t)*math.pi)+1)*0.5
end

function self.gentleoutin(s,e,t)
	t = self.applyloopmode(t)
	if t < 0.5 then
		return self.easeout(s,s+(e-s)*0.5,self.easeinout(0,1,t)*2)
	else
		return self.easein(s+(e-s)*0.5,e,(self.easeinout(0,1,t)-0.5)*2)
	end
end

function self.taninout(s,e,t)
	t = self.applyloopmode(t)
	return s+(e-s)*(2*t-(math.tan((t-0.5)*math.pi/2)/2+0.5))
end

function self.tanoutin(s,e,t)
	t = self.applyloopmode(t)
	return s+(e-s)*(math.tan((t-0.5)*math.pi/2)/2+0.5)
end

--easing formulas below are courtesy of https://easings.net/

function self.backinout(s,e,t)
	t = self.applyloopmode(t)
	local c1 = 1.70158;
	local c2 = c1 * 1.525;
	if t < 0.5 then
	    return s+(e-s)*(((2 * t)^2 * ((c2 + 1) * 2 * t - c2)) / 2)
	else
	    return s+(e-s)*(((2 * t - 2)^2 * ((c2 + 1) * (t * 2 - 2) + c2) + 2) / 2)
	end
end

function self.backin(s,e,t)
	t = self.applyloopmode(t)
	local c1 = 1.70158;
	local c3 = c1 + 1;
	return s+(e-s)*(c3 * t * t * t - c1 * t * t)
end

function self.backout(s,e,t)
	t = self.applyloopmode(t)
	local c1 = 1.70158;
	local c3 = c1 + 1;
	return s+(e-s)*(1 + c3 * (t - 1)^3 + c1 * (t - 1)^2)
end

function self.elasticinout(s,e,t)
	t = self.applyloopmode(t)
	local c5 = (2 * math.pi) / 4.5
	if t == 0 then return s elseif t == 1 then return e end
	if t < 0.5 then
		return s+(e-s)*(-(2^(20 * t - 10) * math.sin((20 * t - 11.125) * c5)) / 2)
	else
		return s+(e-s)*((2^(-20 * t + 10) * math.sin((20 * t - 11.125) * c5)) / 2 + 1)
	end
end

function self.elasticin(s,e,t)
	t = self.applyloopmode(t)
	local c4 = (2 * math.pi) / 3;
	return t == 0 and s or t == 1 and e or s+(e-s)*(-(2^(10 * t - 10)) * math.sin((t * 10 - 10.75) * c4))
end

function self.elasticout(s,e,t)
	t = self.applyloopmode(t)
	local c4 = (2 * math.pi) / 3;
	return t == 0 and s or t == 1 and e or s+(e-s)*(2^(-10 * t) * math.sin((t * 10 - 0.75) * c4) + 1)
end

--moves a sprite or a projectile automatically, according to the easing mode you input for mode (assuming you are calling self.Update every frame),
--mode should just be the name of one of the functions above (except applyloopmode), minus the "self."
--if timebased is true, t is in seconds; otherwise, it is in frames.

function self.GetItem(ID)
	if moving[ID] ~= nil then
		return moving[ID]
	else
		--KROMER_LOG("Interpolation "..ID.." does not exist!",2)
		--return false
	end
end

function self.GetValue(ID)
	if moving[ID] ~= nil then
		return moving[ID].obj
	else
		--KROMER_LOG("Interpolation "..ID.." does not exist!",2)
		--return false
	end
end

function self.SetValue(ID,start,tar,t,mode,timebased)
	if timebased then
		moving[ID] = {obj=start,mode=mode,tx=tar,sx=start,lx=start,t=t,ct=Time.time,tb=timebased,type="number"}
		return true
	else
		moving[ID] = {obj=start,mode=mode,tx=tar,sx=start,lx=start,t=t,ct=0,tb=timebased,type="number"}
		return true
	end
	return false
end

function self.MoveObj(obj,x,y,t,mode,timebased)
	if timebased then
		moving[#moving+1] = {obj=obj,mode=mode,tx=obj.absx+x,ty=obj.absy+y,sx=obj.absx,sy=obj.absy,lx=obj.absx,ly=obj.absy,t=t,ct=Time.time,tb=timebased}
	else
		moving[#moving+1] = {obj=obj,mode=mode,tx=obj.absx+x,ty=obj.absy+y,sx=obj.absx,sy=obj.absy,lx=obj.absx,ly=obj.absy,t=t,ct=0,tb=timebased}
	end
end

function self.MoveObjTo(obj,x,y,t,mode,timebased)
	if timebased then
		moving[#moving+1] = {obj=obj,mode=mode,tx=x,ty=y,sx=obj.absx,sy=obj.absy,lx=obj.absx,ly=obj.absy,t=t,ct=Time.time,tb=timebased}
	else
		moving[#moving+1] = {obj=obj,mode=mode,tx=x,ty=y,sx=obj.absx,sy=obj.absy,lx=obj.absx,ly=obj.absy,t=t,ct=0,tb=timebased}
	end
end

function self.ClearObjMovement(obj)
	for i in pairs(moving) do
		local m = moving[i]
		if m.obj == obj then
			moving[i] = nil
		end
	end
end

--call every frame for automatic interpolation

function self.Update()
	for i in pairs(moving) do
		local m = moving[i]
		if m.type ~= "number" then
			m.obj["interp_finish"] = false
			if m.tb then
				local newx,newy = self[m.mode](m.sx,m.tx,(Time.time-m.ct)/m.t),self[m.mode](m.sy,m.ty,(Time.time-m.ct)/m.t)
				m.obj.Move(newx-m.lx,newy-m.ly)
				m.lx,m.ly = newx,newy
				if (Time.time-m.ct) >= m.t then
					m.obj["interp_finish"] = true
					moving[i] = nil
				end
			else
				m.ct = m.ct + 1
				local newx,newy = self[m.mode](m.sx,m.tx,m.ct/m.t),self[m.mode](m.sy,m.ty,m.ct/m.t)
				m.obj.Move(newx-m.lx,newy-m.ly)
				m.lx,m.ly = newx,newy
				if m.ct >= m.t then
					m.obj["interp_finish"] = true
					moving[i] = nil
				end
			end
		else
			if m.tb then
				local newx = self[m.mode](m.sx,m.tx,(Time.time-m.ct)/m.t)
				m.obj = newx
				m.lx = newx
				if (Time.time-m.ct) >= m.t then
					moving[i] = nil
				end
			else
				m.ct = m.ct + 1
				local newx = self[m.mode](m.sx,m.tx,m.ct/m.t)
				m.obj = newx
				m.lx = newx
				if m.ct >= m.t then
					moving[i] = nil
				end
			end
		end
	end
end

return self
