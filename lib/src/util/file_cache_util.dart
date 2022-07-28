import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart' as pp;

/// 缓存在文件的管理器
class FileCacheUtil {
  /// 缓存的文件名
  String? _filePath;
  String? _fileName;
  FileCacheUtil.filePath(String filePath) : _filePath = filePath;
  FileCacheUtil.fileName(String fileName) : _fileName = fileName;

  /// 加载缓存内容
  Future<String?> loadCacheContent() async {
    String cacheFilePath = await cachceFilePath();
    return compute(_loadCache, cacheFilePath);
  }

  static Future<String?> _loadCache(String cacheFilePath) async {
    File file = File(cacheFilePath);
    bool isExit = await file.exists();
    if (!isExit) {
      return null;
    }
    return file.readAsString();
  }

  /// 写入缓存内容
  Future<void> saveCacheContent(String content) async {
    if (content.isEmpty) {
      return;
    }
    String cacheFilePath = await cachceFilePath();
    await compute(_saveCacheContent, SaveCacheContent(cacheFilePath, content));
  }

  static Future<void> _saveCacheContent(SaveCacheContent content) async {
    File file = File(content.cacheFilePath);
    await file.writeAsString(content.content);
    return;
  }

  /// 获取缓存的文件路径
  Future<String> cachceFilePath() async {
    if (_filePath != null) {
      return _filePath!;
    }
    Directory directory = await pp.getApplicationDocumentsDirectory();
    return "${directory.path}/$_fileName";
  }

  /// 创建一个目录 如果存在则直接返回操作
  /// - `directoryPath`: 基于`Document`的目录比如`cache/user`
  /// 返回真正的目录
  static Future<String> createDirectory(String directoryPath) async {
    Directory documentDirectory = await pp.getApplicationDocumentsDirectory();
    directoryPath = "${documentDirectory.path}$directoryPath";
    Directory directory = Directory(directoryPath);
    await directory.create(recursive: true);
    return directory.path;
  }

  Future<void> delete() async {
    String cacheFilePath = await cachceFilePath();
    File file = File(cacheFilePath);
    await file.delete();
  }
}

class SaveCacheContent {
  final String cacheFilePath;
  final String content;
  SaveCacheContent(this.cacheFilePath, this.content);
}
