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
-- func: string.contains
-- desc: Determines if a string contains the given sub-string.
----------------------------------------------------------------------------------------------------
function string.contains(s, v)
    return s:find(v, nil, true) ~= nil;
end

----------------------------------------------------------------------------------------------------
-- func: string.startswith
-- desc: Determines if a string begins with a specific string.
----------------------------------------------------------------------------------------------------
function string.startswith(s, v)
    return s:sub(1, #v) == v;
end

----------------------------------------------------------------------------------------------------
-- func: string.endswith
-- desc: Determines if a string ends with a specific string.
----------------------------------------------------------------------------------------------------
function string.endswith(s, v)
    return s:sub(-#v) == v;
end

----------------------------------------------------------------------------------------------------
-- func: string.upperfirst
-- desc: Uppercases the first letter of a string.
----------------------------------------------------------------------------------------------------
function string.upperfirst(s)
    return s:sub(1, 1):upper() .. s:sub(2);
end

----------------------------------------------------------------------------------------------------
-- func: string.toproper
-- desc: Converts a string to proper casing.
----------------------------------------------------------------------------------------------------
function string.toproper(s)
    local ret = '';
    local t = { };

    for x = 1, s:len() do
        t[x] = s:sub(x, x);
        if (t[x - 1] == ' ' or x == 1) then
            t[x] = t[x]:upperfirst();
        end
        ret = ret .. t[x];
    end
    return ret;
end

----------------------------------------------------------------------------------------------------
-- func: string.insert
-- desc: Inserts data into the current string at the given position.
----------------------------------------------------------------------------------------------------
function string.insert(s, p, v)
    local part = s:sub(1, p - 1);
    return part .. v .. s:sub(#part + 1);
end

----------------------------------------------------------------------------------------------------
-- func: string.remove
-- desc: Removes the character at the given index.
----------------------------------------------------------------------------------------------------
function string.remove(s, index)
    return s:sub(0, index - 1) .. s:sub(index + 1);
end

----------------------------------------------------------------------------------------------------
-- func: string.lpad
-- desc: Pads a string 'n' times with the given string.
----------------------------------------------------------------------------------------------------
function string.lpad(s, v, n)
    return (v:rep(n) .. s):sub(-(n > #s and n or #s));
end

----------------------------------------------------------------------------------------------------
-- func: string.rpad
-- desc: Pads a string 'n' times with the given string.
----------------------------------------------------------------------------------------------------
function string.rpad(s, v, n)
    return (s .. v:rep(n)):sub(1, -(n > #s and n or #s));
end

----------------------------------------------------------------------------------------------------
-- func: string.hex
-- desc: Converts a strings value to a hex string.
----------------------------------------------------------------------------------------------------
function string.hex(s, sep)
    sep = sep or ' ';

    local ret = '';
    for _, v in pairs(s:totable()) do
        ret = ret .. string.format('%02X', v) .. sep;
    end
    return ret:trim();
end

----------------------------------------------------------------------------------------------------
-- func: string.fromhex
-- desc: Converts a hex value to a string.
----------------------------------------------------------------------------------------------------
function string.fromhex(s)
    s = s:gsub('%s*0x', ''):gsub('[^%w]', '');
    return (s:gsub('%w%w', function(c) return string.char(tonumber(c, 16)); end));
end

----------------------------------------------------------------------------------------------------
-- func: string.totable
-- desc: Converts the characters of a string to a table.
----------------------------------------------------------------------------------------------------
function string.totable(s)
    local ret = { };
    for x = 1, string.len(s) do
        ret[x] = string.byte(s, x);
    end
    return ret;
end

----------------------------------------------------------------------------------------------------
-- func: string.clean
-- desc: Cleans a string of whitespace.
----------------------------------------------------------------------------------------------------
function string.clean(s, trimend)
    if (trimend == nil) then trimend = true; end
    if (trimend) then
        return s:gsub('%s+', ' '):trim();
    else
        return (s:gsub('%s+', ' '));
    end
end

----------------------------------------------------------------------------------------------------
-- func: string.trimstart
-- desc: Trims the start of a string for whitespace.
----------------------------------------------------------------------------------------------------
function string.trimstart(s, c)
    if (not c) then c = ' '; end
    s = string.reverse(s);
    s = string.trimend(s, c);
    return string.reverse(s);
end

----------------------------------------------------------------------------------------------------
-- func: string.trimend
-- desc: Trims the end of a string for whitespace.
----------------------------------------------------------------------------------------------------
function string.trimend(s, c)
    if (not c) then c = ' '; end
    if (string.sub(s, -1) == c) then
        s = string.sub(s, 0, -2);
        s = string.trimend(s, c);
    end
    return s;
end

----------------------------------------------------------------------------------------------------
-- func: string.trim
-- desc: Trims a string of whitespace.
----------------------------------------------------------------------------------------------------
function string.trim(s, c)
    if (not c) then c = ' '; end
    s = string.trimstart(s, c);
    s = string.trimend(s, c);
    return s;
end

----------------------------------------------------------------------------------------------------
-- func: string.trim2
-- desc: Trims a string of whitespace. (Uses regex.)
----------------------------------------------------------------------------------------------------
function string.trim2(s, c)
    if (c == nil or c == false) then
        return s:match('^%s*(.-)%s*$');
    end
    return s:match('^(.-)%s*$');
end

----------------------------------------------------------------------------------------------------
-- func: string.args
-- desc: Returns a table of arguments parsed from a string.
----------------------------------------------------------------------------------------------------
function string:args()
    local STATE_NONE    = 0; -- Currently within nothing..
    local STATE_WORD    = 1; -- Currently within a word..
    local STATE_QUOTE   = 2; -- Currently within a quote..

    local currentState  = STATE_NONE;
    local currentChar   = nil;
    local nextChar      = nil;
    local stringStart   = nil;
    local args          = { };

    -- Loop the string and self any arguments..
    for x = 1, string.len(self) do
        -- Read the current characters..
        currentChar = string.sub(self, x, x);
        nextChar 	= string.sub(self, x + 1, x+1);

        -- Handle non-state..
        if (currentState == STATE_NONE) then
            if (currentChar == '"') then
                stringStart = x+1;
                currentState = STATE_QUOTE;
            else
                if (currentChar ~= ' ') then
                    stringStart = x;
                    currentState = STATE_WORD;
                end
            end

        -- Handle quoted string state..
        elseif (currentState == STATE_QUOTE) then
            if (currentChar == '"') then
                currentState = STATE_NONE;
                table.insert(args, #args+1, string.sub(self, stringStart, x - 1));
            end

        -- Handle word string state..
        elseif (currentState == STATE_WORD) then
            if (currentChar == ' ' or nextChar == nil or nextChar == '\0') then
                currentState = STATE_NONE;
                table.insert(args, #args+1, string.sub(self, stringStart, x - 1));
            end
        else
            error('Invalid word state while parsing command arguments.');
        end
    end

    -- If in a word insert into the args table..
    if (currentState == STATE_WORD) then
        table.insert(args, #args + 1, string.sub(self, stringStart, #self + 1));
    end

    -- Return the found arguments..
    return args;
end

----------------------------------------------------------------------------------------------------
-- func: string.is_quoted_arg
-- desc: Determines if the string is quoted.
----------------------------------------------------------------------------------------------------
function string.is_quoted_arg()
    local arg = string.match(self, "^\"(.*)\"$");
    return (arg ~= nil), arg;
end

----------------------------------------------------------------------------------------------------
-- func: string.parseargs
-- desc: Returns a table of arguments parsed from a string.
----------------------------------------------------------------------------------------------------
function string:parseargs()
    local STATE_NONE    = 0; -- Currently within nothing..
    local STATE_WORD    = 1; -- Currently within a word..
    local STATE_QUOTE   = 2; -- Currently within a quote..

    local currentState  = STATE_NONE;
    local currentChar   = nil;
    local nextChar      = nil;
    local stringStart   = nil;
    local prefix        = nil;
    local args          = { };

    -- Loop the string and self any arguments..
    for x = 1, string.len(self) do
        -- Read the current characters..
        currentChar = string.sub(self, x, x);
        nextChar    = string.sub(self, x + 1, x + 1);

        -- Ensure the command starts with a slash..
        if (x == 1 and currentChar ~= '/') then
            return nil;
        end

        -- Handle non-state..
        if (currentState == STATE_NONE) then
            if (currentChar == '"') then
                stringStart = x;
                currentState = STATE_QUOTE;
            elseif (currentChar ~= ' ') then
                stringStart = x;
                currentState = STATE_WORD;
            end

        -- Handle quoted string state..
        elseif (currentState == STATE_QUOTE) then
            if (currentChar == '"') then
                table.insert(args, #args + 1, string.sub(self, stringStart, x));
                currentState = STATE_NONE;
            end

        -- Handle word string state..
        elseif (currentState == STATE_WORD) then
            if (currentChar == ' ') then
                table.insert(args, #args+1, string.sub(self, stringStart, x - 1));
                if (prefix == nil) then
                    prefix = args[#args];
                end
                currentState = STATE_NONE;
            elseif (nextChar == nil or nextChar == '\0') then
                -- This section never actually seems to get hit during processing.
                -- Regardless, it needs to use a different endpoint than the block above.
                table.insert(args, #args + 1, string.sub(self, stringStart, x));
                if (prefix == nil) then
                    prefix = args[#args];
                end
                currentState = STATE_NONE;
            elseif (prefix == nil and currentChar == '/' and x == (stringStart + 1)) then
                -- If command line starts with //, put that in its own argument field
                table.insert(args, #args + 1, string.sub(self, stringStart, x));
                prefix = args[#args];
                currentState = STATE_NONE;
            elseif (currentChar == '"') then
                -- A quote mark should start a new quote arg, even if there is no space delimiter.
                table.insert(args, #args + 1, string.sub(self, stringStart, x - 1));
                currentState = STATE_QUOTE;
                stringStart = x;
            end
        else
            error('Invalid word state while parsing command arguments.');
        end
    end

    -- If in a word insert into the args table..
    if (currentState == STATE_WORD) then
        table.insert(args, #args + 1, string.sub(self, stringStart, #self));
    end

    -- Return the found arguments..
    return args;
end