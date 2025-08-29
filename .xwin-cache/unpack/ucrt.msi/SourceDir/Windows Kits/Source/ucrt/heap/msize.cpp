//
// msize.cpp
//
//      Copyright (c) Microsoft Corporation. All rights reserved.
//
// Implementation of msize().
//
#include <corecrt_internal.h>
#include <malloc.h>



#ifndef _DEBUG
// This function implements the logic of _msize().  It is called only in the
// Release CRT.  The Debug CRT has its own implementation of this function.
static size_t __cdecl _msize_base(void* const block) throw()
{
    // Validation section
    _VALIDATE_RETURN(block != nullptr, EINVAL, static_cast<size_t>(-1));

    return static_cast<size_t>(HeapSize(__acrt_heap, 0, block));
}
#endif

// Calculates the size of the specified block in the heap.  'block' must be a
// pointer to a valid block of heap-allocated memory (it must not be nullptr).
extern "C" size_t __cdecl _msize(void* const block)
{
    #ifdef _DEBUG
    return _msize_dbg(block, _NORMAL_BLOCK);
    #else
    return _msize_base(block);
    #endif
}
