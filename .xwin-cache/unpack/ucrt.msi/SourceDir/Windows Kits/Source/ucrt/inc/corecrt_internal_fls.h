//
// corecrt_internal_fls.h
//
//      Copyright (c) Microsoft Corporation. All rights reserved.
//
// CoreCRT Internals
//
#pragma once

_CRT_BEGIN_C_HEADER

DWORD WINAPI __acrt_FlsAlloc(
    _In_opt_ PFLS_CALLBACK_FUNCTION lpCallback
    );

BOOL WINAPI __acrt_FlsFree(
    _In_ DWORD dwFlsIndex
    );

PVOID WINAPI __acrt_FlsGetValue(
    _In_ DWORD dwFlsIndex
    );

BOOL WINAPI __acrt_FlsSetValue(
    _In_     DWORD dwFlsIndex,
    _In_opt_ PVOID lpFlsData
    );

_CRT_END_C_HEADER
