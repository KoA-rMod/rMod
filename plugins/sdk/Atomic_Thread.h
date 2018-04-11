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

#ifndef __ATOMIC_SDK_ATOMIC_THREAD_H_INCLUDED__
#define __ATOMIC_SDK_ATOMIC_THREAD_H_INCLUDED__

#include <Windows.h>
#include "Atomic_Event.h"

namespace Atomic
{
    namespace Threading
    {
        /**
         * Thread Priority Enumeration
         */
        enum ThreadPriorty
        {
            Lowest = -2,
            BelowNormal = -1,
            Normal = 0,
            AboveNormal = 1,
            Highest = 2
        };

        class Atomic_Thread
        {
            HANDLE          m_ThreadHandle; // The thread handle of this object.
            DWORD           m_ThreadId;     // The thread id of this object.
            Atomic_Event    m_StartEvent;   // The starting event of this thread.
            Atomic_Event    m_EndEvent;     // The ending event of this thread.

        public:
            /**
             * Constructor
             */
            Threading::Atomic_Thread(void)
                : m_ThreadHandle(nullptr), m_ThreadId(0), m_StartEvent(true), m_EndEvent(true)
            { }

            /**
             * Deconstructor
             */
            virtual Atomic_Thread::~Atomic_Thread(void)
            {
                if (this->m_ThreadHandle != nullptr)
                    this->Stop();
            }

        public:
            /**
             * Virtual thread entry point to be overriden.
             */
            virtual DWORD Atomic_ThreadEntry(void) = 0;

            /**
             * Internal thread entry point to be invoked.
             */
            DWORD InternalEntry(void)
            {
                // Ensure we are valid..
                if (this->IsTerminated())
                    return 0;

                // Adjust events accordingly..
                this->m_EndEvent.Reset();
                ::Sleep(10);
                this->m_StartEvent.Raise();

                // Call the real entry point..
                return this->Atomic_ThreadEntry();
            }

            /**
             * Starts this thread object.
             */
            void Start(void)
            {
                // Start the thread..
                this->m_StartEvent.Reset();
                this->m_ThreadHandle = CreateThread(nullptr, NULL, ThreadCallback, (LPVOID)this, NULL, &this->m_ThreadId);
            }

            /**
             * Stops this thread object.
             */
            void Stop(void)
            {
                // Stop the thread..
                this->RaiseEnd();

                if (this->WaitForFinish(INFINITE))
                {
                    ::CloseHandle(this->m_ThreadHandle);
                    this->m_ThreadHandle = nullptr;
                    this->m_ThreadId = 0;
                }
            }

            /**
             * Waits for this thread object to finish executing.
             *
             * @param {DWORD} dwMilliseconds - The time in milliseconds to wait for the thread to finish.
             * @returns {bool} True on success, false otherwise.
             */
            bool WaitForFinish(const DWORD milliseconds = INFINITE) const
            {
                if (this->m_ThreadHandle == nullptr)
                    return false;
                return (::WaitForSingleObject(this->m_ThreadHandle, milliseconds) != WAIT_TIMEOUT);
            }

            /**
             * Sets the threads priority.
             *
             * @param {ThreadPriority} priority - The priority to set the thread to.
             */
            void SetPriority(const ThreadPriorty priority) const
            {
                ::SetThreadPriority(this->m_ThreadHandle, priority);
            }

            /**
             * Gets the priority of the thread.
             *
             * @returns {int} The priority id of the thread.
             */
            int GetPriority(void) const
            {
                return ::GetThreadPriority(this->m_ThreadHandle);
            }

            /**
             * Raises the end event for the thread.
             */
            void RaiseEnd(void) const
            {
                this->m_EndEvent.Raise();
            }

            /**
             * Resets the end event for the thread.
             */
            void ResetEnd(void) const
            {
                this->m_EndEvent.Reset();
            }

            /**
             * Returns if the thread is terminated or not.
             *
             * @returns {bool} True if terminated, false otherwise.
             */
            bool IsTerminated(void) const
            {
                return this->m_EndEvent.IsSignaled();
            }

        public:
            /**
             * Gets the thread handle.
             *
             * @returns {HANDLE} The current thread handle.
             */
            HANDLE GetHandle(void) const
            {
                return this->m_ThreadHandle;
            }

            /**
             * Gets the thread id.
             *
             * @returns {DWORD} The current thread id.
             */
            DWORD GetId(void) const
            {
                return this->m_ThreadId;
            }

            /**
             * Gets the thread exit code.
             *
             * @returns {DWORD} The current thread exit code.
             */
            DWORD GetExitCode(void) const
            {
                if (this->m_ThreadHandle == nullptr)
                    return 0;

                DWORD dwExitCode = 0;
                ::GetExitCodeThread(this->m_ThreadHandle, &dwExitCode);
                return dwExitCode;
            }

        private:
            /**
             * The threading callback handler to invoke the internal entrypoint of the thread.
             *
             * @param {LPVOID} lpParam - The param of this thread. (Atomic_Thread object.)
             * @returns {DWORD} The return of the internal thread entry points function.
             */
            static DWORD __stdcall ThreadCallback(const LPVOID lpParam)
            {
                auto thread = (Atomic_Thread*)lpParam;
                return thread->InternalEntry();
            }
        };
    }; // namespace Threading
}; // namespace Atomic

#endif // __ATOMIC_SDK_ATOMIC_THREAD_H_INCLUDED__