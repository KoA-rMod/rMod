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

reckoning = reckoning or { };
reckoning.actor = reckoning.actor or { };

----------------------------------------------------------------------------------------------------
-- Pointers and Offsets (Game Version 1.0.0.2)
----------------------------------------------------------------------------------------------------

-- Player Actor Information..
local PLAYER_ACTORS_BASE        = 0x00BF8AF8;
local PLAYER_ACTORS_START       = 0x1238;
local PLAYER_ACTORS_COUNT       = 0x123C;

-- Player Actor Offsets
local ACTOR_UNIQUEID            = 0x01EC;
local ACTOR_FATE                = 0x0204;
local ACTOR_NAME                = 0x0308;
local ACTOR_NAME_LEN            = 0x000C;
local ACTOR_WEALTH              = 0x0364;

-- Actor Lookup Table Offsets
local ACTOR_LOOKUP_BASE         = 0x00BF90EC;
local ACTOR_LOOKUP_START        = 0x21BC;
local ACTOR_LOOKUP_HASSTATS     = 0x0020;
local ACTOR_LOOKUP_X            = 0x0024;
local ACTOR_LOOKUP_Y            = 0x0028;
local ACTOR_LOOKUP_Z            = 0x002C;
local ACTOR_LOOKUP_SPRINTING    = 0x003C; -- Doesn't appear to work..
local ACTOR_LOOKUP_HPCURRENT    = 0x0048;
local ACTOR_LOOKUP_HPMAX        = 0x004C;
local ACTOR_LOOKUP_SPEED        = 0x0060;
local ACTOR_LOOKUP_MPMAX        = 0x0074;
local ACTOR_LOOKUP_MPCURRENT    = 0x0084;
local ACTOR_LOOKUP_MPRESERVED   = 0x0098;
local ACTOR_LOOKUP_LEVEL        = 0x00FC;
local ACTOR_LOOKUP_ACTORTYPE    = 0x0110; -- Used for validation checks..

-- Actor Lookup Table Indices
local LOOKUP_INDEX_HP           = 0x0001;
local LOOKUP_INDEX_SPRINT       = 0x0003;
local LOOKUP_INDEX_POSITION     = 0x0006;
local LOOKUP_INDEX_MP           = 0x0012;
local LOOKUP_INDEX_VARIABLE     = 0x0023;
local LOOKUP_INDEX_SPEED        = 0x002A;

----------------------------------------------------------------------------------------------------
-- Memory Function Helpers
----------------------------------------------------------------------------------------------------
local ru08 = hook.memory.read_uint8;
local ru16 = hook.memory.read_uint16;
local ru32 = hook.memory.read_uint32;
local rflt = hook.memory.read_float;
local rstr = hook.memory.read_string;

----------------------------------------------------------------------------------------------------
-- func: isValid
-- desc: Validates the object is not 0 or nil.
----------------------------------------------------------------------------------------------------
local function isValid(p)
    return (p ~= 0 and p ~= nil);
end

----------------------------------------------------------------------------------------------------
-- func: sub_855710
-- desc: Lookup function to obtain a table pointer of an actor.
-- note:
--      The exact name of this function is unknown and a more specific name is unknown at this
--      time. This function is used when looking up actor information to obtain a pointer to
--      various information tables. 
--
--      a1 - A pointer to the lookup table base where the function will index a pointer from.
--      a2 - The actors unique id to be used in the lookup.
--
--      The function name is currently its address until a more suitable name is determined.
----------------------------------------------------------------------------------------------------
local function sub_855710(a1, a2)
    -- Phase 1 of the unknown lookup..
    if (bit.band(a2, 0xFFF0000) ~= 0) then
        if ((bit.band(a2, 0x0FFFF) < ru32(a1 + 0x20)) and
            (ru32(ru32(a1 + 0x1C) + (bit.band(a2, 0x0FFFF) * 0x04)) == a2)) then
            local v2 = ru32(a1 + 0x0C) + bit.band(a2, 0x0FFFF) * 0x04;
            if (v2 > 0) then
                return ru32(v2);
            end
        end
    end

    -- Phase 2 of the unknown lookup..
    local v3 = ru32(a1 + 0x54);
    if (bit.band(v3, 0xFFF0000) ~= 0) then
        if ((bit.band(v3, 0x0FFFF) < ru32(a1 + 0x20)) and
            (ru32(ru32(a1 + 0x1C) + (bit.band(v3, 0x0FFFF) * 0x04)) == v3)) then
            local v2 = ru32(a1 + 0x0C) + bit.band(v3, 0x0FFFF) * 0x04;
            if (v2 > 0) then
                return ru32(v2);
            end
        end
    end

    -- Unhandled lookup..
    return 0;
end

----------------------------------------------------------------------------------------------------
-- func: sub_4010E0
-- desc: Lookup function to obtain a table pointer of an actor.
-- note:
--      The exact name of this function is unknown and a more specific name is unknown at this
--      time. This function is used when looking up actor information to obtain a pointer to
--      various information tables. 
--
--      a1 - The table index to use for the lookup.
--      a2 - The actors unique id to be used in the lookup.
--
--      The function name is currently its address until a more suitable name is determined.
----------------------------------------------------------------------------------------------------
local function sub_4010E0(a1, a2)
    local ret = 0;

    -- Read the lookup base pointer..
    local v1 = ru32(ACTOR_LOOKUP_BASE);
    local v2 = v1 + ACTOR_LOOKUP_START;

    -- Obtain the actors lookup table..
    local v3 = sub_855710(v2, a2);

    -- Validate the actor..
    local flag = bit.band(ru08(v3 + ACTOR_LOOKUP_ACTORTYPE), 1);
    if (flag == 1) then
        ret = ru32(v3 + a1 * 0x04 + 0x40);
    end
    if (flag == 0 or res == 0) then
        ret = ru32(ru32(v1 + a1 * 0x04 + 0xBC0) + 0x04);
        ret = ru32(ret);
    end

    return ret;
end

----------------------------------------------------------------------------------------------------
-- func: get_player_actor
-- desc: Gets the player actor at the given index.
----------------------------------------------------------------------------------------------------
local function get_player_actor(n)
    -- Read the player actor count..
    local v1 = ru32(ru32(PLAYER_ACTORS_BASE) + PLAYER_ACTORS_COUNT);
    local v2 = 0;

    -- Ensure there are player actors..
    if (v1 <= 0) then return 0; end

    -- Read the player actor start..
    local v3 = ru32(ru32(PLAYER_ACTORS_BASE) + PLAYER_ACTORS_START);
    if (v3 <= 0) then return 0; end

    -- Walk and read each player object..
    while (ru32(ru32(v3) + 0x00FC) ~= n) do
        -- Step to the next actor..
        v2 = v2 + 1;
        v3 = v3 + 4;

        -- Don't exceed the actor count..
        if (v2 >= v1) then
            return 0;
        end
    end

    -- Read and return the actor pointer..
    return ru32(ru32(ru32(PLAYER_ACTORS_BASE) + PLAYER_ACTORS_START) + (0x04 * v2));
end
reckoning.actor.get_player_actor = get_player_actor;

----------------------------------------------------------------------------------------------------
-- func: get_local_player_actor
-- desc: Gets the local player actor.
----------------------------------------------------------------------------------------------------
local function get_local_player_actor()
    -- Local player is always referenced at index 0..
    return get_player_actor(0);
end
reckoning.actor.get_local_player_actor = get_local_player_actor;

----------------------------------------------------------------------------------------------------
-- func: is_actor_valid
-- desc: Tests and returns if an actor is valid.
----------------------------------------------------------------------------------------------------
local function is_actor_valid(a)
    -- Ensure the actor is valid..
    if (not isValid(a)) then return 0; end

    -- Obtain the actors unique player id..
    local v1 = ru32(a + ACTOR_UNIQUEID);
    if (v1 == 0) then return 0; end
    
    -- Read the lookup base pointer..
    local v2 = ru32(ACTOR_LOOKUP_BASE);
    local v3 = v2 + ACTOR_LOOKUP_START;

    -- Obtain the actors lookup table..
    local v4 = sub_855710(v3, v1);
    if (v4 == 0) then return 0; end

    -- Return if the actor is valid..
    local v5 = ru08(v4 + ACTOR_LOOKUP_ACTORTYPE);
    return bit.band(v5, 1);
end
reckoning.actor.is_valid = is_actor_valid;

----------------------------------------------------------------------------------------------------
-- func: is_actor_player
-- desc: Tests and returns if an actor is a player.
----------------------------------------------------------------------------------------------------
local function is_actor_player(a)
    -- Ensure the actor is valid..
    if (not isValid(a)) then return 0; end

    -- Obtain the actors unique player id..
    local v1 = ru32(a + ACTOR_UNIQUEID);
    if (v1 == 0) then return 0; end
    
    -- Read the lookup base pointer..
    local v2 = ru32(ACTOR_LOOKUP_BASE);
    local v3 = v2 + ACTOR_LOOKUP_START;

    -- Obtain the actors lookup table..
    local v4 = sub_855710(v3, v1);
    if (v4 == 0) then return 0; end

    -- Return if the actor is a player..
    local v5 = ru08(v4 + ACTOR_LOOKUP_ACTORTYPE);
    return bit.band(bit.rshift(v5, 1), 1);
end
reckoning.actor.is_player = is_actor_player;

----------------------------------------------------------------------------------------------------
-- func: is_actor_dead
-- desc: Tests and returns if the actor is dead.
----------------------------------------------------------------------------------------------------
local function is_actor_dead(a)
    -- Ensure the actor is valid..
    if (not isValid(a)) then return false; end

    -- Obtain the actors unique player id..
    local v1 = ru32(a + ACTOR_UNIQUEID);
    if (v1 == 0) then return false; end

    -- Obtain the actors lookup table..
    local v2 = sub_4010E0(LOOKUP_INDEX_HP, v1);
    if (not isValid(v2)) then return false; end

    -- Validate the table has stats..
    local v3 = ru08(v2 + ACTOR_LOOKUP_HASSTATS);
    if (bit.band(v3) ~= 0) then
        -- Return if the player is dead or not..
        local c = ru32(v2 + ACTOR_LOOKUP_HPCURRENT);
        return c <= 0;
    end

    return true;
end
reckoning.actor.is_dead = is_actor_dead;

----------------------------------------------------------------------------------------------------
-- func: get_actor_name
-- desc: Obtains the actors name.
----------------------------------------------------------------------------------------------------
local function get_actor_name(a)
    -- Ensure the actor is valid..
    if (not isValid(a)) then
        return '';
    end

    -- Read the name length and pointer..
    local l = ru16(a + ACTOR_NAME + ACTOR_NAME_LEN);
    local p = ru32(a + ACTOR_NAME);
    if (not isValid(l) or not isValid(p)) then
        return '';
    end

    -- Ensure the name pointer is valid..
    p = ru32(p);
    if (not isValid(p)) then
        return '';
    end

    -- Read and return the actor name..
    return rstr(p, l);
end
reckoning.actor.get_name = get_actor_name;

----------------------------------------------------------------------------------------------------
-- func: get_actor_hp
-- desc: Obtains the actors current and max health.
-- note:
--      Returns two values, current and max health respectively.
----------------------------------------------------------------------------------------------------
local function get_actor_hp(a)
    -- Ensure the actor is valid..
    if (not isValid(a)) then return 0, 0; end

    -- Obtain the actors unique player id..
    local v1 = ru32(a + ACTOR_UNIQUEID);
    if (v1 == 0) then return 0, 0; end

    -- Obtain the actors lookup table..
    local v2 = sub_4010E0(LOOKUP_INDEX_HP, v1);
    if (not isValid(v2)) then return 0, 0; end

    -- Validate the table has stats..
    local v3 = ru08(v2 + ACTOR_LOOKUP_HASSTATS);
    if (bit.band(v3) ~= 0) then
        local c = ru32(v2 + ACTOR_LOOKUP_HPCURRENT);
        local m = ru32(v2 + ACTOR_LOOKUP_HPMAX);
        return c, m;
    end

    return 0, 0;
end
reckoning.actor.get_hp = get_actor_hp;

----------------------------------------------------------------------------------------------------
-- func: get_actor_mp
-- desc: Obtains the actors current and max mana.
-- note:
--      Returns two values, current and max mana respectively.
----------------------------------------------------------------------------------------------------
local function get_actor_mp(a)
    -- Ensure the actor is valid..
    if (not isValid(a)) then return 0, 0; end

    -- Obtain the actors unique player id..
    local v1 = ru32(a + ACTOR_UNIQUEID);
    if (v1 == 0) then return 0, 0; end

    -- Obtain the actors lookup table..
    local v2 = sub_4010E0(LOOKUP_INDEX_MP, v1);
    if (not isValid(v2)) then return 0, 0; end

    -- Validate the table has stats..
    local v3 = ru08(v2 + ACTOR_LOOKUP_HASSTATS);
    if (bit.band(v3) ~= 0) then
        local c = ru32(v2 + ACTOR_LOOKUP_MPCURRENT);
        local m = ru32(v2 + ACTOR_LOOKUP_MPMAX);
        return c, m;
    end

    return 0, 0;
end
reckoning.actor.get_mp = get_actor_mp;

----------------------------------------------------------------------------------------------------
-- func: get_actor_mp_reserved
-- desc: Obtains the actors reserved mana.
----------------------------------------------------------------------------------------------------
local function get_actor_mp_reserved(a)
    -- Ensure the actor is valid..
    if (not isValid(a)) then return 0; end

    -- Obtain the actors unique player id..
    local v1 = ru32(a + ACTOR_UNIQUEID);
    if (v1 == 0) then return 0; end

    -- Obtain the actors lookup table..
    local v2 = sub_4010E0(LOOKUP_INDEX_MP, v1);
    if (not isValid(v2)) then return 0; end

    -- Validate the table has stats..
    local v3 = ru08(v2 + ACTOR_LOOKUP_HASSTATS);
    if (bit.band(v3) ~= 0) then
        local rmp = rflt(v2 + ACTOR_LOOKUP_MPRESERVED);
        if (rmp > 0) then
            return math.floor(rmp * ru32(v2 + ACTOR_LOOKUP_MPMAX));
        end
    end

    return 0;
end
reckoning.actor.get_mp_reserved = get_actor_mp_reserved;

----------------------------------------------------------------------------------------------------
-- func: get_actor_fate
-- desc: Obtains the actors current fate.
----------------------------------------------------------------------------------------------------
local function get_actor_fate(a)
    -- Ensure the actor is valid..
    if (not isValid(a)) then return 0, 0; end

    -- Return the actors wealth..
    local fatec = ru32(a + ACTOR_FATE);
    local fatem = 264;

    -- Max fate is hard coded in a global combat stat table:
    -- _G['COMBAT/FATE'].max_fate = 264;
    
    return fatec, fatem;
end
reckoning.actor.get_fate = get_actor_fate;

----------------------------------------------------------------------------------------------------
-- func: get_actor_level
-- desc: Obtains the actors level.
----------------------------------------------------------------------------------------------------
local function get_actor_level(a)
    -- Ensure the actor is valid..
    if (not isValid(a)) then return 0; end

    -- Obtain the actors unique player id..
    local v1 = ru32(a + ACTOR_UNIQUEID);
    if (v1 == 0) then return 0; end
    
    -- Read the lookup base pointer..
    local v2 = ru32(ACTOR_LOOKUP_BASE);
    local v3 = v2 + ACTOR_LOOKUP_START;

    -- Obtain the actors lookup table..
    local v4 = sub_855710(v3, v1);
    if (v4 == 0) then return 0; end

    -- Return the actors level..
    local v5 = ru08(v4 + ACTOR_LOOKUP_ACTORTYPE);
    if (bit.band(v5, 1) ~= 0) then
        return ru32(v4 + 0xFC);
    end
    
    return 0;
end
reckoning.actor.get_level = get_actor_level;

----------------------------------------------------------------------------------------------------
-- func: get_actor_x_location
-- desc: Obtains the actors x coord location.
----------------------------------------------------------------------------------------------------
local function get_actor_x_location(a)
    -- Ensure the actor is valid..
    if (not isValid(a)) then return 0; end

    -- Obtain the actors unique player id..
    local v1 = ru32(a + ACTOR_UNIQUEID);
    if (v1 == 0) then return 0; end

    -- Obtain the actors lookup table..
    local v2 = sub_4010E0(LOOKUP_INDEX_POSITION, v1);
    if (not isValid(v2)) then return 0; end

    -- Validate the table has stats..
    local v3 = ru08(v2 + ACTOR_LOOKUP_HASSTATS);
    if (bit.band(v3) ~= 0) then
        return rflt(v2 + ACTOR_LOOKUP_X);
    end

    return 0;
end
reckoning.actor.get_x_location = get_actor_x_location;

----------------------------------------------------------------------------------------------------
-- func: get_actor_y_location
-- desc: Obtains the actors y coord location.
----------------------------------------------------------------------------------------------------
local function get_actor_y_location(a)
    -- Ensure the actor is valid..
    if (not isValid(a)) then return 0; end

    -- Obtain the actors unique player id..
    local v1 = ru32(a + ACTOR_UNIQUEID);
    if (v1 == 0) then return 0; end

    -- Obtain the actors lookup table..
    local v2 = sub_4010E0(LOOKUP_INDEX_POSITION, v1);
    if (not isValid(v2)) then return 0; end

    -- Validate the table has stats..
    local v3 = ru08(v2 + ACTOR_LOOKUP_HASSTATS);
    if (bit.band(v3) ~= 0) then
        return rflt(v2 + ACTOR_LOOKUP_Y);
    end

    return 0;
end
reckoning.actor.get_y_location = get_actor_y_location;

----------------------------------------------------------------------------------------------------
-- func: get_actor_z_location
-- desc: Obtains the actors z coord location.
----------------------------------------------------------------------------------------------------
local function get_actor_z_location(a)
    -- Ensure the actor is valid..
    if (not isValid(a)) then return 0; end

    -- Obtain the actors unique player id..
    local v1 = ru32(a + ACTOR_UNIQUEID);
    if (v1 == 0) then return 0; end

    -- Obtain the actors lookup table..
    local v2 = sub_4010E0(LOOKUP_INDEX_POSITION, v1);
    if (not isValid(v2)) then return 0; end

    -- Validate the table has stats..
    local v3 = ru08(v2 + ACTOR_LOOKUP_HASSTATS);
    if (bit.band(v3) ~= 0) then
        return rflt(v2 + ACTOR_LOOKUP_Z);
    end

    return 0;
end
reckoning.actor.get_z_location = get_actor_z_location;

----------------------------------------------------------------------------------------------------
-- func: get_actor_speed
-- desc: Obtains the actors speed. (While moving.)
----------------------------------------------------------------------------------------------------
local function get_actor_speed(a)
    -- Ensure the actor is valid..
    if (not isValid(a)) then return 0; end

    -- Obtain the actors unique player id..
    local v1 = ru32(a + ACTOR_UNIQUEID);
    if (v1 == 0) then return 0; end

    -- Obtain the actors lookup table..
    local v2 = sub_4010E0(LOOKUP_INDEX_SPEED, v1);
    if (not isValid(v2)) then return 0; end

    -- Validate the table has stats..
    local v3 = ru08(v2 + ACTOR_LOOKUP_HASSTATS);
    if (bit.band(v3) ~= 0) then
        return rflt(v2 + ACTOR_LOOKUP_SPEED);
    end

    return 0;
end
reckoning.actor.get_speed = get_actor_speed;

----------------------------------------------------------------------------------------------------
-- func: get_actor_wealth
-- desc: Obtains the actors gold amount.
----------------------------------------------------------------------------------------------------
local function get_actor_wealth(a)
    -- Ensure the actor is valid..
    if (not isValid(a)) then return 0; end

    -- Return the actors wealth..
    return ru32(a + ACTOR_WEALTH);
end
reckoning.actor.get_wealth = get_actor_wealth;

----------------------------------------------------------------------------------------------------
-- func: get_variable
-- desc: Obtains a variable value for the actor by its name hash.
-- note:
--      Returns a table of information as the exact handling of everything this function can do
--      is not entirely known at this time. The returned table contains the following information:
--
--      .index  - The index of the found variable entry.
--      .base   - The base lookup table holding the variable entry.
--      .type   - The variables type. (Note: Does not align to Lua type ids!)
--      .addr   - The address where the found variable entry is held.
--      .value  - The value table holding any known results.
--
--      The .value member of this return holds any known returns based on the games usage of the
--      values. In most cases, there will be at least 1 value in this table. In some cases there
--      may only be one or none.
----------------------------------------------------------------------------------------------------
local function get_variable(a1, a2)
    local v3 = a1; -- entry owner ptr
    local v4 = ru32(a1 + 0x04); -- entry count
    local v5 = 0;

    if (v4 <= 0)
    then
        return nil;
    end
    
    local v6 = a2; -- hash
    local v7 = ru32(a1); -- entry start ptr

    while (ru32(v7) ~= v6) do
        v5 = v5 + 1;
        v7 = v7 + 4;

        if (v5 >= v4) then
            return nil;
        end
    end

    if (v5 < 0) then
        return nil;
    end

    local v9 = 0x05 * v5;
    local v10 = ru32(v3 + 0x10);
    local v11 = ru32(v10 + 0x08 * v9 + 0x20);
    local v12 = v10 + 0x08 * v9;

    ------------------------------------------------------------------------------------------------
    -- Build a result table..
    --
    -- Because these variables are handled in a strange, misaligned manner to Lua's normal
    -- types, it is unknown, yet, what each of the types mean. Instead of straight returning
    -- the value, instead a table of information is returned to allow users to convert the
    -- value themselves as needed.
    ------------------------------------------------------------------------------------------------

    local r = { };
    r.index = v9;   -- The index of the found entry..
    r.base  = v10;  -- The base lookup table pointer holding the entry.
    r.type  = v11;  -- The variable type. (Note: Does not align to Lua types!)
    r.addr  = v12;  -- The address where the result value is held.
    r.value = { };  -- The value table holding any known results..

    ------------------------------------------------------------------------------------------------
    -- Best-Guess handling of certain types..
    ------------------------------------------------------------------------------------------------
    
    -- TSTRING
    if (v11 == 0x00) then
        -- Unknown at this time..
        return r;
    end

    -- TNUMBER
    if (v11 == 0x06) then
        r.value[1] = ru32(v12 + 0x18);
        return r;
    end

    -- TBOOLEAN
    if (v11 == 0x07) then
        r.value[1] = ru08(v12 + 0x18);
        return r;
    end

    -- TUINT64
    if (v11 == 0x0B) then
        -- Todo: Handle this type, the game checks its data for a mask to
        --       determine the type store.
        return r;
    end

    -- TUNKNOWN (Not sure but get_variable uses this and reads the value as 32bit)..
    if (v11 == 0x0D) then
        r.value[1] = ru32(v12 + 0x18);
        return r;
    end

    -- TSTRING
    if (v11 == 0x0E) then
        -- Unknown at this time..
        return r;
    end

    -- Default handler.. get_variable uses 2 pair returns..
    if (v11) then
        r.value[1] = ru32(v12 + 0x18);
        r.value[2] = ru32(v12 + 0x1C);
        return r;
    end

    return r;
end

----------------------------------------------------------------------------------------------------
-- func: get_actor_variable
-- desc: Obtains a variable value for the actor by its name hash.
----------------------------------------------------------------------------------------------------
local function get_actor_variable(a, hash)
    -- Ensure the actor is valid..
    if (not isValid(a)) then return nil; end
    if (is_actor_valid(a) == 0) then return nil; end

    -- Obtain the actors unique player id..
    local v1 = ru32(a + ACTOR_UNIQUEID);
    if (v1 == 0) then return nil; end

    -- Obtain the actors lookup table..
    local v2 = sub_4010E0(LOOKUP_INDEX_VARIABLE, v1);
    if (not isValid(v2)) then return nil; end

    -- Validate the table has stats..
    local v3 = ru08(v2 + ACTOR_LOOKUP_HASSTATS);
    if (bit.band(v3) == 0) then
        return nil;
    end
    
    return get_variable(v2 + 0x30, hash);
end
reckoning.actor.get_variable = get_actor_variable;