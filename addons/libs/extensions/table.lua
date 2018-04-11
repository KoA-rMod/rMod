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
-- func: table.copy
-- desc: Creates a new copy of the given table.
----------------------------------------------------------------------------------------------------
function table.copy(t)
    -- Ensure the incoming object is a table..
    if (type(t) ~= 'table') then
        return 't';
    end

    local t_mt = getmetatable(t);
    local copy = { };

    -- Make a copy of all inner-tables..
    for k, v in pairs(t) do
        if (type(v) == 'table') then
            v = table.copy(v);
        end
        copy[k] = v;
    end

    -- Update the metatable..
    setmetatable(copy, t_mt);
    return copy;
end

----------------------------------------------------------------------------------------------------
-- func: table.count
-- desc: Returns the count of elements in the table.
----------------------------------------------------------------------------------------------------
function table.count(t)
    local count = 0;
    for _, _ in pairs(t) do
        count = count + 1;
    end
    return count;
end

----------------------------------------------------------------------------------------------------
-- func: table.haskey
-- desc: Determines if the table has a given key.
----------------------------------------------------------------------------------------------------
function table.haskey(t, key)
    for k, _ in pairs(t) do
        if (k == key) then
            return true;
        end
    end
    return false;
end

----------------------------------------------------------------------------------------------------
-- func: table.hasvalue
-- desc: Determines if the table has the given value.
----------------------------------------------------------------------------------------------------
function table.hasvalue(t, val)
    for _, v in pairs(t) do
        if (v == val) then
            return true;
        end
    end
    return false;
end

----------------------------------------------------------------------------------------------------
-- func: table.merge
-- desc: Merges a table into another one, populating missing entries.
----------------------------------------------------------------------------------------------------
function table.merge(src, dest)
    for k, v in pairs(src) do
        if (type(v) == 'table') then
            if (dest[k] == nil) then
                dest[k] = v;
            else
                table.merge(v, dest[k]);
            end
        else
            if (dest[k] == nil) then
                dest[k] = v;
            end
        end
    end
    return dest;
end

----------------------------------------------------------------------------------------------------
-- func: table.null
-- desc: Nils all values of the given table.
----------------------------------------------------------------------------------------------------
function table.null(t)
    for k, _ in pairs(t) do
        t[k] = nil;
    end
end

----------------------------------------------------------------------------------------------------
-- func: table.reverse
-- desc: Reverses the order of elements in a table.
----------------------------------------------------------------------------------------------------
function table.reverse(t)
    local len = #t;
    local ret = { };

    for x = len, 1, -1 do
        ret[len - x + 1] = t[x];
    end

    return ret;
end

----------------------------------------------------------------------------------------------------
-- func: table.sortbykey
-- desc: Sorts the given table by its keys.
----------------------------------------------------------------------------------------------------
function table.sortbykey(t, desc)
    local ret = { };

    for k, _ in pairs(t) do
        table.insert(ret, k);
    end

    if (desc) then
        table.sort(ret, function(a, b) return t[a] < t[b]; end);
    else
        table.sort(ret, function(a, b) return t[a] > t[b]; end);
    end

    return ret;
end

----------------------------------------------------------------------------------------------------
-- func: table.sum
-- desc: Gets the sum of all number elements of a table.
----------------------------------------------------------------------------------------------------
function table.sum(t)
    local val = 0;
    for _, v in ipairs(t) do
        if (type(v) == 'number') then
            val = val + v;
        end
    end
    return val;
end

----------------------------------------------------------------------------------------------------
-- func: table.mult
-- desc: Gets the product of all number elements of a table.
----------------------------------------------------------------------------------------------------
function table.mult(t)
    local val = 0;
    for _, v in ipairs(t) do
        if (type(v) == 'number') then
            val = val * v;
        end
    end
    return val;
end

----------------------------------------------------------------------------------------------------
-- func: table.min
-- desc: Returns the lowest numeric value within a table.
----------------------------------------------------------------------------------------------------
function table.min(t)
    local val = nil;
    for _, v in ipairs(t) do
        if (type(v) == 'number') then
            if (val == nil) then
                val = v;
            else
                if (v < val) then
                    val = v;
                end
            end
        end
    end
    return val;
end

----------------------------------------------------------------------------------------------------
-- func: table.max
-- desc: Returns the highest numeric value within a table.
----------------------------------------------------------------------------------------------------
function table.max(t)
    local val = nil;
    for _, v in ipairs(t) do
        if (type(v) == 'number') then
            if (val == nil) then
                val = v;
            else
                if (v > val) then
                    val = v;
                end
            end
        end
    end
    return val;
end

----------------------------------------------------------------------------------------------------
-- func: table.join
-- desc: Joins a tables values together into a string with the given separator.
----------------------------------------------------------------------------------------------------
function table.join(t, sep)
    local ret = '';
    sep = sep or '';
    for k, v in pairs(t) do
        if (#ret == 0) then
            ret = tostring(v);
        else
            ret = ret .. sep .. tostring(v);
        end
    end
    return ret;
end

----------------------------------------------------------------------------------------------------
-- func: table.foreach
-- desc: Executes the given function against each table value.
----------------------------------------------------------------------------------------------------
function table.foreach(t, func)
    local ret = T{ };
    for k, v in pairs(t) do
        ret[k] = func(k, v);
    end
    return ret;
end

----------------------------------------------------------------------------------------------------
-- func: table.keys
-- desc: Returns a table of keys from the given table.
----------------------------------------------------------------------------------------------------
function table.keys(t)
    local ret = { };
    local count = 1;
    for k, _ in pairs(t) do
        ret[count] = k;
        count = count + 1;
    end
    return ret;
end

----------------------------------------------------------------------------------------------------
-- func: T
-- desc: Creates a metatable enabled table object.
----------------------------------------------------------------------------------------------------
function T(t)
    return setmetatable(t, { __index = table });
end