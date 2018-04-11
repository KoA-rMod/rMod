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

#ifndef __ATOMIC_SDK_ATOMIC_LOCKABLEOBJECT_H_INCLUDED__
#define __ATOMIC_SDK_ATOMIC_LOCKABLEOBJECT_H_INCLUDED__

#include <Windows.h>

namespace Atomic
{
    namespace Threading
    {
        class Atomic_LockableObject
        {
            CRITICAL_SECTION m_CriticalSection;

            /**
             * Disables the copy constructor.
             */
            Atomic_LockableObject(const Atomic_LockableObject& obj) = delete;

        public:
            /**
             * Constructor
             */
            Threading::Atomic_LockableObject(void)
            {
                ::InitializeCriticalSection(&this->m_CriticalSection);
            }

            /**
             * Deconstructor
             */
            virtual Atomic_LockableObject::~Atomic_LockableObject(void)
            {
                ::DeleteCriticalSection(&this->m_CriticalSection);
            }

        public:
            /**
             * Locks the critical section of this object.
             */
            void Lock(void)
            {
                ::EnterCriticalSection(&this->m_CriticalSection);
            }

            /**
             * Unlocks the critical section of this object.
             */
            void Unlock(void)
            {
                ::LeaveCriticalSection(&this->m_CriticalSection);
            }
        };
    }; // namespace Threading
}; // namespace Atomic

#endif // __ATOMIC_SDK_ATOMIC_LOCKABLEOBJECT_H_INCLUDED__