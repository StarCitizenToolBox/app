//
// txtmode.cpp
//
//      Copyright (c) Microsoft Corporation. All rights reserved.
//
// Defines the global _fmode varibale and sets the global file mode to text.
// This is the default behavior.
//
#include <corecrt_internal.h>
#include <stdlib.h>

extern "C" int _fmode = 0;



extern "C" int* __cdecl __p__fmode()
{
    _BEGIN_SECURE_CRT_DEPRECATION_DISABLE
    return &_fmode;
    _END_SECURE_CRT_DEPRECATION_DISABLE
}
