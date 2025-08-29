//
// cputws.cpp
//
//      Copyright (c) Microsoft Corporation. All rights reserved.
//
// Defines _cputws(), which writes a wide string directly to the console.
//
#include <conio.h>
#include <errno.h>
#include <corecrt_internal_lowio.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>

// The console handle:
extern "C" extern intptr_t __dcrt_lowio_console_output_handle;



// Writes the given string directly to the console.  No newline is appended.
//
// Returns 0 on success; nonzero on failure.
extern "C" int __cdecl _cputws(wchar_t const* string)
{
    _VALIDATE_CLEAR_OSSERR_RETURN((string != nullptr), EINVAL, -1);

    if (__dcrt_lowio_console_output_handle == -2)
        __dcrt_lowio_initialize_console_output();

    if (__dcrt_lowio_console_output_handle == -1)
        return -1;

    // Write string to console file handle:
    ptrdiff_t length = wcslen(string);

    __acrt_lock(__acrt_conio_lock);

    int result = 0;

    __try
    {
        while (length > 0)
        {
            static size_t const max_write_bytes = 65535;
            static size_t const max_write_wchars = max_write_bytes / sizeof(wchar_t);

            DWORD const wchars_to_write = length > max_write_wchars 
                ? max_write_wchars
                : static_cast<DWORD>(length);

            DWORD wchars_written;
            if (!WriteConsoleW(reinterpret_cast<HANDLE>(__dcrt_lowio_console_output_handle),
                               string,
                               wchars_to_write,
                               &wchars_written,
                               nullptr))
            {
                result = -1;
                __leave;
            }

            string += wchars_to_write;
            length -= wchars_to_write;
        }
    }
    __finally
    {
        __acrt_unlock(__acrt_conio_lock);
    }

    return result;
}
