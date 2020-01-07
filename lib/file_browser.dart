import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:file_browser/browser_view.dart';
import 'package:file_browser/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileBrowser {
  static const MethodChannel _channel = const MethodChannel('file_browser');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void openDocument(BuildContext context) async {
    if (Platform.isAndroid) {
      _exploreFileOnAndroid(context);
    } else if (Platform.isIOS) {
      _exploreFileOnIos();
    }
  }

  static void _exploreFileOnIos() async {
    FileBrowserPickerParams params = FileBrowserPickerParams();
    String filePath =
        await _channel.invokeMethod('pickDocument', params?.toJson());
    debugPrint(filePath);
  }

  static void _exploreFileOnAndroid(BuildContext context) {
    Future<void> getSDCardDir() async {
      Common().sDCardDir = (await getExternalStorageDirectory()).path;
    }

    // Permission check
    Future<void> getPermission() async {
      if (Platform.isAndroid) {
        PermissionStatus permission = await PermissionHandler()
            .checkPermissionStatus(PermissionGroup.storage);
        if (permission != PermissionStatus.granted) {
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
        }
        await getSDCardDir();
      } else if (Platform.isIOS) {
        await getSDCardDir();
      }
    }

    Future.wait([initializeDateFormatting("zh_CN", null), getPermission()])
        .then((result) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return FileBrowserView();
      }));
    });
  }
}

class FileBrowserPickerParams {
  /// In iOS Uniform Type Identifiers is used to check document types.
  /// If list is null or empty "public.data" document type will be provided.
  /// Only documents with provided UTI types will be enabled in iOS document picker.
  ///
  /// More info:
  /// https://developer.apple.com/library/archive/qa/qa1587/_index.html
  final List<String> allowedUtiTypes;

  /// List of file extensions that picked file should have.
  /// If list is null or empty - picked document extension will not be checked.
  final List<String> allowedFileExtensions;

  /// Android only. Allowed MIME types.
  /// Only files with provided MIME types will be shown in document picker.
  /// If list is null or empty - */* MIME type will be used.
  final List<String> allowedMimeTypes;

  /// List symbols that will be sanitized to '_' in the selected document name.
  /// I.e. Google Drive allows symbol '/' in the document name,
  /// but  this symbol is not allowed in file name that will be saved locally.
  /// Default list: ['/'].
  /// Example: file name 'Report_2018/12/08.txt' will be replaced to 'Report_2018_12_08.txt'
  final List<String> invalidFileNameSymbols;

  FileBrowserPickerParams({
    this.allowedUtiTypes,
    this.allowedFileExtensions,
    this.allowedMimeTypes,
    this.invalidFileNameSymbols = const ['/'],
  });

  Map<String, dynamic> toJson() {
    return {
      'allowedUtiTypes': allowedUtiTypes,
      'allowedFileExtensions': allowedFileExtensions,
      'allowedMimeTypes': allowedMimeTypes,
      'invalidFileNameSymbols': invalidFileNameSymbols,
    };
  }
}
