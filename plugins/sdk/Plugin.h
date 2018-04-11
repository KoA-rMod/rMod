/**
 * rMod SDK - Copyright (c) 2018 atom0s [atom0s@live.com]
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
 * Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
 *
 * By using rMod SDK, you agree to the above license and its terms.
 *
 *      Attribution - You must give appropriate credit, provide a link to the license and indicate if changes were
 *                    made. You must do so in any reasonable manner, but not in any way that suggests the licensor
 *                    endorses you or your use.
 *
 *   Non-Commercial - You may not use the material (rMod SDK) for commercial purposes.
 *
 *   No-Derivatives - If you remix, transform, or build upon the material (rMod SDK), you may not distribute the
 *                    modified material. You are, however, allowed to submit the modified works back to the original
 *                    rMod SDK project in attempt to have it added to the original project.
 *
 * You may not apply legal terms or technological measures that legally restrict others
 * from doing anything the license permits.
 *
 * No warranties are given.
 */

////////////////////////////////////////////////////////////////////////////////////////////////////
// Warning: Please do not edit the contents of this file! This file is designed to work with the
// rMod hook and its inner workings. Altering this file can lead to crashes in any plugin that is
// compiled with this header!
//
// If you feel there is something that needs editing, please contact atom0s instead!
////////////////////////////////////////////////////////////////////////////////////////////////////
// ReSharper Disables
////////////////////////////////////////////////////////////////////////////////////////////////////
// ReSharper disable CppInconsistentNaming
// ReSharper disable CppPolymorphicClassWithNonVirtualPublicDestructor
// ReSharper disable CppUnusedIncludeDirective
////////////////////////////////////////////////////////////////////////////////////////////////////

#ifndef __PLUGIN_H_INCLUDED__
#define __PLUGIN_H_INCLUDED__

#if defined (_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// HOOK_INTERFACE_VERSION
//
// Defines the current interface version that rMod is compiled against. For plugins to work
// properly, they must match the interface version that rMod was compiled with. Do not edit
// this in attempts to make your plugin work, that can lead to unwanted crashes and possible
// data loss such as saved game information!
//
////////////////////////////////////////////////////////////////////////////////////////////////////
#define HOOK_INTERFACE_VERSION 1.0

////////////////////////////////////////////////////////////////////////////////////////////////////
// Direct3D SDK Definitions
////////////////////////////////////////////////////////////////////////////////////////////////////
#ifndef DIRECTINPUT_VERSION
#define DIRECTINPUT_VERSION 0x0800
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////
// General Includes
////////////////////////////////////////////////////////////////////////////////////////////////////
#include <Windows.h>
#include <algorithm>
#include <functional>
#include <map>
#include <string>

////////////////////////////////////////////////////////////////////////////////////////////////////
// SDK Includes
////////////////////////////////////////////////////////////////////////////////////////////////////
#include "d3d9/d3d9.h"
#include "d3d9/d3dx9.h"
#include "Atomic_BinaryData.h"
#include "Atomic_CommandParse.h"
#include "Atomic_Event.h"
#include "Atomic_Exception.h"
#include "Atomic_LockableObject.h"
#include "Atomic_Memory.h"
#include "Atomic_Thread.h"
#include "imgui.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Function Prototypes
//
////////////////////////////////////////////////////////////////////////////////////////////////////

typedef std::function<void(int32_t, void*, float, float)> MOUSEEVENT;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Hook Enumerations
//
///////////////////////////////////////////////////////////////////////////////////////////////////

namespace Hook
{
    namespace Enums
    {
        /**
         * Frame Anchor Enumeration
         */
        enum class FrameAnchor : uint32_t {
            TopLeft = 0,
            TopRight = 1,
            BottomLeft = 2,
            BottomRight = 3,

            Right = 1,
            Bottom = 2
        };

        /**
         * Frame Anchor Compare Operator
         */
        inline uint32_t operator& (const FrameAnchor& a, const FrameAnchor& b)
        {
            return (uint32_t)((uint32_t)a & (uint32_t)b);
        }

        /**
         * Mouse Input Enumeration
         */
        enum class MouseInput : uint32_t {
            // Click events..
            LeftClick = 0,
            RightClick = 1,
            MiddleClick = 2,
            X1Click = 3,
            X2Click = 4,

            // Mouse wheel events..
            MouseWheelUp = 5,
            MouseWheelDown = 6,

            // Mouse move events..
            MouseMove = 7
        };
    }; // namespace Enums
}; // namespace Hook

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Interface: IConfigManager
//
///////////////////////////////////////////////////////////////////////////////////////////////////

interface IConfigManager
{
    virtual bool Load(const char* alias, const char* file) = 0;
    virtual bool Save(const char* alias, const char* file) = 0;
    virtual void Unload(const char* alias) = 0;

    virtual void set_value(const char* alias, const char* section, const char* name, const char* value) = 0;
    virtual const char* get_string(const char* alias, const char* section, const char* name) = 0;
    virtual std::map<std::string, std::string>& get_values(const char* alias, const char* section) = 0;

    virtual bool get_bool(const char* alias, const char* section, const char* name, bool defaultValue) = 0;
    virtual uint8_t get_uint8(const char* alias, const char* section, const char* name, uint8_t defaultValue) = 0;
    virtual uint16_t get_uint16(const char* alias, const char* section, const char* name, uint16_t defaultValue) = 0;
    virtual uint32_t get_uint32(const char* alias, const char* section, const char* name, uint32_t defaultValue) = 0;
    virtual uint64_t get_uint64(const char* alias, const char* section, const char* name, uint64_t defaultValue) = 0;
    virtual int8_t get_int8(const char* alias, const char* section, const char* name, int8_t defaultValue) = 0;
    virtual int16_t get_int16(const char* alias, const char* section, const char* name, int16_t defaultValue) = 0;
    virtual int32_t get_int32(const char* alias, const char* section, const char* name, int32_t defaultValue) = 0;
    virtual int64_t get_int64(const char* alias, const char* section, const char* name, int64_t defaultValue) = 0;
    virtual float get_float(const char* alias, const char* section, const char* name, float defaultValue) = 0;
    virtual double get_double(const char* alias, const char* section, const char* name, double defaultValue) = 0;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Interface: IConsole
//
///////////////////////////////////////////////////////////////////////////////////////////////////

interface IConsole
{
    virtual void Write(uint32_t color, const char* msg) = 0;
    virtual void Writef(uint32_t color, const char* fmt, ...) = 0;
    virtual void Clear(void) = 0;

    virtual void QueueCommand(const char* command) = 0;
    virtual void ProcessCommand(const char* command) = 0;
    virtual void RunTextScript(bool useTaskQueue, const char* script) = 0;
    virtual void RunScriptString(bool useTaskQueue, const std::string& str) = 0;

    virtual bool GetVisible(void) const = 0;
    virtual void SetVisible(bool visible) = 0;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Interface: IKeyboard
//
///////////////////////////////////////////////////////////////////////////////////////////////////

interface IKeyboard
{
    virtual void Bind(uint32_t key, bool bDown, bool bAlt, bool bCtrl, bool bWinKey, bool bAppsKey, bool bShift, const char* pszCommand) = 0;
    virtual void Unbind(uint32_t key, bool bDown, bool bAlt, bool bCtrl, bool bWinKey, bool bAppsKey, bool bShift) = 0;
    virtual void UnbindAll(void) = 0;
    virtual bool IsBound(uint32_t key, bool bAlt, bool bCtrl, bool bWinKey, bool bAppsKey, bool bShift) = 0;
    virtual void ListBinds(void) = 0;

    virtual uint32_t S2V(const char* key) = 0;
    virtual const char* V2S(uint32_t key) = 0;

    virtual bool IsAltDown(void) const = 0;
    virtual bool IsCtrlDown(void) const = 0;
    virtual bool IsShiftDown(void) const = 0;
    virtual bool IsWinDown(void) const = 0;
    virtual bool IsAppsDown(void) const = 0;

    virtual bool GetBlocked(void) const = 0;
    virtual void SetBlocked(bool blocked) = 0;

    virtual uint32_t GetNextKeyPress(void) = 0;
    virtual void SetNextKeyPress(uint32_t key) = 0;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Interface: IMouse
//
///////////////////////////////////////////////////////////////////////////////////////////////////

interface IMouse
{
    virtual bool GetBlocked(void) const = 0;
    virtual void SetBlocked(bool blocked) = 0;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Interface: IInputManager
//
///////////////////////////////////////////////////////////////////////////////////////////////////

interface IInputManager
{
    virtual IKeyboard* GetKeyboard(void) const = 0;
    virtual IMouse* GetMouse(void) const = 0;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Interface: IPluginManager
//
///////////////////////////////////////////////////////////////////////////////////////////////////

interface IPluginManager
{
    virtual uint32_t GetCount(void) = 0;

    virtual bool Load(const char* name) = 0;
    virtual bool Unload(const char* name) = 0;
    virtual void* Get(const char* name) = 0;
    virtual void* Get(const int32_t index) = 0;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Interface: IOffsetManager
//
///////////////////////////////////////////////////////////////////////////////////////////////////

interface IOffsetManager
{
    virtual int32_t GetOffset(const char* name) const = 0;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Interface: IPointerManager
//
///////////////////////////////////////////////////////////////////////////////////////////////////

interface IPointerManager
{
    virtual uintptr_t GetPointer(const char* name) const = 0;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Interface: IPrimitiveObject
//
///////////////////////////////////////////////////////////////////////////////////////////////////

interface IPrimitiveObject
{
    virtual void SetTextureFromFile(const char* path) = 0;
    virtual void SetTextureFromResource(const char* moduleName, const char* name) = 0;

    virtual bool HitTest(int32_t x, int32_t y) const = 0;

    virtual D3DCOLOR GetBorderColor(void) const = 0;
    virtual uint32_t GetBorderFlags(void) const = 0;
    virtual RECT GetBorderSizes(void) const = 0;
    virtual bool GetBorderVisible(void) const = 0;
    virtual D3DCOLOR GetColor(void) const = 0;
    virtual float GetHeight(void) const = 0;
    virtual float GetPositionX(void) const = 0;
    virtual float GetPositionY(void) const = 0;
    virtual float GetScaleX(void) const = 0;
    virtual float GetScaleY(void) const = 0;
    virtual bool GetVisible(void) const = 0;
    virtual float GetWidth(void) const = 0;

    virtual void SetBorderColor(D3DCOLOR color) = 0;
    virtual void SetBorderFlags(uint32_t flags) = 0;
    virtual void SetBorderSizes(uint32_t top, uint32_t right, uint32_t bottom, uint32_t left) = 0;
    virtual void SetBorderVisible(bool visible) = 0;
    virtual void SetColor(D3DCOLOR color) = 0;
    virtual void SetHeight(float h) = 0;
    virtual void SetPositionX(float x) = 0;
    virtual void SetPositionY(float y) = 0;
    virtual void SetScaleX(float scale) = 0;
    virtual void SetScaleY(float scale) = 0;
    virtual void SetVisible(bool visible) = 0;
    virtual void SetWidth(float w) = 0;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Interface: IFontObject
//
///////////////////////////////////////////////////////////////////////////////////////////////////

interface IFontObject
{
    virtual bool HitTest(float posX, float posY) const = 0;

    virtual const char* GetAlias(void) const = 0;
    virtual Hook::Enums::FrameAnchor GetAnchor(void) const = 0;
    virtual Hook::Enums::FrameAnchor GetAnchorParent(void) const = 0;
    virtual bool GetAutoResize(void) const = 0;
    virtual IPrimitiveObject* GetBackground(void) const = 0;
    virtual bool GetBold(void) const = 0;
    virtual float GetBorderSize(void) const = 0;
    virtual D3DCOLOR GetColor(void) const = 0;
    virtual uint32_t GetCreateFlags(void) const = 0;
    virtual bool GetDirtyFlag(void) const = 0;
    virtual uint32_t GetDrawFlags(void) const = 0;
    virtual const char* GetFontFamily(void) const = 0;
    virtual const char* GetFontFile(void) const = 0;
    virtual int32_t GetFontHeight(void) const = 0;
    virtual bool GetItalic(void) const = 0;
    virtual bool GetLocked(void) const = 0;
    virtual MOUSEEVENT GetMouseEventFunction(void) const = 0;
    virtual IFontObject* GetParent(void) const = 0;
    virtual float GetPositionX(void) const = 0;
    virtual float GetPositionY(void) const = 0;
    virtual float GetRealPositionX(void) const = 0;
    virtual float GetRealPositionY(void) const = 0;
    virtual bool GetRightJustified(void) const = 0;
    virtual D3DCOLOR GetStrokeColor(void) const = 0;
    virtual const char* GetText(void) const = 0;
    virtual void GetTextSize(SIZE* lpSize) const = 0;
    virtual bool GetVisible(void) const = 0;
    virtual float GetWindowHeight(void) const = 0;
    virtual float GetWindowWidth(void) const = 0;

    virtual void SetAlias(const char* alias) = 0;
    virtual void SetAnchor(Hook::Enums::FrameAnchor anchor) = 0;
    virtual void SetAnchorParent(Hook::Enums::FrameAnchor anchor) = 0;
    virtual void SetAutoResize(bool resize) = 0;
    virtual void SetBold(bool bold) = 0;
    virtual void SetBorderSize(float size) = 0;
    virtual void SetColor(D3DCOLOR color) = 0;
    virtual void SetCreateFlags(uint32_t flags) = 0;
    virtual void SetDirtyFlag(bool dirty) = 0;
    virtual void SetDrawFlags(uint32_t flags) = 0;
    virtual void SetFontFamily(const char* family) = 0;
    virtual void SetFontFile(const char* family) = 0;
    virtual void SetFontHeight(int32_t height) = 0;
    virtual void SetItalic(bool italic) = 0;
    virtual void SetLocked(bool locked) = 0;
    virtual void SetMouseEventFunction(MOUSEEVENT func) = 0;
    virtual void SetParent(IFontObject* parent) = 0;
    virtual void SetPositionX(float x) = 0;
    virtual void SetPositionY(float y) = 0;
    virtual void SetRightJustified(bool justified) = 0;
    virtual void SetStrokeColor(D3DCOLOR stroke) = 0;
    virtual void SetText(const char* text) = 0;
    virtual void SetVisible(bool visible) = 0;
    virtual void SetWindowHeight(float height) = 0;
    virtual void SetWindowWidth(float width) = 0;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Interface: IFontManager
//
///////////////////////////////////////////////////////////////////////////////////////////////////

interface IFontManager
{
    virtual IFontObject* Create(const char* alias) = 0;
    virtual IFontObject* Get(const char* alias) = 0;
    virtual void Delete(const char* alias) = 0;

    virtual bool GetHideAllObjects(void) const = 0;
    virtual void SetHideAllObjects(bool hide) = 0;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Interface: IHookCore
//
///////////////////////////////////////////////////////////////////////////////////////////////////

interface IHookCore
{
    virtual IConfigManager* GetConfigManager(void) const = 0;
    virtual IConsole* GetConsole(void) const = 0;
    virtual IFontManager* GetFontManager(void) const = 0;
    virtual IImGuiManager* GetGuiManager(void) const = 0;
    virtual IInputManager* GetInputManager(void) const = 0;
    virtual IOffsetManager* GetOffsetManager(void) const = 0;
    virtual IPluginManager* GetPluginManager(void) const = 0;
    virtual IPointerManager* GetPointerManager(void) const = 0;

    virtual bool GetInitialized(void) const = 0;
    virtual IDirect3DDevice9* GetGraphicsDevice(void) const = 0;
    virtual HWND GetGameHwnd(void) const = 0;
    virtual HWND GetGameInputHwnd(void) const = 0;
    virtual unsigned long GetGameWidth(void) const = 0;
    virtual unsigned long GetGameHeight(void) const = 0;
    virtual HMODULE GetHookHandle(void) const = 0;
    virtual const char* GetGameInstallPath(void) const = 0;
    virtual const char* GetHookInstallPath(void) const = 0;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Plugin Information
//
// Plugin information that is shared back to the rMod plugin manager. This structure holds the
// information used to identify your plugin. You must populate the data in this structure for
// your plugin to be considered valid and loadable!
//
///////////////////////////////////////////////////////////////////////////////////////////////////

struct plugininfo_t
{
    char    Name[MAX_PATH];
    char    Author[MAX_PATH];
    double  InterfaceVersion;
    double  PluginVersion;
    int32_t Priority;

    plugininfo_t(void)
    {
        strcpy_s(this->Name, MAX_PATH, "atom0s");
        strcpy_s(this->Author, MAX_PATH, "koa.atom0s.com");
        this->InterfaceVersion = HOOK_INTERFACE_VERSION;
        this->PluginVersion = 1.0f;
        this->Priority = 0;
    }
    plugininfo_t(const char* name, const char* author, const double interfaceVersion, const double pluginVersion, const int32_t priority)
    {
        strcpy_s(this->Name, MAX_PATH, name);
        strcpy_s(this->Author, MAX_PATH, author);
        this->InterfaceVersion = interfaceVersion;
        this->PluginVersion = pluginVersion;
        this->Priority = priority;
    }
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// IPluginBase
//
// The base plugin interface that plugins inherit from. 
// (Do not inherit directly from this interface, use IPlugin instead!)
//
///////////////////////////////////////////////////////////////////////////////////////////////////

interface IPluginBase
{
    virtual plugininfo_t GetPluginInfo(void) = 0;

    virtual bool Initialize(IHookCore* hookCore, const uint32_t pluginId) = 0;
    virtual void Release(void) = 0;

    virtual bool HandleCommand(const char* command) = 0;
    virtual bool HandleKeyboard(int32_t nCode, WPARAM wParam, LPARAM lParam, bool blocked) = 0;
    virtual bool HandleMouse(int32_t nCode, WPARAM wParam, LPARAM lParam, bool blocked) = 0;

    virtual bool Direct3DInitialize(IDirect3DDevice9* lpDevice) = 0;
    virtual void Direct3DRelease(void) = 0;
    virtual void Direct3DPreReset(D3DPRESENT_PARAMETERS* pparams) = 0;
    virtual void Direct3DPostReset(D3DPRESENT_PARAMETERS* pparams) = 0;
    virtual void Direct3DBeginScene(void) = 0;
    virtual void Direct3DEndScene(void) = 0;
    virtual void Direct3DPrePresent(const RECT* pSourceRect, const RECT* pDestRect, HWND hDestWindowOverride, const RGNDATA* pDirtyRegion) = 0;
    virtual void Direct3DPostPresent(const RECT* pSourceRect, const RECT* pDestRect, HWND hDestWindowOverride, const RGNDATA* pDirtyRegion) = 0;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// IPlugin
//
// The base plugin class that plugins inherit from.
//
///////////////////////////////////////////////////////////////////////////////////////////////////

class IPlugin : public IPluginBase
{
protected:
    ;
    IHookCore*          m_HookCore;
    uint32_t            m_PluginId;
    IDirect3DDevice9*   m_Direct3DDevice;

public:
    IPlugin(void)
        : m_HookCore(nullptr)
        , m_PluginId(0)
        , m_Direct3DDevice(nullptr)
    { }
    virtual ~IPlugin(void) { }

public:
    plugininfo_t GetPluginInfo() override
    {
        return plugininfo_t("atom0s", "koa.atom0s.com", HOOK_INTERFACE_VERSION, 1.00f, 0);
    }

public:
    bool Initialize(IHookCore* hookCore, const uint32_t pluginId) override
    {
        this->m_HookCore = hookCore;
        this->m_PluginId = pluginId;
        this->m_Direct3DDevice = nullptr;
        return false;
    }
    void Release(void) override { }

    bool HandleCommand(const char* command) override
    {
        UNREFERENCED_PARAMETER(command);
        return false;
    }
    bool HandleKeyboard(int32_t nCode, WPARAM wParam, LPARAM lParam, bool blocked) override
    {
        UNREFERENCED_PARAMETER(nCode);
        UNREFERENCED_PARAMETER(wParam);
        UNREFERENCED_PARAMETER(lParam);
        return false;
    }
    bool HandleMouse(int32_t nCode, WPARAM wParam, LPARAM lParam, bool blocked) override
    {
        UNREFERENCED_PARAMETER(nCode);
        UNREFERENCED_PARAMETER(wParam);
        UNREFERENCED_PARAMETER(lParam);
        return false;
    }

    bool Direct3DInitialize(IDirect3DDevice9* lpDevice) override
    {
        UNREFERENCED_PARAMETER(lpDevice);
        return false;
    }
    void Direct3DRelease(void) override { }
    void Direct3DPreReset(D3DPRESENT_PARAMETERS* pparams) override
    {
        UNREFERENCED_PARAMETER(pparams);
    }
    void Direct3DPostReset(D3DPRESENT_PARAMETERS* pparams) override
    {
        UNREFERENCED_PARAMETER(pparams);
    }
    void Direct3DBeginScene(void) override { }
    void Direct3DEndScene(void) override { }
    void Direct3DPrePresent(const RECT* pSourceRect, const RECT* pDestRect, HWND hDestWindowOverride, const RGNDATA* pDirtyRegion) override
    {
        UNREFERENCED_PARAMETER(pSourceRect);
        UNREFERENCED_PARAMETER(pDestRect);
        UNREFERENCED_PARAMETER(hDestWindowOverride);
        UNREFERENCED_PARAMETER(pDirtyRegion);
    }
    void Direct3DPostPresent(const RECT* pSourceRect, const RECT* pDestRect, HWND hDestWindowOverride, const RGNDATA* pDirtyRegion) override
    {
        UNREFERENCED_PARAMETER(pSourceRect);
        UNREFERENCED_PARAMETER(pDestRect);
        UNREFERENCED_PARAMETER(hDestWindowOverride);
        UNREFERENCED_PARAMETER(pDirtyRegion);
    }
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Plugin Export Functions
//
// Functions that your plugin is expected to export in order to properly load.
//
///////////////////////////////////////////////////////////////////////////////////////////////////

typedef double      /**/(__stdcall *fGetInterfaceVersion)(void);
typedef void        /**/(__stdcall *fCreatePluginInfo)(plugininfo_t* info);
typedef IPlugin*    /**/(__stdcall *fCreatePlugin)(void);

#endif // __PLUGIN_H_INCLUDED__