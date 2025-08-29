//
// free.cpp
//
//      Copyright (c) Microsoft Corporation. All rights reserved.
//
// Implementation of free().
//
#include <corecrt_internal.h>
#include <malloc.h>

// Frees a block in the heap.  The 'block' pointer must either be a null pointer
// or must point to a valid block in the heap.
extern "C" void __cdecl free(void* const block)
{
    #ifdef _DEBUG
    _free_dbg(block, _NORMAL_BLOCK);
    #else
    _free_base(block);
    #endif
}
