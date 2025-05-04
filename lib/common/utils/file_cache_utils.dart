import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';

class FileCacheUtils {
  // 存储正在进行的下载任务
  static final Map<String, Future<File>> _downloadingTasks = {};

  // 缓存目录
  static Directory? _cacheDir;

  /// 获取缓存目录
  static Future<Directory> _getCacheDirectory() async {
    if (_cacheDir != null) return _cacheDir!;

    final tempDir = await getTemporaryDirectory();
    _cacheDir = Directory(path.join(tempDir.path, 'ScToolbox_File_Cache'));

    if (!await _cacheDir!.exists()) {
      await _cacheDir!.create(recursive: true);
    }

    return _cacheDir!;
  }

  /// 从URL获取文件，如果已经在下载中，则共享同一个下载任务
  static Future<File> getFile(String url) async {
    // 如果已经在下载中，直接返回正在进行的下载任务
    if (_downloadingTasks.containsKey(url)) {
      return _downloadingTasks[url]!;
    }

    final fileTask = _downloadFile(url);
    _downloadingTasks[url] = fileTask;

    try {
      final file = await fileTask;
      return file;
    } finally {
      // 无论成功失败，下载完成后从任务列表中移除
      _downloadingTasks.remove(url);
    }
  }

  /// 实际进行下载的方法
  static Future<File> _downloadFile(String url) async {
    // 生成文件名 (使用URL的MD5哈希作为文件名)
    final filename = md5.convert(utf8.encode(url)).toString();
    final cacheDir = await _getCacheDirectory();
    final file = File(path.join(cacheDir.path, filename));

    // 检查文件是否已经存在
    if (await file.exists()) {
      return file;
    }

    // 下载文件
    final response = await RSHttp.get(url);

    if (response.statusCode == 200) {
      await file.writeAsBytes(response.data ?? []);
      return file;
    } else {
      throw Exception('Failed to download file: ${response.statusCode}');
    }
  }

  /// 清除特定URL的缓存
  static Future<bool> clearCache(String url) async {
    try {
      final filename = md5.convert(utf8.encode(url)).toString();
      final cacheDir = await _getCacheDirectory();
      final file = File(path.join(cacheDir.path, filename));

      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 清除所有缓存
  static Future<void> clearAllCache() async {
    try {
      final cacheDir = await _getCacheDirectory();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        await cacheDir.create();
      }
    } catch (e) {
      debugPrint('清除缓存失败: $e');
    }
  }
}
