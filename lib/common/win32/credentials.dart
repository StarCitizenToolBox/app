// Copyright (c) 2020, Dart | Windows.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Reads and writes credentials

import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:win32/win32.dart';


class Win32Credentials {
  static void write(
      {required String credentialName,
      required String userName,
      required String password}) {
    final examplePassword = utf8.encode(password);
    final blob = examplePassword.allocatePointer();

    final credential = calloc<CREDENTIAL>()
      ..ref.Type = CRED_TYPE_GENERIC
      ..ref.TargetName = credentialName.toNativeUtf16()
      ..ref.Persist = CRED_PERSIST_LOCAL_MACHINE
      ..ref.UserName = userName.toNativeUtf16()
      ..ref.CredentialBlob = blob
      ..ref.CredentialBlobSize = examplePassword.length;

    final result = CredWrite(credential, 0);

    if (result != TRUE) {
      final errorCode = GetLastError();
      dPrint('Error ($result): $errorCode');
      return;
    }
    dPrint('Success (blob size: ${credential.ref.CredentialBlobSize})');

    free(blob);
    free(credential);
  }

  static MapEntry<String, String>? read(String credentialName) {
    dPrint('Reading $credentialName ...');
    final credPointer = calloc<Pointer<CREDENTIAL>>();
    final result = CredRead(
        credentialName.toNativeUtf16(), CRED_TYPE_GENERIC, 0, credPointer);
    if (result != TRUE) {
      final errorCode = GetLastError();
      var errorText = '$errorCode';
      if (errorCode == ERROR_NOT_FOUND) {
        errorText += ' Not found.';
      }
      dPrint('Error ($result): $errorText');
      return null;
    }
    final cred = credPointer.value.ref;
    final blob = cred.CredentialBlob.asTypedList(cred.CredentialBlobSize);
    final password = utf8.decode(blob);
    CredFree(credPointer.value);
    free(credPointer);
    return MapEntry(cred.UserName.toDartString(), password);
  }

  static void delete(String credentialName) {
    dPrint('Deleting $credentialName');
    final result =
        CredDelete(credentialName.toNativeUtf16(), CRED_TYPE_GENERIC, 0);
    if (result != TRUE) {
      final errorCode = GetLastError();
      dPrint('Error ($result): $errorCode');
      return;
    }
    dPrint('Successfully deleted credential.');
  }
}
