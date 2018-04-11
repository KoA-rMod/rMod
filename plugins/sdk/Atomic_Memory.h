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

// ReSharper disable CppInconsistentNaming
// ReSharper disable CppRedundantQualifier

#ifndef __ATOMIC_SDK_ATOMIC_MEMORY_H_INCLUDED__
#define __ATOMIC_SDK_ATOMIC_MEMORY_H_INCLUDED__

#include <Windows.h>
#include <algorithm>
#include <sstream>
#include <vector>

namespace Atomic
{
    namespace Memory
    {
        /**
         * Iteratable object to reduce the overhead of using a vector.
         */
        template<typename T>
        struct scannableiterator_t
        {
            uintptr_t m_BaseAddress;
            uintptr_t m_BaseSize;

            scannableiterator_t(const uintptr_t base, const uintptr_t size)
                : m_BaseAddress(base), m_BaseSize(size)
            { }
            scannableiterator_t(const scannableiterator_t&) = delete;

            T* begin(void) { return (T*)this->m_BaseAddress; }
            T* end(void) { return (T*)(this->m_BaseAddress + this->m_BaseSize); }
        };
        
        /**
         * Finds a pattern within the given range of data.
         *
         * @param {uintptr_t} baseAddress - The address of the data to begin searching within.
         * @param {uintptr_t} baseSize - The size of the data to search within.
         * @param {const char*} pattern - The pattern to search for.
         * @param {intptr_t} offset - The offset from the found location to add to the pointer.
         * @param {uintptr_t} count - The result count to use if the pattern is found more than once.
         * @returns {uintptr_t} The address where the pattern was located, 0 otherwise.
         */
        static uintptr_t FindPattern(const uintptr_t baseAddress, const uintptr_t baseSize, const char* pattern, const intptr_t offset, const uintptr_t count)
        {
            // Convert the pattern to a vector of data..
            std::vector<std::pair<uint8_t, bool>> vpattern;
            for (size_t x = 0, y = (strlen(pattern) / 3) + 1; x < y; x++)
            {
                // Obtain the current byte..
                std::stringstream stream(std::string(pattern + (x * 3), 2));

                // Check if this is a wildcard..
                if (stream.str() == "??")
                    vpattern.push_back(std::make_pair(00, false));
                else
                {
                    const auto byte = strtol(stream.str().c_str(), nullptr, 16);
                    vpattern.push_back(std::make_pair((uint8_t)byte, true));
                }
            }

            // Create a scanner object to use with the STL functions..
            scannableiterator_t<uint8_t> data(baseAddress, baseSize);
            auto scanStart = data.begin();
            auto result = (uintptr_t)0;

            while (true)
            {
                // Search for the pattern..
                auto ret = std::search(scanStart, data.end(), vpattern.begin(), vpattern.end(),
                    [&](uint8_t curr, std::pair<uint8_t, bool> currPattern)
                {
                    return !currPattern.second || curr == currPattern.first;
                });

                // Did we find a match..
                if (ret != data.end())
                {
                    // If we hit the usage count, return the result..
                    if (result == count || count == 0)
                        return (std::distance(data.begin(), ret) + baseAddress) + offset;

                    // Increment the found count and scan again..
                    ++result;
                    scanStart = ++ret;
                }
                else
                    break;
            }

            return 0;
        }

        /**
         * Obtains the calling module handle for the given address.
         *
         * @param {uintptr_t} returnAddress - The address to locate the module owner of.
         * @returns {HMODULE} The module handle if found, nullptr otherwise.
         */
        static HMODULE __stdcall GetCallingModule(const uintptr_t returnAddress)
        {
            if (returnAddress == 0)
                return nullptr;

            MEMORY_BASIC_INFORMATION mbi = { nullptr };
            if (::VirtualQuery((LPCVOID)returnAddress, &mbi, sizeof(MEMORY_BASIC_INFORMATION)) == sizeof(MEMORY_BASIC_INFORMATION))
                return (HMODULE)mbi.AllocationBase;

            return nullptr;
        }

        /**
         * Hooks a VTable function and overrides it with the given new function pointer.
         *
         * @param {uintptr_t} ptrVTable - The VTable pointer.
         * @param {uint32_t} index - The index of the function to hook.
         * @param {uintptr_t} ptrNewFunction - The pointer to the new function to replace with.
         * @returns {uintptr_t} The original function pointer on success, 0 otherwise.
         */
        static uintptr_t HookVTableFunc(const uintptr_t ptrVTable, const uint32_t index, uintptr_t ptrNewFunction)
        {
            const auto ptr = (uint8_t*)(ptrVTable + index * sizeof(uint32_t));
            auto old = *(uintptr_t**)ptr;

            // Prepare the overwrite buffer..
            char buffer[4] = { 0 };
            memcpy(buffer, (uint8_t*)&ptrNewFunction, 4);

            // Prepare the memory space..
            DWORD oldProtect;
            if (!::VirtualProtect(ptr, 4, PAGE_EXECUTE_READWRITE, &oldProtect))
                return 0;

            // Write the new VTable pointer..
            ::InterlockedExchange((volatile LONG*)ptr, *(LONG*)&buffer);

            // Restore the memory protection..
            ::VirtualProtect(ptr, 4, oldProtect, &oldProtect);

            // Return the original pointer..
            return (uintptr_t)old;
        }

        /**
         * Writes a block of data to the given address. (Handles protections automatically.)
         *
         * @param {uintptr_t} address - The address to write the data to.
         * @param {uint8_t*} data - The data to be written.
         * @param {uint32_t} size - The amount of data to write.
         * @returns {bool} True on success, false otherwise.
         */
        static bool WriteMem(const uintptr_t address, uint8_t* data, const uint32_t size)
        {
            // Adjust the memory protection..
            DWORD oldProtect = 0;
            if (!::VirtualProtect((uint8_t*)address, size, PAGE_EXECUTE_READWRITE, &oldProtect))
                return false;

            // Write the data to memory..
            memcpy((uint8_t*)address, data, size);

            // Restore the memory protection..
            ::VirtualProtect((uint8_t*)address, size, oldProtect, &oldProtect);

            return true;
        }

        /**
         * Patches the original function by replacing the original data with a call to the given cave.
         *
         * @param {uintptr_t} origFuncAddress - The original function address to patch.
         * @param {uintptr_t} caveFuncAddress - The cave function to be called.
         * @param {uint32_t} nopCount - The amount of nops to place to cleanup old data.
         * @param {uint8_t**} backupOutput - Pointer to a variable to store the backup data at.
         * @returns {uint32_t} Return address to where code can jump back after the patch, 0 if failed.
         */
        static uint32_t CaveCall(const uintptr_t origFuncAddress, const uintptr_t caveFuncAddress, const uint32_t nopCount, uint8_t** backupOutput)
        {
            // Calculate the code cave offset..
            auto offset = caveFuncAddress - origFuncAddress - 5;

            // Create the jump to the cave..
            uint8_t call[0x05] = { 0xE8, 0x00, 0x00, 0x00, 0x00 };
            memcpy(call + 1, &offset, 4);

            // Backup the original code..
            *backupOutput = new uint8_t[0x05 + nopCount];
            memcpy(*backupOutput, (uint8_t*)origFuncAddress, 0x05 + nopCount);

            // Prepare the nop array..
            uint8_t nops[0xFF] = { 0 };
            memset(nops, 0x90, nopCount);

            // Write the call..
            WriteMem(origFuncAddress, call, 0x05);

            // Write any nops if needed..
            if (nopCount > 0)
                WriteMem(origFuncAddress + 5, nops, nopCount);

            // Calculate the return address..
            return origFuncAddress + 0x05 + nopCount;
        }

        /**
         * Restores a cave call placement by writing back the original data.
         *
         * @param {uintptr_t} origFuncAddress - The original function address to restore.
         * @param {uint8_t**} backup - Pointer to the backup data to restore.
         * @param {uint32_t} size - The amount of data in the backup to restore.
         */
        static void RestoreCaveCall(const uintptr_t origFuncAddress, uint8_t** backup, const uint32_t size)
        {
            // Restore the original function data..
            WriteMem(origFuncAddress, *backup, size);
        }
    }; // namespace Memory
}; // namespace Atomic

#endif // __ATOMIC_SDK_ATOMIC_MEMORY_H_INCLUDED__