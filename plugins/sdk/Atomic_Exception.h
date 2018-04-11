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

#ifndef __ATOMIC_SDK_ATOMIC_EXCEPTION_H_INCLUDED__
#define __ATOMIC_SDK_ATOMIC_EXCEPTION_H_INCLUDED__

#if defined (_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

#include <Windows.h>
#include <cinttypes>
#include <eh.h>

namespace Atomic
{
    namespace Exception
    {
        /**
         * Define misssing STATUS code.
         */
#ifndef STATUS_POSSIBLE_DEADLOCK
#define STATUS_POSSIBLE_DEADLOCK 0xC0000194
#endif

        /**
         * Macro for translating exception defines to strings.
         */
#define CASE(Exception) \
    case Exception: \
        this->m_Exception = #Exception; \
        break;

        /**
         * Exception object that can obtain all exceptions.
         */
        class Atomic_Exception
        {
            unsigned int    m_ExceptionId;
            const char*     m_Exception;

        public:
            /**
             * Constructor
             */
            Atomic_Exception(const uint32_t id)
                : m_ExceptionId(id)
                , m_Exception(nullptr)
            {
                switch (this->m_ExceptionId)
                {
                    CASE(EXCEPTION_ACCESS_VIOLATION);
                    CASE(EXCEPTION_ARRAY_BOUNDS_EXCEEDED);
                    CASE(EXCEPTION_BREAKPOINT);
                    CASE(EXCEPTION_DATATYPE_MISALIGNMENT);
                    CASE(EXCEPTION_FLT_DENORMAL_OPERAND);
                    CASE(EXCEPTION_FLT_DIVIDE_BY_ZERO);
                    CASE(EXCEPTION_FLT_INEXACT_RESULT);
                    CASE(EXCEPTION_FLT_INVALID_OPERATION);
                    CASE(EXCEPTION_FLT_OVERFLOW);
                    CASE(EXCEPTION_FLT_STACK_CHECK);
                    CASE(EXCEPTION_FLT_UNDERFLOW);
                    CASE(EXCEPTION_GUARD_PAGE);
                    CASE(EXCEPTION_ILLEGAL_INSTRUCTION);
                    CASE(EXCEPTION_IN_PAGE_ERROR);
                    CASE(EXCEPTION_INT_DIVIDE_BY_ZERO);
                    CASE(EXCEPTION_INT_OVERFLOW);
                    CASE(EXCEPTION_INVALID_DISPOSITION);
                    CASE(EXCEPTION_INVALID_HANDLE);
                    CASE(EXCEPTION_NONCONTINUABLE_EXCEPTION);
                    CASE(EXCEPTION_POSSIBLE_DEADLOCK);
                    CASE(EXCEPTION_PRIV_INSTRUCTION);
                    CASE(EXCEPTION_SINGLE_STEP);
                    CASE(EXCEPTION_STACK_OVERFLOW);

                default:
                    this->m_Exception = "Unknown exception occurred.";
                    break;
                }
            }

            /**
             * Deconstructor
             */
            ~Atomic_Exception(void)
            { }

        public:
            /**
             * Gets the exception id of this exception object.
             *
             * @returns {unsigned int} The exception id of this object.
             */
            unsigned int GetExceptionId(void) const
            {
                return this->m_ExceptionId;
            }

            /**
             * Gets the exception string of this exception object.
             *
             * @returns {const char*} The exception string of this object.
             */
            const char* GetException(void) const
            {
                return this->m_Exception;
            }
        };

        /**
         * Scoped SEH translator class to automate custom exception filtering.
         */
        class ScopedTranslator
        {
            _se_translator_function m_Function;

        public:
            /**
             * Constructor
             */
            ScopedTranslator(void)
            {
                this->m_Function = ::_set_se_translator(&ScopedTranslator::ScopedTranslatorFunc);
            }

            /**
             * Deconstructor
             */
            ~ScopedTranslator(void)
            {
                if (this->m_Function != nullptr)
                {
                    ::_set_se_translator(this->m_Function);
                    this->m_Function = nullptr;
                }
            }

        private:
            /**
             * Exception filter used to rethrow the exception wrapped with our custom object.
             *
             * @param {uint32_t} id - The id of the exception being thrown.
             * @param {_EXCEPTION_POINTERS*} lpPtrs - The exception pointer structure.
             */
            static void ScopedTranslatorFunc(const uint32_t id, struct _EXCEPTION_POINTERS* lpPtrs)
            {
                // Rethrow this exception with our wrapper..
                UNREFERENCED_PARAMETER(lpPtrs);
                throw Atomic::Exception::Atomic_Exception(id);
            }
        };
    }; // namespace Exception
}; // namespace Atomic

#endif // __ATOMIC_SDK_ATOMIC_EXCEPTION_H_INCLUDED__