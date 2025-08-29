//
// putwch.cpp
//
//      Copyright (c) Microsoft Corporation. All rights reserved.
//
// Defines _putwch(), which writes a wide character to the console.
//
#include <conio.h>
#include <corecrt_internal_lowio.h>



extern "C" extern intptr_t __dcrt_lowio_console_output_handle;



// Writes a wide character to the console.  Returns the character on success,
// WEOF on failure.
extern "C" wint_t __cdecl _putwch(wchar_t const c)
{
    return __acrt_lock_and_call(__acrt_conio_lock, [&]
    {
        return _putwch_nolock(c);
    });
}



extern "C" wint_t __cdecl _putwch_nolock(wchar_t const c)
{
    if (__dcrt_lowio_console_output_handle == -2)
        __dcrt_lowio_initialize_console_output();

    if (__dcrt_lowio_console_output_handle == -1)
        return WEOF;

    // Write character to console:
    DWORD charsWritten;
    if (!WriteConsoleW(reinterpret_cast<HANDLE>(__dcrt_lowio_console_output_handle), &c, 1, &charsWritten, nullptr))
        return WEOF;

    return c;
}
