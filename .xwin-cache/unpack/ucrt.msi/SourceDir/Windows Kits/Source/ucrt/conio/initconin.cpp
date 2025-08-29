//
// initconin.cpp
//
//      Copyright (c) Microsoft Corporation. All rights reserved.
//
// Defines the global console input handle and the __dcrt_lowio_initialize_console_output() and
// __termconout() functions, which initialize and close that handle.
//
#include <corecrt_internal_lowio.h>



_CRT_LINKER_FORCE_INCLUDE(__dcrt_console_input_terminator);


// The global console output handle.
//
// These definitions cause this file to be linked in if one of the direct
// console I/O functions is referenced.  The value -1 is used to indicate the
// uninitialized state.
extern "C" intptr_t __dcrt_lowio_console_input_handle = -2;



// Initializes the global console input handle
extern "C" void __cdecl __dcrt_lowio_initialize_console_input()
{
    __dcrt_lowio_console_input_handle = reinterpret_cast<intptr_t>(CreateFileW(
        L"CONIN$",
        GENERIC_READ | GENERIC_WRITE,
        FILE_SHARE_READ | FILE_SHARE_WRITE,
        nullptr,
        OPEN_EXISTING,
        0,
        nullptr));
}



// Closes the global console input handle
extern "C" void __cdecl __dcrt_terminate_console_input()
{
    if (__dcrt_lowio_console_input_handle != -1 && __dcrt_lowio_console_input_handle != -2)
    {
        CloseHandle(reinterpret_cast<HANDLE>(__dcrt_lowio_console_input_handle));
    }
}
