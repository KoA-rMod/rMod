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
-- Extensions
----------------------------------------------------------------------------------------------------
require 'extensions.math';
require 'extensions.string';
require 'extensions.table';

----------------------------------------------------------------------------------------------------
-- Hook Related (Don't include events.lua manually!)
----------------------------------------------------------------------------------------------------
require 'hook.helpers';
require 'hook.imguidef';

----------------------------------------------------------------------------------------------------
-- Reckoning Specific Libraries
----------------------------------------------------------------------------------------------------
require 'reckoning.constants';
require 'reckoning.actor';

----------------------------------------------------------------------------------------------------
-- Misc Libraries
----------------------------------------------------------------------------------------------------
require 'settings';
require 'timer';