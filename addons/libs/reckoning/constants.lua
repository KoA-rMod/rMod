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

--[[

    Data in this file is pulled directly from the game files. 
    Everything listed here is confirmed and valid for the following game version: v1.0.0.2

]]--

reckoning = reckoning or { };
reckoning.constants = reckoning.constants or { };

----------------------------------------------------------------------------------------------------
-- Misc Constants
----------------------------------------------------------------------------------------------------
reckoning.constants.max_fate = 264;

----------------------------------------------------------------------------------------------------
-- Exp Leveling Table
----------------------------------------------------------------------------------------------------
reckoning.constants.exp_to_level_table =
{
    [0] = 0,
    [1] = 500,
    [2] = 1600,
    [3] = 3400,
    [4] = 6000,
    [5] = 9500,
    [6] = 14000,
    [7] = 19700,
    [8] = 26600,
    [9] = 34900,
    [10] = 44600,
    [11] = 55900,
    [12] = 68800,
    [13] = 83500,
    [14] = 100000,
    [15] = 118500,
    [16] = 139000,
    [17] = 161500,
    [18] = 186000,
    [19] = 213500,
    [20] = 244000,
    [21] = 277500,
    [22] = 314000,
    [23] = 354500,
    [24] = 399000,
    [25] = 447500,
    [26] = 500000,
    [27] = 557500,
    [28] = 620000,
    [29] = 687500,
    [30] = 760000,
    [31] = 839500,
    [32] = 926000,
    [33] = 1019500,
    [34] = 1120000,
    [35] = 1230500,
    [36] = 1351000,
    [37] = 1481500,
    [38] = 1622000,
    [39] = 1777500,
    [40] = 1948000,
    [41] = 2133500,
    [42] = 2334000,
    [43] = 2554500,
    [44] = 2795000,
    [45] = 3055500
};

----------------------------------------------------------------------------------------------------
-- Exp Leveling Speed Table
----------------------------------------------------------------------------------------------------
reckoning.constants.leveling_speed_table =
{
    [0] = 150,
    [1] = 125,
    [2] = 80,
    [3] = 70,
    [4] = 60,
    [5] = 55,
    [6] = 50,
    [7] = 45,
    [8] = 40,
    [9] = 35,
    [10] = 30,
    [11] = 25,
    [12] = 20,
    [13] = 19,
    [14] = 18,
    [15] = 17,
    [16] = 16,
    [17] = 15,
    [18] = 14,
    [19] = 10,
    [20] = 8,
    [21] = 6,
    [22] = 5
};