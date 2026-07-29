String? extractRsiLauncherBundleHash(String bundlePath) {
  final normalizedPath = bundlePath.replaceAll(r'\', '/').replaceFirst(RegExp(r'^/+'), '');
  return RegExp(
    r'^(?:app/launcher/static/js/(?:main|index)|app/static/js/main)\.([a-f0-9]+)\.js$',
  ).firstMatch(normalizedPath)?.group(1);
}
