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
hook.gui = hook.gui or { };

-- Global instance of the ImGui object to reduce nesting..
imgui = hook.gui;

----------------------------------------------------------------------------------------------------
-- Common ImGui Used Values
----------------------------------------------------------------------------------------------------
FLT_MAX = 3.402823466e+38;

----------------------------------------------------------------------------------------------------
-- ImGui Window Flags (ImGui::Begin)
----------------------------------------------------------------------------------------------------
ImGuiWindowFlags_NoTitleBar                 = 1;
ImGuiWindowFlags_NoResize                   = 2;
ImGuiWindowFlags_NoMove                     = 4;
ImGuiWindowFlags_NoScrollbar                = 8;
ImGuiWindowFlags_NoScrollWithMouse          = 16;
ImGuiWindowFlags_NoCollapse                 = 32;
ImGuiWindowFlags_AlwaysAutoResize           = 64;
ImGuiWindowFlags_ShowBorders                = 128;
ImGuiWindowFlags_NoSavedSettings            = 256;
ImGuiWindowFlags_NoInputs                   = 512;
ImGuiWindowFlags_MenuBar                    = 1024;
ImGuiWindowFlags_HorizontalScrollbar        = 2048;
ImGuiWindowFlags_NoFocusOnAppearing         = 4096;
ImGuiWindowFlags_NoBringToFrontOnFocus      = 8192;
ImGuiWindowFlags_AlwaysVerticalScrollbar    = 16384;
ImGuiWindowFlags_AlwaysHorizontalScrollbar  = 32768;
ImGuiWindowFlags_AlwaysUseWindowPadding     = 65536;
ImGuiWindowFlags_ChildWindow                = 1048576;       -- Internal use only!
ImGuiWindowFlags_ChildWindowAutoFitX        = 2097152;       -- Internal use only!
ImGuiWindowFlags_ChildWindowAutoFitY        = 4194304;       -- Internal use only!
ImGuiWindowFlags_ComboBox                   = 8388608;       -- Internal use only!
ImGuiWindowFlags_Tooltip                    = 16777216;      -- Internal use only!
ImGuiWindowFlags_Popup                      = 33554432;      -- Internal use only!
ImGuiWindowFlags_Modal                      = 67108864;      -- Internal use only!
ImGuiWindowFlags_ChildMenu                  = 134217728;     -- Internal use only!

----------------------------------------------------------------------------------------------------
-- ImGui Input Text Flags (ImGui::InputText)
----------------------------------------------------------------------------------------------------
ImGuiInputTextFlags_CharsDecimal            = 1;
ImGuiInputTextFlags_CharsHexadecimal        = 2;
ImGuiInputTextFlags_CharsUppercase          = 4;
ImGuiInputTextFlags_CharsNoBlank            = 8;
ImGuiInputTextFlags_AutoSelectAll           = 16;
ImGuiInputTextFlags_EnterReturnsTrue        = 32;
ImGuiInputTextFlags_CallbackCompletion      = 64;
ImGuiInputTextFlags_CallbackHistory         = 128;
ImGuiInputTextFlags_CallbackAlways          = 256;
ImGuiInputTextFlags_CallbackCharFilter      = 512;
ImGuiInputTextFlags_AllowTabInput           = 1024;
ImGuiInputTextFlags_CtrlEnterForNewLine     = 2048;
ImGuiInputTextFlags_NoHorizontalScroll      = 4096;
ImGuiInputTextFlags_AlwaysInsertMode        = 8192;
ImGuiInputTextFlags_ReadOnly                = 16384;
ImGuiInputTextFlags_Password                = 32768;
ImGuiInputTextFlags_Multiline               = 1048576;      -- Internal use only!

----------------------------------------------------------------------------------------------------
-- ImGui Tree Node Flags (ImGui::TreeNodeEx(), ImGui::CollapsingHeader*())
----------------------------------------------------------------------------------------------------
ImGuiTreeNodeFlags_Selected                 = 1;
ImGuiTreeNodeFlags_Framed                   = 2;
ImGuiTreeNodeFlags_AllowOverlapMode         = 4;
ImGuiTreeNodeFlags_NoTreePushOnOpen         = 8;
ImGuiTreeNodeFlags_NoAutoOpenOnLog          = 16;
ImGuiTreeNodeFlags_DefaultOpen              = 32;
ImGuiTreeNodeFlags_OpenOnDoubleClick        = 64;
ImGuiTreeNodeFlags_OpenOnArrow              = 128;
ImGuiTreeNodeFlags_Leaf                     = 256;
ImGuiTreeNodeFlags_Bullet                   = 512;

ImGuiTreeNodeFlags_CollapsingHeader         = 18;           -- ImGuiTreeNodeFlags_Framed | ImGuiTreeNodeFlags_NoAutoOpenOnLog

----------------------------------------------------------------------------------------------------
-- ImGui Selectable Flags (ImGui::Selectable())
----------------------------------------------------------------------------------------------------
ImGuiSelectableFlags_DontClosePopups        = 1;
ImGuiSelectableFlags_SpanAllColumns         = 2;
ImGuiSelectableFlags_AllowDoubleClick       = 4;

----------------------------------------------------------------------------------------------------
-- User fill ImGuiIO.KeyMap[] array with indices into the ImGuiIO.KeysDown[512] array.
----------------------------------------------------------------------------------------------------
ImGuiKey_Tab                                = 0;
ImGuiKey_LeftArrow                          = 1;
ImGuiKey_RightArrow                         = 2;
ImGuiKey_UpArrow                            = 3;
ImGuiKey_DownArrow                          = 4;
ImGuiKey_PageUp                             = 5;
ImGuiKey_PageDown                           = 6;
ImGuiKey_Home                               = 7;
ImGuiKey_End                                = 8;
ImGuiKey_Delete                             = 9;
ImGuiKey_Backspace                          = 10;
ImGuiKey_Enter                              = 11;
ImGuiKey_Escape                             = 12;
ImGuiKey_A                                  = 13;
ImGuiKey_C                                  = 14;
ImGuiKey_V                                  = 15;
ImGuiKey_X                                  = 16;
ImGuiKey_Y                                  = 17;
ImGuiKey_Z                                  = 18;

----------------------------------------------------------------------------------------------------
-- Enumeration for PushStyleColor() / PopStyleColor()
----------------------------------------------------------------------------------------------------
ImGuiCol_Text                               = 0;
ImGuiCol_TextDisabled                       = 1;
ImGuiCol_WindowBg                           = 2;
ImGuiCol_ChildWindowBg                      = 3;
ImGuiCol_PopupBg                            = 4;
ImGuiCol_Border                             = 5;
ImGuiCol_BorderShadow                       = 6;
ImGuiCol_FrameBg                            = 7;
ImGuiCol_FrameBgHovered                     = 8;
ImGuiCol_FrameBgActive                      = 9;
ImGuiCol_TitleBg                            = 10;
ImGuiCol_TitleBgCollapsed                   = 11;
ImGuiCol_TitleBgActive                      = 12;
ImGuiCol_MenuBarBg                          = 13;
ImGuiCol_ScrollbarBg                        = 14;
ImGuiCol_ScrollbarGrab                      = 15;
ImGuiCol_ScrollbarGrabHovered               = 16;
ImGuiCol_ScrollbarGrabActive                = 17;
ImGuiCol_ComboBg                            = 18;
ImGuiCol_CheckMark                          = 19;
ImGuiCol_SliderGrab                         = 20;
ImGuiCol_SliderGrabActive                   = 21;
ImGuiCol_Button                             = 22;
ImGuiCol_ButtonHovered                      = 23;
ImGuiCol_ButtonActive                       = 24;
ImGuiCol_Header                             = 25;
ImGuiCol_HeaderHovered                      = 26;
ImGuiCol_HeaderActive                       = 27;
ImGuiCol_Column                             = 28;
ImGuiCol_ColumnHovered                      = 29;
ImGuiCol_ColumnActive                       = 30;
ImGuiCol_ResizeGrip                         = 31;
ImGuiCol_ResizeGripHovered                  = 32;
ImGuiCol_ResizeGripActive                   = 33;
ImGuiCol_CloseButton                        = 34;
ImGuiCol_CloseButtonHovered                 = 35;
ImGuiCol_CloseButtonActive                  = 36;
ImGuiCol_PlotLines                          = 37;
ImGuiCol_PlotLinesHovered                   = 38;
ImGuiCol_PlotHistogram                      = 39;
ImGuiCol_PlotHistogramHovered               = 40;
ImGuiCol_TextSelectedBg                     = 41;
ImGuiCol_ModalWindowDarkening               = 42;

----------------------------------------------------------------------------------------------------
-- Enumeration for PushStyleVar() / PopStyleVar()
-- NB: the enum only refers to fields of ImGuiStyle() which makes sense to be pushed/poped in UI code. Feel free to add others.
----------------------------------------------------------------------------------------------------
ImGuiStyleVar_Alpha                         = 0;
ImGuiStyleVar_WindowPadding                 = 1;
ImGuiStyleVar_WindowRounding                = 2;
ImGuiStyleVar_WindowMinSize                 = 3;
ImGuiStyleVar_ChildWindowRounding           = 4;
ImGuiStyleVar_FramePadding                  = 5;
ImGuiStyleVar_FrameRounding                 = 6;
ImGuiStyleVar_ItemSpacing                   = 7;
ImGuiStyleVar_ItemInnerSpacing              = 8;
ImGuiStyleVar_IndentSpacing                 = 9;
ImGuiStyleVar_GrabMinSize                   = 10;

----------------------------------------------------------------------------------------------------
-- ImGuiAlign_
----------------------------------------------------------------------------------------------------
ImGuiAlign_Left                             = 1;
ImGuiAlign_Center                           = 2;
ImGuiAlign_Right                            = 4;
ImGuiAlign_Top                              = 8;
ImGuiAlign_VCenter                          = 16;
ImGuiAlign_Default                          = 9;            -- ImGuiAlign_Left | ImGuiAlign_Top

----------------------------------------------------------------------------------------------------
-- Enumeration for ColorEditMode()
----------------------------------------------------------------------------------------------------
ImGuiColorEditMode_UserSelect               = -2;
ImGuiColorEditMode_UserSelectShowButton     = -1;
ImGuiColorEditMode_RGB                      = 0;
ImGuiColorEditMode_HSV                      = 1;
ImGuiColorEditMode_HEX                      = 2;

----------------------------------------------------------------------------------------------------
-- Enumeration for GetMouseCursor()
----------------------------------------------------------------------------------------------------
ImGuiMouseCursor_Arrow                      = 0;
ImGuiMouseCursor_TextInput                  = 1;
ImGuiMouseCursor_Move                       = 2;
ImGuiMouseCursor_ResizeNS                   = 3;
ImGuiMouseCursor_ResizeEW                   = 4;
ImGuiMouseCursor_ResizeNESW                 = 5;
ImGuiMouseCursor_ResizeNWSE                 = 6;

----------------------------------------------------------------------------------------------------
-- Condition flags for ImGui::SetWindow***(), SetNextWindow***(), SetNextTreeNode***() functions
-- All those functions treat 0 as a shortcut to ImGuiSetCond_Always
----------------------------------------------------------------------------------------------------
ImGuiSetCond_Always                         = 1;
ImGuiSetCond_Once                           = 2;
ImGuiSetCond_FirstUseEver                   = 4;
ImGuiSetCond_Appearing                      = 8;

----------------------------------------------------------------------------------------------------
-- Custom Variable Creation Types
-- Used with imgui.CreateVar
----------------------------------------------------------------------------------------------------
ImGuiVar_UNDEF                              = 0;    -- 0 bytes      (null)
ImGuiVar_BOOLCPP                            = 1;    -- 1 byte       bool
ImGuiVar_BOOL8                              = 2;    -- 1 byte       char
ImGuiVar_BOOL16                             = 3;    -- 2 bytes      short
ImGuiVar_BOOL32                             = 4;    -- 4 bytes      BOOL
ImGuiVar_CHAR                               = 5;    -- 1 byte       char
ImGuiVar_INT8                               = 6;    -- 1 byte       char
ImGuiVar_UINT8                              = 7;    -- 1 byte       unsigned char
ImGuiVar_INT16                              = 8;    -- 2 bytes      short
ImGuiVar_UINT16                             = 9;    -- 2 bytes      unsigned short
ImGuiVar_INT32                              = 10;   -- 4 bytes      int
ImGuiVar_UINT32                             = 11;   -- 4 bytes      unsigned int
ImGuiVar_FLOAT                              = 12;   -- 4 bytes      float
ImGuiVar_DOUBLE                             = 13;   -- 8 bytes      double
ImGuiVar_CDSTRING                           = 14;   -- ? bytes      char[]
ImGuiVar_BOOLARRAY                          = 15;   -- ? bytes      bool[]
ImGuiVar_INT16ARRAY                         = 16;   -- ? bytes      short[]
ImGuiVar_INT32ARRAY                         = 17;   -- ? bytes      int[]
ImGuiVar_FLOATARRAY                         = 18;   -- ? bytes      float[]
ImGuiVar_DOUBLEARRAY                        = 19;   -- ? bytes      double[]

----------------------------------------------------------------------------------------------------
-- func: stylecolor
-- desc: Sets a style color of the ImGui system.
----------------------------------------------------------------------------------------------------
local function stylecolor(idx, color)
    if (idx < 0 or idx > ImGuiCol_ModalWindowDarkening) then
        error('Attempting to set an invalid style color!');
        return;
    end

    local s = imgui.style.Colors;
    s[idx] = color;
    imgui.style.Colors = s;
end
hook.gui.stylecolor = stylecolor;

----------------------------------------------------------------------------------------------------
-- func: bor
-- desc: Bitwise or operation handler to loop varargs of flags and bitwise or them together.
----------------------------------------------------------------------------------------------------
local function imguibor(...)
    -- Obtain the arguments in a loopable table..
    local args = { n = select('#', ...), ... };
    local ret = 0;
    
    for x = 1, args.n do
        ret = bit.bor(ret, args[x]);    
    end
    
    return ret;
end
hook.gui.bor = imguibor;