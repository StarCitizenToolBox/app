typedef MicrosoftStoreRestrictionPrompt = Future<bool?> Function();
typedef MicrosoftStoreInstallAction = Future<void> Function();

/// Allows a Microsoft Store-only feature to continue without prompting only
/// when the current build is the Store version.
Future<bool> guardMicrosoftStoreOnlyFeature({
  required bool isMicrosoftStoreVersion,
  required MicrosoftStoreRestrictionPrompt showRestriction,
  required MicrosoftStoreInstallAction installMicrosoftStoreVersion,
}) async {
  if (isMicrosoftStoreVersion) return true;
  if (await showRestriction() == true) {
    await installMicrosoftStoreVersion();
  }
  return false;
}
