//
// appcrt_dllmain.cpp
//
//      Copyright (c) Microsoft Corporation.  All rights reserved.
//
// The entry point for the AppCRT dynamic library.
//
#include <corecrt_internal.h>

#ifndef CRTDLL
    #error This file should only be built into the CRT DLLs
#endif

extern "C" { 

// Flag set iff DllMain was called with DLL_PROCESS_ATTACH
static int __acrt_process_attached = 0;

static __declspec(noinline) BOOL DllMainProcessAttach()
{
    if (!__vcrt_initialize())
        return FALSE;

    if (!__acrt_initialize())
    {
        __vcrt_uninitialize(TRUE);
        return FALSE;
    }

    // Increment flag indicating the process attach completed successfully:
    ++__acrt_process_attached;
    return TRUE;
}

static __declspec(noinline) BOOL DllMainProcessDetach(bool const terminating)
{
    // If there was no prior process attach or if it failed, return immediately:
    if (__acrt_process_attached <= 0)
        return FALSE;

    --__acrt_process_attached;
    if (!__acrt_uninitialize(terminating))
        return FALSE;

    // The VCRuntime is uninitialized during the AppCRT uninitialization; we do
    // not need to uninitialize it here.
    return TRUE;
}


#pragma optimize ("", off)
void __acrt_end_boot()
{
    // Do nothing.  This function is used to mark the end of the init process.
}
#pragma optimize ("", on)

BOOL WINAPI __acrt_DllMain(HINSTANCE, DWORD const fdwReason, LPVOID const lpReserved)
{
    if (fdwReason == DLL_PROCESS_ATTACH)
    {
        // The /GS security cookie must be initialized before any exception
        // handling targetting the current image is registered.  No function
        // using exception handling can be called in the current image until
        // after __security_init_cookie has been called.
        __security_init_cookie();
    }

    BOOL result = FALSE;
    switch (fdwReason)
    {
    case DLL_PROCESS_ATTACH:
        result = DllMainProcessAttach();
        break;

    case DLL_PROCESS_DETACH:
        result = DllMainProcessDetach(lpReserved != nullptr);
        break;

    case DLL_THREAD_ATTACH:
        result = __acrt_thread_attach() ? TRUE : FALSE;
        break;

    case DLL_THREAD_DETACH:
        result = __acrt_thread_detach() ? TRUE : FALSE;
        break;
    }

    __acrt_end_boot();
    return result;
}

} // extern "C"