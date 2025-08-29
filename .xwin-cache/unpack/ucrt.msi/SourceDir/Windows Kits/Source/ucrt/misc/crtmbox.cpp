/***
*crtmbox.c - CRT MessageBoxA wrapper.
*
*       Copyright (c) Microsoft Corporation. All rights reserved.
*
*Purpose:
*       Wrap MessageBoxA.
*
*******************************************************************************/

#include <corecrt_internal.h>
#include <corecrt_internal_traits.h>



namespace
{
    template <typename Character>
    struct message_box_arguments
    {
        Character const* _caption;
        Character const* _text;
        unsigned int     _type;
        int              _result;
    };
}

template <typename Character>
static DWORD WINAPI message_box_wait_thread(void* const argument) throw()
{
    using traits = __crt_char_traits<Character>;

    auto const mb_arguments = static_cast<message_box_arguments<Character>*>(argument);

    mb_arguments->_result = traits::message_box(
        nullptr,
        mb_arguments->_text,
        mb_arguments->_caption,
        mb_arguments->_type);

    return 0;
}

template <typename Character>
static int __cdecl common_show_message_box(
    Character const* const text,
    Character const* const caption,
    unsigned         const type
    ) throw()
{
    using traits = __crt_char_traits<Character>;

    bool const is_packaged_app = __acrt_is_packaged_app();

    if (IsDebuggerPresent())
    {
        // Output the message to the attached debugger.  This is useful when
        // remotely debugging.
        if (text)
        {
            traits::output_debug_string(text);
        }

        // We do not want to display a message box for a packaged app if a debugger
        // is already attached.  Instead, let the caller know that we want to
        // directly break into the debugger:
        if (is_packaged_app)
        {
            return IDRETRY; // Retry = Break into the debugger
        }
    }

    if (!__acrt_can_show_message_box())
    {
        // If we can't get the message box pointers (perhaps because running on CoreSys),
        // just abort, unless a debugger is attached--then break into the debugger instead.
        // The message string was already output to the debugger above.
        return IsDebuggerPresent() ? IDRETRY : IDABORT;
    }

    // In packaged apps, display the message box in a separate thread and wait
    // for it to avoid deadlocking:
    if (is_packaged_app)
    {
        message_box_arguments<Character> arguments = { caption, text, type, 0 };

        __crt_unique_handle const worker_thread(CreateThread(
            nullptr,
            0,
            &message_box_wait_thread<Character>,
            &arguments,
            0,
            nullptr));

        if (!worker_thread)
        {
            return 0;
        }

        if (WaitForSingleObjectEx(worker_thread.get(), INFINITE, FALSE) != WAIT_OBJECT_0)
        {
            return 0;
        }

        return arguments._result;
    }

    // If the current process isn't attached to a visible window station (e.g.
    // a non-interactive service), then we need to set the MB_SERVICE_NOTIFICATION
    // flag, otherwise the message box will be invisible, hanging the program.
    if (!__acrt_is_interactive())
    {
        return traits::message_box(nullptr, text, caption, type | MB_SERVICE_NOTIFICATION);
    }

    return traits::message_box(__acrt_get_parent_window(), text, caption, type);
}

extern "C" int __cdecl __acrt_show_narrow_message_box(
    char const* const text,
    char const* const caption,
    unsigned    const type
    )
{
    return common_show_message_box(text, caption, type);
}

extern "C" int __cdecl __acrt_show_wide_message_box(
    wchar_t const* const text,
    wchar_t const* const caption,
    unsigned       const type
    )
{
    return common_show_message_box(text, caption, type);
}
