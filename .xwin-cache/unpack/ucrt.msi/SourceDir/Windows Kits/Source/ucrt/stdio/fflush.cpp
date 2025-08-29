//
// fflush.cpp
//
//      Copyright (c) Microsoft Corporation.  All rights reserved.
//
// Defines fflush() and related functions, which flush stdio streams.
//
#include <corecrt_internal_stdio.h>



// Values passed to common_flush_all() to distinguish between _flushall() and
// fflush(nullptr) behavior:
#define FLUSHALL   1
#define FFLUSHNULL 0



// Internal implementation of the "flush all" functionality.  Two modes are
// supported:  FLUSHALL, in which all streams are flushed and the return value
// is the number of streams that were flushed, and FFLUSHNULL, in which only
// write streams are flushed and the return value is zero on success; EOF on
// failure.
extern "C" static int __cdecl common_flush_all(int const flush_mode)
{
    int count = 0;
    int error = 0;

   __acrt_lock(__acrt_stdio_index_lock);
   __try
   {
       __crt_stdio_stream_data** const first_file = __piob;
       __crt_stdio_stream_data** const last_file  = first_file + _nstream;

       for (__crt_stdio_stream_data** it = first_file; it != last_file; ++it)
       {
           __crt_stdio_stream const stream(*it);

           if (!stream.valid())
               continue;

           _lock_file(stream.public_stream());
           __try
           {
               // Re-check that the stream is in use, now that we hold the lock:
               if (!stream.is_in_use())
                   __leave;

               // If the FLUSHALL mode was requested we fflush the read or write
               // stream and, if successful, update the count of flushed streams:
               if (flush_mode == FLUSHALL)
               {
                   if (_fflush_nolock(stream.public_stream()) != EOF)
                       ++count;
               }
               // Otherwise, if we are in FFLUSHNULL mode, we flush only write
               // streams and keep track of the error state:
               else if (flush_mode == FFLUSHNULL && stream.has_all_of(_IOWRITE))
               {
                   if (_fflush_nolock(stream.public_stream()) == EOF)
                       error = EOF;
               }
           }
           __finally
           {
               _unlock_file(stream.public_stream());
           }
       }
    }
    __finally
    {
        __acrt_unlock(__acrt_stdio_index_lock);
    }

    return flush_mode == FLUSHALL ? count : error;
}



// Flushes the buffer of the given stream.  If the file is open for writing and
// is buffered, the buffer is flushed.  On success, returns 0.  On failure (e.g.
// if there is an error writing the buffer), returns EOF and sets errno.
extern "C" int __cdecl fflush(FILE* const stream)
{
    // If the stream is null, flush all the streams:
    if (stream == nullptr)
        return common_flush_all(FFLUSHNULL);

    int return_value = 0;

    _lock_file(stream);
    __try
    {
        return_value = _fflush_nolock(stream);
    }
    __finally
    {
        _unlock_file(stream);
    }

    return return_value;
}



extern "C" int __cdecl _fflush_nolock(FILE* const public_stream)
{
    __crt_stdio_stream const stream(public_stream);

    // If the stream is null, flush all the streams.
    if (!stream.valid())
        return common_flush_all(FFLUSHNULL);

    if (__acrt_stdio_flush_nolock(stream.public_stream()) != 0)
    {
        // If the flush fails, do not attempt to commit:
        return EOF;
    }

    // Perform the lowio commit to ensure data is written to disk:
    if (stream.has_all_of(_IOCOMMIT))
    {
        if (_commit(_fileno(public_stream)))
            return EOF;
    }

    return 0;
}



// Flushes the buffer of the given stream.  If the file is open for writing and
// is buffered, the buffer is flushed.  On success, returns 0.  On failure (e.g.
// if there is an error writing the buffer), returns EOF and sets errno.
extern "C" int __cdecl __acrt_stdio_flush_nolock(FILE* const public_stream)
{
    __crt_stdio_stream const stream(public_stream);

    if ((stream.get_flags() & (_IOREAD | _IOWRITE)) != _IOWRITE)
        return 0;

    if (!stream.has_big_buffer())
        return 0;

    int const bytes_to_write = static_cast<int>(stream->_ptr - stream->_base);

    __acrt_stdio_reset_buffer(stream);

    if (bytes_to_write <= 0)
        return 0;

    int const bytes_written = _write(_fileno(stream.public_stream()), stream->_base, bytes_to_write);
    if (bytes_to_write != bytes_written)
    {
        stream.set_flags(_IOERROR);
        return EOF;
    }

    // If this is a read/write file, clear _IOWRITE so that the next operation can
    // be a read:
    if (stream.has_all_of(_IOUPDATE))
        stream.unset_flags(_IOWRITE);

    return 0;
}



// Flushes the buffers for all output streams and clears all input buffers.
// Returns the number of open streams.
extern "C" int __cdecl _flushall()
{
    return common_flush_all(FLUSHALL);
}
