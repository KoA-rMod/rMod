--[[
* rMod - Copyright (c) 2018 atom0s [atom0s@live.com]
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
* To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
* Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*
* By using rMod, you agree to the above license and its terms.
*
*      Attribution - You must give appropriate credit, provide a link to the license and indicate if changes were
*                    made. You must do so in any reasonable manner, but not in any way that suggests the licensor
*                    endorses you or your use.
*
*   Non-Commercial - You may not use the material (rMod) for commercial purposes.
*
*   No-Derivatives - If you remix, transform, or build upon the material (rMod), you may not distribute the
*                    modified material. You are, however, allowed to submit the modified works back to the original
*                    rMod project in attempt to have it added to the original project.
*
* You may not apply legal terms or technological measures that legally restrict others
* from doing anything the license permits.
*
* No warranties are given.
]]--

----------------------------------------------------------------------------------------------------
-- func: math.distance2d
-- desc: Returns the 2D distance between two sets of coords.
----------------------------------------------------------------------------------------------------
function math.distance2d(x1, y1, x2, y2)
    local x = x2 - x1;
    local y = y2 - y1;
    return math.sqrt((x * x) + (y * y));
end

----------------------------------------------------------------------------------------------------
-- func: math.distance3d
-- desc: Returns the 3D distance between two sets of coords.
----------------------------------------------------------------------------------------------------
function math.distance3d(x1, y1, z1, x2, y2, z2)
    local x = x2 - x1;
    local y = y2 - y1;
    local z = z2 - z1;
    return math.sqrt((x * x) + (y * y) + (z * z));
end

----------------------------------------------------------------------------------------------------
-- func: math.degree2rad
-- desc: Converts a degree to a radian.
----------------------------------------------------------------------------------------------------
function math.degree2rad(d)
    local pi = 3.14159265359;
    return d * (pi / 180);
end

----------------------------------------------------------------------------------------------------
-- func: math.rad2degree
-- desc: Converts a radian to a degree.
----------------------------------------------------------------------------------------------------
function math.rad2degree(r)
    local pi = 3.14159265359;
    return r * (180 / pi);
end

----------------------------------------------------------------------------------------------------
-- func: math.clamp
-- desc: Clamps a number between a min and max value.
----------------------------------------------------------------------------------------------------
function math.clamp(n, min, max)
    if (n < min) then return min; end
    if (n > max) then return max; end
    return n;
end

----------------------------------------------------------------------------------------------------
-- func: math.round
-- desc: Rounds a number to the given decimal places.
----------------------------------------------------------------------------------------------------
function math.round(n, dp)
    local m = 10 ^ (dp or 0);
    return math.floor(n * m + 0.5) / m;
end

----------------------------------------------------------------------------------------------------
-- func: math.d3dcolor
-- desc: Converts the given ARGB values to make a D3DCOLOR.
----------------------------------------------------------------------------------------------------
function math.d3dcolor(a, r, g, b)
    local a = bit.lshift(bit.band(a, 0xFF), 24);
    local r = bit.lshift(bit.band(r, 0xFF), 16);
    local g = bit.lshift(bit.band(g, 0xFF), 08);
    local b = bit.band(b, 0xFF);
    return bit.bor(bit.bor(a, r), bit.bor(g, b));
end

----------------------------------------------------------------------------------------------------
-- func: math.color_to_argb
-- desc: Converts a color code to its individual a r g b values.
----------------------------------------------------------------------------------------------------
function math.color_to_argb(c)
    local a = bit.rshift(bit.band(c, 0xFF000000), 24);
    local r = bit.rshift(bit.band(c, 0x00FF0000), 16);
    local g = bit.rshift(bit.band(c, 0x0000FF00), 8);
    local b = bit.band(c, 0x000000FF);
    return a, r, g, b;
end

----------------------------------------------------------------------------------------------------
-- func: math.colortable_to_int
-- desc: Converts an imgui color table to a D3DCOLOR value.
----------------------------------------------------------------------------------------------------
function math.colortable_to_int(t)
    local a = t[4];
    local r = t[1] * 255;
    local g = t[2] * 255;
    local b = t[3] * 255;

    if (a == nil) then
        a = 255;
    else
        a = a * 255;
    end

    return math.d3dcolor(a, r, g, b);
end

----------------------------------------------------------------------------------------------------
-- func: math.bin2int
-- desc: Converts a binary number to an integer.
----------------------------------------------------------------------------------------------------
function math.bin2int(b)
    return tonumber(b, 2);
end

----------------------------------------------------------------------------------------------------
-- func: math.int2bin
-- desc: Converts an integer to a binary number.
----------------------------------------------------------------------------------------------------
function math.int2bin(i)
    local s = string.format('%o', i);
    local a = { ["0"] = "000", ["1"] = "001", ["2"] = "010", ["3"] = "011", ["4"] = "100", ["5"] = "101", ["6"] = "110", ["7"] = "111" };
    local b = string.gsub(s, "(.)", function(d) return a[d]; end);
    return b;
end

----------------------------------------------------------------------------------------------------
-- func: math.rngrnd
-- desc: Generates a ranged random number between a min and max point.
----------------------------------------------------------------------------------------------------
function math.rngrnd(l, h)
    return l + (h - l) * math.random();
end
----------------------------------------------------------------------------------------------------
-- func: math.truncate
-- desc: Returns a number towards zero.
----------------------------------------------------------------------------------------------------
function math.truncate(n, dp)
    local m = 10 ^ (dp or 0);
    local f = num < 0 and math.ceil or math.floor;
    return f(n * m) / m;
end