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
  DateTime? toDate(String format, String value) => this.format(format).toTime(value);

  _TimeUtil format(String format) => _TimeUtil()
    .._format = format
    .._isCustomFormat = true;
}

class _TimeUtil {
  static final mapDateFormat = <String, DateFormat>{};
  late String _format;
  bool _isCustomFormat = false;

  final _month3 = {
    "jan": "01",
    "feb": "02",
    "mar": "03",
    "apr": "04",
    "may": "05",
    "jun": "06",
    "jul": "07",
    "aug": "08",
    "sep": "09",
    "oct": "10",
    "nov": "11",
    "des": "12",
  };

  DateTime? toTime(String? dt) {
    if (dt == null) {
      return null;
    }

    if (_isCustomFormat) {
      dt = _reformatDtv(dt);
    }

    return DateTime.parse(dt.replaceAll("T", " ").replaceAll("Z", "").replaceAll("z", ""));
  }

  String _reformatDtv(String dt) {
    var dtv = '';
    var usedFormat = _format;

    var date = '';
    var time = '';
    var ms = '';
    
    if (usedFormat.contains('yyyy')) {
      final idx = usedFormat.indexOf('yyyy');
      date = dt.substring(idx, idx + 4);
    }

    if (usedFormat.contains('MMM')) {
      date += date.isNotEmpty ? '-' : '';
      final idx = usedFormat.indexOf('MMM');
      final m3 = dt.substring(idx, idx + 3).toLowerCase();
      date += _month3[m3] ?? '';
    } else if (usedFormat.contains('MM')) {
      date += date.isNotEmpty ? '-' : '';
      final idx = usedFormat.indexOf('MM');
      date += dt.substring(idx, idx + 2);
    }
    
    if (usedFormat.contains('dd')) {
      date += date.isNotEmpty ? '-' : '';
      final idx = usedFormat.indexOf('dd');
      date += dt.substring(idx, idx + 2);
    }

    if (usedFormat.contains('HH')) {
      final idx = usedFormat.indexOf('HH');
      time = dt.substring(idx, idx + 2);
    }
    
    if (usedFormat.contains('mm')) {
      time += time.isNotEmpty ? ':' : '';
      final idx = usedFormat.indexOf('mm');
      time += dt.substring(idx, idx + 2);
    }

    if (usedFormat.contains('ss')) {
      time += time.isNotEmpty ? ':' : '';
      final idx = usedFormat.indexOf('ss');
      time += dt.substring(idx, idx + 2);
    }

    if (usedFormat.contains('SSSSSS')) {
      final idx = usedFormat.indexOf('SSSSSS');
      ms = dt.substring(idx, idx + 6);
    } else if (usedFormat.contains('SSSSS')) {
      final idx = usedFormat.indexOf('SSSSS');
      ms = dt.substring(idx, idx + 5);
    } else if (usedFormat.contains('SSSS')) {
      final idx = usedFormat.indexOf('SSSS');
      ms = dt.substring(idx, idx + 4);
    } else if (usedFormat.contains('SSS')) {
      final idx = usedFormat.indexOf('SSS');
      ms = dt.substring(idx, idx + 3);
    } else if (usedFormat.contains('SS')) {
      final idx = usedFormat.indexOf('SS');
      ms = dt.substring(idx, idx + 2);
    } else if (usedFormat.contains('S')) {
      final idx = usedFormat.indexOf('S');
      ms = dt.substring(idx, idx + 1);
    }

    dtv = date;
    if (date.isNotEmpty && time.isNotEmpty) {
      dtv += ' $time';
    }

    if (time.isNotEmpty && ms.isNotEmpty) {
      dtv += '.$ms';
    }

    return dtv;
  }

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