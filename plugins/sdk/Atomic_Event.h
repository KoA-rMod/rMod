/**
 * Atomic SDK - Copyright (c) 2014 - 2018 atom0s [atom0s@live.com]
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
 * Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
 *
 * By using Atomic SDK, you agree to the above license and its terms.
 *
 *      Attribution - You must give appropriate credit, provide a link to the license and indicate if changes were
 *                    made. You must do so in any reasonable manner, but not in any way that suggests the licensor
 *                    endorses you or your use.
 *
 *   Non-Commercial - You may not use the material (Atomic SDK) for commercial purposes.
 *
 *   No-Derivatives - If you remix, transform, or build upon the material (Atomic SDK), you may not distribute the
 *                    modified material. You are, however, allowed to submit the modified works back to the original
 *                    Atomic SDK project in attempt to have it added to the original project.
 *
 * You may not apply legal terms or technological measures that legally restrict others
 * from doing anything the license permits.
 *
 * No warranties are given.
 */

// ReSharper disable CppDefaultCaseNotHandledInSwitchStatement
// ReSharper disable CppInconsistentNaming
// ReSharper disable CppMemberFunctionMayBeStatic

#ifndef __ATOMIC_SDK_ATOMIC_EVENT_H_INCLUDED__
#define __ATOMIC_SDK_ATOMIC_EVENT_H_INCLUDED__

#if defined (_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

#include <Windows.h>

namespace Atomic
{
    namespace Threading
    {
        class Atomic_Event
        {
            HANDLE m_EventHandle;

        public:
            /**
             * Constructor and Deconstructor
             */
            Threading::Atomic_Event(const bool manualReset = true)
            {
                this->m_EventHandle = ::CreateEvent(nullptr, manualReset, FALSE, nullptr);
            }
            virtual Atomic_Event::~Atomic_Event(void)
            {
                if (this->m_EventHandle != nullptr)
                    ::CloseHandle(this->m_EventHandle);
                this->m_EventHandle = nullptr;
            }

        public:
            /**
             * Resets this event.
             *
             * @returns {bool} True on success, false otherwise.
             */
            bool Reset(void) const
            {
                return (::ResetEvent(this->m_EventHandle) ? true : false);
            }

            /**
             * Raises the event.
             *
             * @returns {bool} True on success, false otherwise.
             */
            bool Raise(void) const
            {
                return (::SetEvent(this->m_EventHandle) ? true : false);
            }

            /**
             * Determines if this event is signaled.
             *
             * @returns {bool} True if signaled, false otherwise.
             */
            bool IsSignaled(void) const
            {
                return (::WaitForSingleObject(this->m_EventHandle, 0) == WAIT_OBJECT_0);
            }

            /**
             * Waits for the event object with the given timeout.
             *
             * @param {DWORD} dwMilliseconds - The timeout to wait for the event.
             * @returns {bool} True on success, false otherwise.
             */
            bool WaitForEvent(const DWORD milliseconds) const
            {
                return (::WaitForSingleObject(this->m_EventHandle, milliseconds) == WAIT_OBJECT_0);
            }
        };
    }; // namespace Threading
}; // namespace Atomic

#endif // __ATOMIC_SDK_ATOMIC_EVENT_H_INCLUDED__