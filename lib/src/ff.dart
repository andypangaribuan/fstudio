/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

library f_guide;

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io' show Platform;
import 'dart:math';
import 'package:fstudio/fstudio.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/ecb.dart';
import 'package:pointycastle/padded_block_cipher/padded_block_cipher_impl.dart';
import 'package:pointycastle/paddings/pkcs7.dart';

part 'func/crypto.dart';
part 'func/func.dart';

final ff = _FF._();

class _FF {
  _FF._();

  final _logger = _Logger._();

  final crypto = _Crypto._();
  final func = _Func._();
  final time = _Time._();
  final cast = _Cast._();

  /*
  * install "grep console" plugin for android studio or intellij ide
  * in your console, click "pen icon" with white and red color on left top corner
  * click button "new group", give the name "ff"
  * add the expressions:
  * - .*─.*
  * - .*│.*
  * set the background color: #004444
  * set the foreground color: #FFFFFF
  * tick only on: whole line, continue matching, background and foreground
  **/
  void log(List<String> messages) => _logger.log(messages);

  void print(Object? object) => _logger.printLog(object);
}

var __osPlatform = OSPlatform.nil;
OSPlatform get _osPlatform {
  if (__osPlatform == OSPlatform.nil) {
    if (Platform.isAndroid) {
      __osPlatform = OSPlatform.android;
    }
    if (Platform.isIOS) {
      __osPlatform = OSPlatform.ios;
    }
  }
  return __osPlatform;
}

//region LOGGER
class _Logger {
  _Logger._();

  static final _deviceStackTraceRegex = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');
  static final _webStackTraceRegex = RegExp(r'^((packages|dart-sdk)\/[^\s]+\/)');

  void log(List<String> messages) => developer.log(_getLogMessage(messages));

  void printLog(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }

  String _getLogMessage(List<String> messages) {
    int maxLength = 0;
    final arr = <String>[];
    arr.add("      ${ff.time.millis.toStr(DateTime.now())}");
    maxLength = arr[0].length;

    final mc = _methodCaller(StackTrace.current);
    if (mc != null) {
      final m = "│ ▶ $mc";
      arr.add(m);
      if (m.length > maxLength) {
        maxLength = m.length;
      }
    }

    for (var msg in messages) {
      final m = "│ ◈ $msg";
      arr.add(m);
      if (m.length > maxLength) {
        maxLength = m.length;
      }
    }
    maxLength += 3;

    // characters: https://en.wikipedia.org/wiki/List_of_Unicode_characters
    var log = "";
    for (int i = 0; i < arr.length; i++) {
      if (i == 0) {
        var ch = "${_addChar("${arr[i]} ", "─", maxLength - 1)}┐";
        log += ch.trim();
      } else if (arr[i].contains("│ ▶ ")) {
        log += "${_addChar("\n${arr[i]} ", " ", maxLength)}│";
      } else {
        final ch = arr[i];
        final chs = ch.split("\n");
        for (var c in chs) {
          final first = c.contains("│ ◈ ") ? "\n" : "\n│   ";
          log += "${_addChar("$first$c ", " ", maxLength)}│";
        }
      }
    }
    log += "\n${_addChar("└", "─", maxLength - 1)}┘";

    return log;
  }

  String _addChar(String value, String ch, int maxLength) {
    var v = value;
    while (true) {
      if (v.length >= maxLength) {
        break;
      }
      v += ch;
    }
    return v;
  }

  String? _methodCaller(StackTrace stackTrace) {
    var lines = stackTrace.toString().split('\n');
    var formatted = <String>[];
    var count = 0;
    var methodCount = 1;
    var skip = 3;

    for (var line in lines) {
      if (_discardDeviceStacktraceLine(line) || _discardWebStacktraceLine(line)) {
        continue;
      }

      if (skip > 0) {
        skip--;
      } else {
        formatted.add(line.replaceFirst(RegExp(r'#\d+\s+'), ''));
        if (++count == methodCount) {
          break;
        }
      }
    }

    if (formatted.isNotEmpty) {
      return formatted[0];
    }
    return null;
  }

  bool _discardDeviceStacktraceLine(String line) {
    var match = _deviceStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }

    return match.group(2)?.startsWith('package:logger') ?? false;
  }

  bool _discardWebStacktraceLine(String line) {
    var match = _webStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }

    var v1 = match.group(1)?.startsWith('package:logger') ?? false;
    var v2 = match.group(1)?.startsWith('dart-sdk/lib') ?? false;
    return v1 || v2;
  }
}
//endregion

//region TIME
class _Time {
  _Time._();

  final _util = _TimeUtil();

  final date = _TimeUtil().._format = "yyyy-MM-dd";
  final time = _TimeUtil().._format = "HH:mm:ss";
  final dt = _TimeUtil().._format = "yyyy-MM-dd HH:mm:ss";
  final millis = _TimeUtil().._format = "yyyy-MM-dd HH:mm:ss.SSS";
  final micros = _TimeUtil().._format = "yyyy-MM-dd HH:mm:ss.SSSSSS";

  DateTime get now => DateTime.now();
  DateTime get nowUtc => DateTime.parse(DateTime.now().toUtc().toString().replaceAll("Z", "").replaceAll("z", ""));

  String toStr(String format, DateTime dt) => _util._toStr(format, dt);
}

class _TimeUtil {
  static final mapDateFormat = <String, DateFormat>{};
  late String _format;

  DateTime? toTime(String? dt) => dt == null ? null : DateTime.parse(dt.replaceAll("T", " ").replaceAll("Z", "").replaceAll("z", ""));

  String? toStr(DateTime? dt) => dt == null ? null : _toStr(_format, dt);

  String _toStr(String format, DateTime dt) {
    final msCount = countMs(format);
    if (msCount == 0) {
      if (!mapDateFormat.containsKey(format)) {
        mapDateFormat[format] = DateFormat(format);
      }
      return mapDateFormat[format]!.format(dt);
    }

    final date = dt.toIso8601String().replaceAll("T", " ").replaceAll("Z", "").replaceAll("z", "");
    final arr = date.split(".");
    var ms = "";
    if (arr.length == 2) {
      ms = arr[1];
    }

    if (ms.length > msCount) {
      ms = ms.substring(0, msCount);
    }

    while (true) {
      if (ms.length == msCount) {
        break;
      }
      ms += "0";
    }

    return "${arr[0]}.$ms";
  }

  int countMs(String format) {
    var msCount = 0;

    final fs = format.split(".");
    if (fs.length == 2) {
      final f = fs[1];
      for (int i = 0; i < f.length; i++) {
        final ch = f.substring(i, i + 1);
        if (ch == "S") {
          msCount++;
        }
      }
    }

    return msCount;
  }
}
//endregion TIME

//region CAST
class _Cast {
  _Cast._();

  double? optDouble(dynamic obj, {double? ifNullValue}) {
    if (obj == null) {
      if (ifNullValue != null) {
        return ifNullValue;
      }
      return null;
    }

    if (obj is double) {
      return obj;
    }
    if (obj is int) {
      return obj.toDouble();
    }
    if (obj is String) {
      String val = obj;
      if (val.isEmpty) {
        if (ifNullValue != null) {
          return ifNullValue;
        }
        return null;
      }

      return double.parse(val);
    }

    return null;
  }
}
//endregion CAST