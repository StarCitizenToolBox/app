//
// malloc.cpp
//
//      Copyright (c) Microsoft Corporation. All rights reserved.
//
// Implementation of malloc().
//
#include <corecrt_internal.h>
#include <malloc.h>



// Allocates a block of memory of size 'size' bytes in the heap.  If allocation
// fails, nullptr is returned.
extern "C" _CRTRESTRICT void* __cdecl malloc(size_t const size)
{
    #ifdef _DEBUG
    return _malloc_dbg(size, _NORMAL_BLOCK, nullptr, 0);
    #else
    return _malloc_base(size);
    #endif
}
