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
hook.events = hook.events or { };
hook.events.__registered = hook.events.__registered or { };

----------------------------------------------------------------------------------------------------
-- Known Hook Event Handlers
--
--      These handlers are made for the known hook events that will fire for addons
--      during their lifespan. Do not edit these as it can cause the hook to crash
--      if unknown or unexpected results happen in each handler. Some events expect
--      return values while others do not. These must be honored for things to work
--      correctly!
--
--  Known Events List:
--      load        - Called when an addon is first loaded.
--      unload      - Called when an addon is unloaded.
--      command     - Called when a console command is being handled, giving addons a chance to handle them.
--      key         - Called when a keyboard button is pressed and released.
--      mouse       - Called when a mouse event is fired. (Movement, clicks, etc.)
--      prereset    - Called when the Direct3D device is reset. (pre)
--      postreset   - Called when the Direct3D device is reset. (post)
--      beginscene  - Called when the Direct3D device begins a scene. (IDirect3DDevice9::BeginScene)
--      endscene    - Called when the Direct3D device ends a scene. (IDirect3DDevice9::EndScene)
--      prepresent  - Called when the Direct3D device presents a scene. (pre)
--      postpresent - Called when the Direct3D device presents a scene. (post)
----------------------------------------------------------------------------------------------------
local hook_events = 
{
    ------------------------------------------------------------------------------------------------
    -- event: load
    -- desc : Invoked when an addon is first loaded.
    -- ret  : (No returns.)
    ------------------------------------------------------------------------------------------------
    ['load'] = {
        name = 'load',
        default = nil,
        handler = function(self, callbacks, ...)
            -- Loop and invoke each callback..
            for k, v in ipairs(callbacks) do
                try(function()
                    v.c();
                end).catch(function(e) 
                    print(string.format('Event callback error was caught. (%s:%s) Error: %s', self.name, k, e));
                end);
            end
        end
    },
    ------------------------------------------------------------------------------------------------
    -- event: unload
    -- desc : Invoked when an addon is unloaded.
    -- ret  : (No returns.)
    ------------------------------------------------------------------------------------------------
    ['unload'] = {
        name = 'unload',
        default = nil,
        handler = function(self, callbacks, ...)
            -- Loop and invoke each callback..
            for k, v in ipairs(callbacks) do
                try(function()
                    v.c();
                end).catch(function(e) 
                    print(string.format('Event callback error was caught. (%s:%s) Error: %s', self.name, k, e));
                end);
            end
        end
    },
    ------------------------------------------------------------------------------------------------
    -- event: command
    -- desc : Invoked when a console command is being processed.
    -- ret  : (boolean) true if handled, false otherwise.
    ------------------------------------------------------------------------------------------------
    ['command'] = {
        name = 'command',
        default = false,
        handler = function(self, callbacks, ...)
            -- Prepare the arguments..
            local args = unpack({...});

            -- Loop and invoke each callback..
            for k, v in ipairs(callbacks) do
                local handled = false;
                try(function()
                    if (v.c(args)) then
                        handled = true;
                    end
                end).catch(function(e) 
                    print(string.format('Event callback error was caught. (%s:%s) Error: %s', self.name, k, e));
                    handled = false;
                end);

                -- Return if the command was handled..
                if (handled) then return handled; end
            end
            return false;
        end
    },
    ------------------------------------------------------------------------------------------------
    -- event: key
    -- desc : Invoked when any keyboard input is handled.
    -- ret  : (boolean) true if handled, false otherwise.
    ------------------------------------------------------------------------------------------------
    ['key'] = {
        name = 'key',
        default = false,
        handler = function(self, callbacks, ...)
            -- Prepare the arguments..
            local args = {...};
            local blocked = self.default;

            -- Default the blocked argument if its not valid..
            if (type(args[3]) ~= 'boolean') then
                args[3] = blocked;
            end

            -- Loop and invoke each callback..
            for k, v in ipairs(callbacks) do
                try(function()
                    local handled = v.c(unpack(args));
                    if (handled) then
                        blocked = true;
                        args[3] = true;
                    end
                end).catch(function(e)
                    print(string.format('Event callback error was caught. (%s:%s) Error: %s', self.name, k, e));
                end);
            end
            return blocked;
        end
    },
    ------------------------------------------------------------------------------------------------
    -- event: mouse
    -- desc : Invoked when any mouse input is handled.
    -- ret  : (boolean) true if handled, false otherwise.
    ------------------------------------------------------------------------------------------------
    ['mouse'] = {
        name = 'mouse',
        default = false,
        handler = function(self, callbacks, ...)
            -- Prepare the arguments..
            local args = {...};
            local blocked = self.default;

            -- Default the blocked argument if its not valid..
            if (type(args[5]) ~= 'boolean') then
                args[5] = blocked;
            end

            -- Loop and invoke each callback..
            for k, v in ipairs(callbacks) do
                try(function()
                    local handled = v.c(unpack(args));
                    if (handled) then
                        blocked = true;
                        args[5] = true;
                    end
                end).catch(function(e)
                    print(string.format('Event callback error was caught. (%s:%s) Error: %s', self.name, k, e));
                end);
            end
            return blocked;
        end
    },
    ------------------------------------------------------------------------------------------------
    -- event: prereset
    -- desc : Invoked when the Direct3D device is being reset. (pre)
    -- ret  : (No returns.)
    ------------------------------------------------------------------------------------------------
    ['prereset'] = {
        name = 'prereset',
        default = nil,
        handler = function(self, callbacks, ...)
            -- Loop and invoke each callback..
            for k, v in ipairs(callbacks) do
                try(function()
                    v.c();
                end).catch(function(e) 
                    print(string.format('Event callback error was caught. (%s:%s) Error: %s', self.name, k, e));
                end);
            end
        end
    },
    ------------------------------------------------------------------------------------------------
    -- event: postreset
    -- desc : Invoked when the Direct3D device is being reset. (post)
    -- ret  : (No returns.)
    ------------------------------------------------------------------------------------------------
    ['postreset'] = {
        name = 'postreset',
        default = nil,
        handler = function(self, callbacks, ...)
            -- Loop and invoke each callback..
            for k, v in ipairs(callbacks) do
                try(function()
                    v.c();
                end).catch(function(e) 
                    print(string.format('Event callback error was caught. (%s:%s) Error: %s', self.name, k, e));
                end);
            end
        end
    },
    ------------------------------------------------------------------------------------------------
    -- event: beginscene
    -- desc : Invoked when a Direct3D scene is beginning.
    -- ret  : (No returns.)
    ------------------------------------------------------------------------------------------------
    ['beginscene'] = {
        name = 'beginscene',
        default = nil,
        handler = function(self, callbacks, ...)
            -- Loop and invoke each callback..
            for k, v in ipairs(callbacks) do
                try(function()
                    v.c();
                end).catch(function(e) 
                    print(string.format('Event callback error was caught. (%s:%s) Error: %s', self.name, k, e));
                end);
            end
        end
    },
    ------------------------------------------------------------------------------------------------
    -- event: endscene
    -- desc : Invoked when a Direct3D scene is ending.
    -- ret  : (No returns.)
    ------------------------------------------------------------------------------------------------
    ['endscene'] = {
        name = 'endscene',
        default = nil,
        handler = function(self, callbacks, ...)
            -- Loop and invoke each callback..
            for k, v in ipairs(callbacks) do
                try(function()
                    v.c();
                end).catch(function(e) 
                    print(string.format('Event callback error was caught. (%s:%s) Error: %s', self.name, k, e));
                end);
            end
        end
    },
    ------------------------------------------------------------------------------------------------
    -- event: prepresent
    -- desc : Invoked when a Direct3D scene is being presented. (pre)
    -- ret  : (No returns.)
    ------------------------------------------------------------------------------------------------
    ['prepresent'] = {
        name = 'prepresent',
        default = nil,
        handler = function(self, callbacks, ...)
            -- Loop and invoke each callback..
            for k, v in ipairs(callbacks) do
                try(function()
                    v.c();
                end).catch(function(e) 
                    print(string.format('Event callback error was caught. (%s:%s) Error: %s', self.name, k, e));
                end);
            end
        end
    },
    ------------------------------------------------------------------------------------------------
    -- event: postpresent
    -- desc : Invoked when a Direct3D scene is being presented. (post)
    -- ret  : (No returns.)
    ------------------------------------------------------------------------------------------------
    ['postpresent'] = {
        name = 'postpresent',
        default = nil,
        handler = function(self, callbacks, ...)
            -- Loop and invoke each callback..
            for k, v in ipairs(callbacks) do
                try(function()
                    v.c();
                end).catch(function(e) 
                    print(string.format('Event callback error was caught. (%s:%s) Error: %s', self.name, k, e));
                end);
            end
        end
    },
};

----------------------------------------------------------------------------------------------------
-- func: find_event
-- desc: Finds an event inside of the given event table by its alias.
----------------------------------------------------------------------------------------------------
local function find_event(name, alias)
    -- Find the given events table..
    local events = hook.events.__registered[name];
    if (events == nil) then
        return nil;
    end
    
    -- Find the entry with the given alias..
    for k, v in pairs(events) do
        if (v.a == alias:lower()) then
            return k;
        end
    end
    return nil;
end

----------------------------------------------------------------------------------------------------
-- func: register_event
-- desc: Registers an event callback to the internal callback tables.
----------------------------------------------------------------------------------------------------
local function register_event(name, alias, callback)
    -- Validate the arguments..
    if (name == nil or type(name) ~= 'string' or string.len(name) == 0) then return; end
    if (alias == nil or type(alias) ~= 'string' or string.len(alias) == 0) then return; end
    if (callback == nil or type(callback) ~= 'function') then return; end
    
    -- Convert the name and alias to lowercase..
    name = name:lower();
    alias = alias:lower();

    -- Check if an event table exists for the given event name..
    if (hook.events.__registered[name] == nil) then
        hook.events.__registered[name] = { };
    end
    
    -- Check if the current alias is already in use..
    local index = find_event(name, alias);
    if (index ~= nil) then
        -- Update existing..
        hook.events.__registered[name][index].n = name;
        hook.events.__registered[name][index].a = alias;
        hook.events.__registered[name][index].c = callback;
    else
        -- Insert new..
        local count = #hook.events.__registered[name];
        table.insert(hook.events.__registered[name], count + 1, {
            ['n'] = name,
            ['a'] = alias,
            ['c'] = callback
        });
    end
end

----------------------------------------------------------------------------------------------------
-- func: unregister_event
-- desc: Unregisters an event callback.
----------------------------------------------------------------------------------------------------
local function unregister_event(name, alias)
    -- Validate the arguments..
    if (name == nil or type(name) ~= 'string' or string.len(name) == 0) then return; end
    if (alias == nil or type(alias) ~= 'string' or string.len(alias) == 0) then return; end
    
    -- Convert the name and alias to lowercase..
    name = name:lower();
    alias = alias:lower();

    -- Ensure the callback table exists..
    if (hook.events.__registered[name] == nil) then return; end
    
    -- Find the entry..
    local index = find_event(name, alias);
    if (index == nil) then return; end

    -- Remove the old entry..
    table.remove(hook.events.__registered[name], index);
end

----------------------------------------------------------------------------------------------------
-- func: call_event
-- desc: Invokes an event, calling all registered callbacks.
-- note:
--
--      Events are invoked internally from the addons plugin. This shouldn't be called directly
--      from within Lua. (You can invoke it if needed, but it is not recommended.)
--
--      Events are predefined in the hook_events table and have specific default return values
--      that are expected to be returned back to the addons plugin. Failure to properly handle
--      the returns back to the plugin can lead to stack corruption or causing the addons plugin
--      to full-on crash. Leave the event calling to the plugin itself unless absolutely needed
--      and you understand what you are doing!
----------------------------------------------------------------------------------------------------
local function call_event(name, ...)
    -- Validate the arguments..
    if (name == nil or type(name) ~= 'string' or string.len(name) == 0) then return; end

    -- Find the events entry within the hook_events table..
    local event = hook_events[name:lower()];
    if (event == nil or type(event) ~= 'table') then
        return;
    end

    -- Find the registered callbacks for the event within the hook.events.__registered table..
    local callbacks = hook.events.__registered[name:lower()];
    if (callbacks == nil or type(callbacks) ~= 'table') then
        -- Not found, return the default value..
        if (event.default ~= nil) then
            return event.default;
        end
        return;
    end

    -- Invoke the callbacks..
    if (event.default ~= nil) then
        return event.handler(event, callbacks, ...);
    else
        event.handler(event, callbacks, ...);
    end
end

----------------------------------------------------------------------------------------------------
-- Expose the event functions..
----------------------------------------------------------------------------------------------------
hook.events.find_event = find_event;
hook.events.register_event = register_event;
hook.events.unregister_event = unregister_event;
hook.events.call_event = call_event;