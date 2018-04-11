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

----------------------------------------------------------------------------------------------------
-- func: switch
-- desc: Implements a C-Style switch-case handling within Lua.
-- cred: Credits to: Luiz Henrique de Figueiredo's implementation, this is based on his.
-- link: http://lua-users.org/wiki/SwitchStatement (Caseof Method Table)
----------------------------------------------------------------------------------------------------
function switch(c)
    local switch_table =
    {
        casevar = c,
        caseof  = function(self, code)
            local f;
            if (self.casevar) then
                f = code[self.casevar] or code.default;
            else
                f = code.missing or code.default;
            end
            if (f) then
                if (type(f) == 'function') then
                    return f(self.casevar, self);
                else
                    error('case: ' .. tostring(self.casevar));
                end
            end
        end
    };
    return switch_table;
end

----------------------------------------------------------------------------------------------------
-- func: try (try, catch, finally)
-- desc: Implements C++ style try/catch handlers, and introduces C# style finally.
-- cred: djfdyuruiry
-- link: https://github.com/djfdyuruiry/lua-try-catch-finally/blob/master/try-catch-finally.lua
----------------------------------------------------------------------------------------------------
function try(trycb)
    local status, err = true, nil;

    -- Handle the try block if it is a proper function..
    if (type(trycb) == 'function') then
        status, err = xpcall(trycb, debug.traceback);
    end

    ------------------------------------------------------------------------------------------------
    -- func: finally
    -- desc: Implements the 'finally' callback handling for the try/catch/finally setup.
    ------------------------------------------------------------------------------------------------
    local finally = function(finallycb, hascatchcb)
        -- Invoke the finally callback if present..
        if (type(finallycb) == 'function') then
            finallycb();
        end

        -- Throw error if no catch callback is defined..
        if (not hascatchcb and not status) then
            error(err);
        end
    end

    ------------------------------------------------------------------------------------------------
    -- func: catch
    -- desc: Implements the 'catch' callback handling for the try/catch/finally setup.
    ------------------------------------------------------------------------------------------------
    local catch = function(catchcb)
        local hascatchcb = type(catchcb) == 'function';
        
        -- Invoke the catch callback if valid and an error was caught..
        if (not status and hascatchcb) then
            local e = err or '(Unknown Error)';
            catchcb(e);
        end

        -- Return a table exposing the finally handler..
        return {
            finally = function(finallycb)
                finally(finallycb, hascatchcb);
            end
        };
    end

    -- Return a table exposing the catch and finally handlers..
    return {
        catch = catch,
        finally = function(finallycb)
            finally(finallycb, false);
        end
    };
end