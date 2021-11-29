-- This is a modified lua port of James Halliday's point-in-polygon repository
-- Here's the original license

--[[
The MIT License (MIT)

Copyright (c) 2016 James Halliday

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

function PointInPolygon(point, vs)
     local x = point[1]
     local y = point[2]
     local inside = false
     local i = 1
     local j = #vs
     while i <= #vs do
          local xi = vs[i][1]
          local yi = vs[i][2]

          local xj = vs[j][1]
          local yj = vs[j][2]

          local intersect = ((yi > y) ~= (yj > y)) and (x < (xj - xi) * (y - yi) / (yj - yi) + xi)
          if intersect then inside = not inside end

          j = i
          i = i + 1
     end
     return inside
end

--------------------------------------------------------------------------------

-- Modified line intersection code from rosettacode.org

function LineIntersection(s1, e1, s2, e2)
     local d = (s1[1] - e1[1]) * (s2[2] - e2[2]) - (s1[2] - e1[2]) * (s2[1] - e2[1])
     local a = s1[1] * e1[2] - s1[2] * e1[1]
     local b = s2[1] * e2[2] - s2[2] * e2[1]
     local x = (a * (s2[1] - e2[1]) - (s1[1] - e1[1]) * b) / d
     local y = (a * (s2[2] - e2[2]) - (s1[2] - e1[2]) * b) / d
     return x, y
end
