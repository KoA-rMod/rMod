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

#ifndef __ATOMIC_SDK_ATOMIC_COMMANDPARSE_H_INCLUDED__
#define __ATOMIC_SDK_ATOMIC_COMMANDPARSE_H_INCLUDED__

#if defined (_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

#include <Windows.h>
#include <string>
#include <vector>

/**
 * Helper Macros For Command Handling
 */
#ifndef HANDLECOMMAND
#define HANDLECOMMAND_GA(arg1, arg2, arg3, arg4, arg5, arg6, ...) arg6
#define HANDLECOMMAND_01(a)             Atomic::CommandHandler::__command_parse(args[0].c_str(), a)
#define HANDLECOMMAND_02(a, b)          Atomic::CommandHandler::__command_parse(args[0].c_str(), a, b)
#define HANDLECOMMAND_03(a, b, c)       Atomic::CommandHandler::__command_parse(args[0].c_str(), a, b, c)
#define HANDLECOMMAND_04(a, b, c, d)    Atomic::CommandHandler::__command_parse(args[0].c_str(), a, b, c, d)
#define HANDLECOMMAND_05(a, b, c, d, e) Atomic::CommandHandler::__command_parse(args[0].c_str(), a, b, c, d, e)
#define HANDLECOMMAND_CC(...)           HANDLECOMMAND_GA(__VA_ARGS__, HANDLECOMMAND_05, HANDLECOMMAND_04, HANDLECOMMAND_03, HANDLECOMMAND_02, HANDLECOMMAND_01,)
#define HANDLECOMMAND(...)              if (args.size() > 0 && HANDLECOMMAND_CC(__VA_ARGS__)(__VA_ARGS__))
#endif

namespace Atomic
{
    namespace CommandHandler
    {
        /**
         * Compares two strings against each other.
         *
         * @param {const char*} cmd - The first string to compare. (Usually the command.)
         * @param {const char*} arg1 - The second string to compare.
         * @returns {bool} True if strings match, arg5alse otherwise.
         */
        static bool __forceinline __command_cmp(const char* cmd, const char* arg1)
        {
            if (cmd == nullptr || arg1 == nullptr)
                return false;
            return (_stricmp(cmd, arg1) == 0);
        }

        /**
         * Compares the first argument (command) to the others for a match.
         *
         * @param {T} cmd - The command to compare again.
         * @param {T} arg1 - Argument to match command to.
         * @returns {bool} True on match, false otherwise.
         */
        template<typename T>
        static bool __command_parse(T cmd, T arg1)
        {
            return __command_cmp(cmd, arg1);
        }

        /**
         * Compares the first argument (command) to the others for a match.
         *
         * @param {T} cmd - The command to compare again.
         * @param {T} arg1 - Argument to match command to.
         * @param {T} arg2 - Argument to match command to.
         * @returns {bool} True on match, false otherwise.
         */
        template<typename T>
        static bool __command_parse(T cmd, T arg1, T arg2)
        {
            return __command_cmp(cmd, arg1) || __command_cmp(cmd, arg2);
        }

        /**
         * Compares the first argument (command) to the others for a match.
         *
         * @param {T} cmd - The command to compare again.
         * @param {T} arg1 - Argument to match command to.
         * @param {T} arg2 - Argument to match command to.
         * @param {T} arg3 - Argument to match command to.
         * @returns {bool} True on match, false otherwise.
         */
        template<typename T>
        static bool __command_parse(T cmd, T arg1, T arg2, T arg3)
        {
            return __command_cmp(cmd, arg1) || __command_cmp(cmd, arg2) || __command_cmp(cmd, arg3);
        }

        /**
         * Compares the first argument (command) to the others for a match.
         *
         * @param {T} cmd - The command to compare again.
         * @param {T} arg1 - Argument to match command to.
         * @param {T} arg2 - Argument to match command to.
         * @param {T} arg3 - Argument to match command to.
         * @param {T} arg4 - Argument to match command to.
         * @returns {bool} True on match, false otherwise.
         */
        template<typename T>
        static bool __command_parse(T cmd, T arg1, T arg2, T arg3, T arg4)
        {
            return __command_cmp(cmd, arg1) || __command_cmp(cmd, arg2) || __command_cmp(cmd, arg3) || __command_cmp(cmd, arg4);
        }

        /**
         * Compares the first argument (command) to the others for a match.
         *
         * @param {T} cmd - The command to compare again.
         * @param {T} arg1 - Argument to match command to.
         * @param {T} arg2 - Argument to match command to.
         * @param {T} arg3 - Argument to match command to.
         * @param {T} arg4 - Argument to match command to.
         * @param {T} arg5 - Argument to match command to.
         * @returns {bool} True on match, false otherwise.
         */
        template<typename T>
        static bool __command_parse(T cmd, T arg1, T arg2, T arg3, T arg4, T arg5)
        {
            return __command_cmp(cmd, arg1) || __command_cmp(cmd, arg2) || __command_cmp(cmd, arg3) || __command_cmp(cmd, arg4) || __command_cmp(cmd, arg5);
        }
    }; // namespace CommandHandler

    namespace Commands
    {
        /**
         * isspace replacement to avoid CRT asserts.
         *
         * @param {char} szChar - Character to check for space.
         * @returns {bool} True if a whitespace char is found, arg5alse otherwise.
         */
        static __forceinline bool _isspace(const char c)
        {
            const auto num = (int)c;

            // Checks for the following: ' ', \t \n \v \f \r
            if (num == 0x20 || num == 0x09 || num == 0x0A || num == 0x0B || num == 0x0C || num == 0x0D)
                return true;
            return false;
        }

        /**
         * Parses the given command for arguments.
         *
         * @param {const char*} pszCommand - The command to parse for arguments.
         * @param {std::vector<std::string>*} args - Pointer to an array of std::string to hold the found arguments.
         * @returns {int} Returns the number of found arguments, if any.
         *
         *
         * @note    This function mimics the *nix command 'strsep' to locate and parse strings with
         *          inline-quotes. Thanks to the following for the basis of this function:
         *
         * http://stackoverflow.com/questions/9659697/parse-string-into-array-based-on-spaces-or-double-quotes-strings
         */
        static int GetCommandArgs(const char* pszCommand, std::vector<std::string>* args)
        {
            // The current parsing state we are in..
            enum { NONE, IN_WORD, IN_STRING } state = NONE;

            char szCurrentArgument[255] = { 0 };
            auto p = pszCommand;
            char *pszStart = nullptr;

            // Walk the string to locate arguments..
            for (; *p != 0; ++p)
            {
                // Obtain the current character.. 
                const auto currChar = (char)*p;

                // Handle the current state..
                switch (state)
                {
                case NONE:
                    if (Atomic::Commands::_isspace(currChar))
                        continue;
                    if (currChar == '"')
                    {
                        state = IN_STRING;
                        pszStart = (char*)p + 1;
                        continue;
                    }
                    state = IN_WORD;
                    pszStart = (char*)p;
                    continue;

                case IN_STRING:
                    if (currChar == '"')
                    {
                        strncpy_s(szCurrentArgument, pszStart, p - pszStart);
                        args->push_back(std::string(szCurrentArgument));
                        state = NONE;
                        pszStart = nullptr;
                    }
                    continue;

                case IN_WORD:
                    if (Atomic::Commands::_isspace(currChar))
                    {
                        strncpy_s(szCurrentArgument, pszStart, p - pszStart);
                        args->push_back(std::string(szCurrentArgument));
                        state = NONE;
                        pszStart = nullptr;
                    }
                    continue;
                }
            }

            // Add any left-over words..
            if (pszStart != nullptr)
            {
                strncpy_s(szCurrentArgument, pszStart, p - pszStart);
                args->push_back(std::string(szCurrentArgument));
            }

            // Return the number of found arguments..
            return args->size();
        }
    }; // namespace CommandHandler
}; // namespace Atomic

#endif // __ATOMIC_SDK_ATOMIC_COMMANDPARSE_H_INCLUDED__