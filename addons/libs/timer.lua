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

hook = hook or { };
hook.timer = hook.timer or { };

-- Timer Status Definition
local TIMER_PAUSED  = 0;
local TIMER_STOPPED = 1;
local TIMER_RUNNING = 2;

-- Timer Table Definitions
hook.timer.timers = { };
hook.timer.timersonce = { };

----------------------------------------------------------------------------------------------------
-- func: create_timer
-- desc: Creates a timer object inside of the timer table.
----------------------------------------------------------------------------------------------------
local function create_timer(name)
    if (hook.timer.timers[name] == nil) then
        hook.timer.timers[name] = { };
        hook.timer.timers[name].Status = TIMER_STOPPED;
        return true;
    end
    return false;
end
hook.timer.create_timer = create_timer;

----------------------------------------------------------------------------------------------------
-- func: remove_timer
-- desc: Removes a timer from the timer table.
----------------------------------------------------------------------------------------------------
local function remove_timer(name)
    hook.timer.timers[name] = nil;
end
hook.timer.remove_timer = remove_timer;

----------------------------------------------------------------------------------------------------
-- func: is_timer
-- desc: Determines if the given name is a valid timer.
----------------------------------------------------------------------------------------------------
local function is_timer(name)
    return hook.timer.timers[name] ~= nil;
end
hook.timer.is_timer = is_timer;

----------------------------------------------------------------------------------------------------
-- func: once
-- desc: Creates a one-time timer that fires after the given delay.
----------------------------------------------------------------------------------------------------
local function once(delay, func, ...)
    local t = { };
    t.Finish = os.time() + delay;
    if (func) then
        t.Function = func;
    end
    t.Args = {...};

    table.insert(hook.timer.timersonce, t);
    return true;
end
hook.timer.once = once;

----------------------------------------------------------------------------------------------------
-- func: create
-- desc: Creates a timer.
----------------------------------------------------------------------------------------------------
local function create(name, delay, reps, func, ...)
    if (hook.timer.is_timer(name)) then
        hook.timer.remove_timer(name);
    end

    hook.timer.adjust_timer(name, delay, reps, func, unpack({...}));
    hook.timer.start_timer(name);
end
hook.timer.create = create;

----------------------------------------------------------------------------------------------------
-- func: start_timer
-- desc: Starts a timer by its name.
----------------------------------------------------------------------------------------------------
local function start_timer(name)
    if (hook.timer.is_timer(name)) then
        hook.timer.timers[name].n        = 0;
        hook.timer.timers[name].Status   = TIMER_RUNNING;
        hook.timer.timers[name].Last     = os.time();
        return true;
    end
    return false;
end
hook.timer.start_timer = start_timer;

----------------------------------------------------------------------------------------------------
-- func: adjust_timer
-- desc: Updates a timer objects properties.
----------------------------------------------------------------------------------------------------
local function adjust_timer(name, delay, reps, func, ...)
    hook.timer.create_timer(name);

    hook.timer.timers[name].Delay    = delay;
    hook.timer.timers[name].Reps     = reps;
    hook.timer.timers[name].Args     = {...};

    if (func ~= nil) then
        hook.timer.timers[name].Function = func;
    end

    return true;
end
hook.timer.adjust_timer = adjust_timer;

----------------------------------------------------------------------------------------------------
-- func: pause
-- desc: Pauses a timer.
----------------------------------------------------------------------------------------------------
local function pause(name)
    if (hook.timer.is_timer(name)) then
        if (hook.timer.timers[name].Status == TIMER_RUNNING) then
            hook.timer.timers[name].Diff     = os.time() - hook.timer.timers[name].Last;
            hook.timer.timers[name].Status   = TIMER_PAUSED;
            return true;
        end
    end
    return false;
end
hook.timer.pause = pause;

----------------------------------------------------------------------------------------------------
-- func: unpause
-- desc: Unpauses a timer.
----------------------------------------------------------------------------------------------------
local function unpause(name)
    if (hook.timer.is_timer(name)) then
        if (hook.timer.timers[name].Status == TIMER_RUNNING) then
            hook.timer.timers[name].Diff     = nil;
            hook.timer.timers[name].Status   = TIMER_RUNNING;
            return true;
        end
    end
    return false;
end
hook.timer.unpause = unpause;

----------------------------------------------------------------------------------------------------
-- func: toggle
-- desc: Toggles a timers paused state.
----------------------------------------------------------------------------------------------------
local function toggle(name)
    if (hook.timer.is_timer(name)) then
        if (hook.timer.timers[name].Status == TIMER_PAUSED) then
            return hook.timer.unpause(name);
        elseif (hook.timer.timers[name].Status == TIMER_RUNNING) then
            return hook.timer.pause(name);
        end
    end
    return false;
end
hook.timer.toggle = toggle;

----------------------------------------------------------------------------------------------------
-- func: stop
-- desc: Stops a timer.
----------------------------------------------------------------------------------------------------
local function stop(name)
    if (hook.timer.is_timer(name)) then
        hook.timer.timers[name].Status = TIMER_STOPPED;
        return true;
    end
    return false;
end
hook.timer.stop = stop;

----------------------------------------------------------------------------------------------------
-- func: pulse
-- desc: Pulses the timer tables to allow timers to run.
----------------------------------------------------------------------------------------------------
local function pulse(name)
    -- Handle the normal timers..
    for k, v in pairs(hook.timer.timers) do
        if (v.Status == TIMER_PAUSED) then
            v.Last = os.time() - v.Diff;
        elseif (v.Status == TIMER_RUNNING and (v.Last + v.Delay) <= os.time()) then
            v.Last = os.time();
            v.n = v.n + 1;

            -- Call the timer function..
            local a, b, c, d, e, f = pcall(v.Function, unpack(v.Args));
            if (a == nil or a == false) then
                print(_addon.name .. ' - timer.lua pcall error: ' .. tostring(b));
            end

            -- Stop the timer after its reps were met..
            if (v.n >= v.Reps and v.Reps > 0) then
                hook.timer.stop(k);
            end
        end
    end

    -- Handle the once timers..
    for k, v in pairs(hook.timer.timersonce) do
        if (v.Finish <= os.time()) then
            local a, b, c, d, e, f = pcall(v.Function, unpack(v.Args));
            if (a == nil or a == false) then
                print(_addon.name .. ' - timer.lua pcall error: ' .. tostring(b));
            end

            -- Remove the timer..
            hook.timer.timersonce[k] = nil;
        end
    end
end
hook.timer.pulse = pulse;
hook.events.register_event('beginscene', '__timerlib_beginscene', pulse);