/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

library ff.pipe;

import 'dart:async';

import 'package:fstudio/fstudio.dart';
import 'package:fstudio/stream-builder/stream_builder.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

part 'pipe_model.dart';

class FPipe<T> {
  final _pipe = BehaviorSubject<T>();
  BehaviorSubject<FPipeErrModel>? _errPipe;

  /// dynamic holder
  final holder = <String, dynamic>{};

  ValueStream<T> get stream {
    return _pipe.stream;
  }

  late T _lastValue;
  T get value {
    if (textEditingController != null) {
      return textEditingController!.text as T;
    }

    if (_pipe.hasValue) {
      return _pipe.value;
    }
    if (ff.func.isGenericTypeNullable<T>()) {
      return null as T;
    }
    return _pipe.value;
  }

  late T _lastSubscribeValue;

  FPipeErrModel get errValue {
    return _errPipe!.value;
  }

  final _subscriptionListeners = <String, void Function(T val)>{};
  var skipSubscription = 0;
  var _disposed = false;

  TextEditingController? textEditingController;
  StreamSubscription? _eventSubscription;

  FPipe({
    required T initValue,
    required FDisposer disposer,
    bool withTextEditingController = false,
    bool withErrPipe = false,
  }) {
    disposer.register(dispose);

    _lastValue = initValue;
    _lastSubscribeValue = initValue;
    if (initValue != null) {
      update(initValue);

      if (initValue is String && withTextEditingController) {
        textEditingController = TextEditingController(text: initValue)..addListener(_textEditingControllerListener);
      }
    }

    if (withErrPipe) {
      final model = FPipeErrModel._((value) => errUpdate(value));
      _errPipe = BehaviorSubject<FPipeErrModel>()..sink.add(model);
    }
  }

  void _safePipeSinkAdd(T value) {
    if (_lastValue != value) {
      _lastValue = value;
      _pipe.sink.add(value);
    }
  }

  Widget onUpdate(Widget Function(T val) listener) {
    return _disposed
        ? Container()
        : StreamBuilder<T>(
            stream: _pipe.stream,
            initialData: value,
            builder: (context, snap) => listener(snap.data as T),
          );
  }

  Widget onErrUpdate(Widget Function(T val, FPipeErrModel err) listener) {
    return _disposed
        ? Container()
        : StreamBuilder<FPipeErrModel>(
            stream: _errPipe!.stream,
            initialData: _errPipe!.value,
            builder: (context, snap) => listener(value, snap.data!),
          );
  }

  Widget onUpdateWithErrUpdate(Widget Function(T val, FPipeErrModel err) listener) {
    return _disposed
        ? Container()
        : StreamBuilder2<T, FPipeErrModel>(
            streams: StreamTuple2(_pipe.stream, _errPipe!.stream),
            initialData: StreamInitialDataTuple2(_pipe.value, errValue),
            builder: (context, snap1, snap2) => listener(snap1.data as T, snap2.data!),
          );
  }

  void update(T value) {
    if (_disposed) {
      return;
    }

    if (textEditingController == null) {
      _pipe.sink.add(value);
      return;
    }

    if (ff.func.isTypeOf<T, String>()) {
      final text = value as String;
      textEditingController!
        ..text = text
        ..selection = TextSelection.collapsed(offset: text.length);
    }
  }

  void errUpdate(FPipeErrModel value) {
    if (_disposed) {
      return;
    }

    _errPipe!.sink.add(value);
  }

  void softUpdate(T val) {
    if (_disposed) {
      return;
    }

    if (value != val) {
      update(val);
    }
  }

  void subscribe({
    required void Function(T val) listener,
    int skippedCount = 0,
    FDisposer? disposer,
  }) {
    if (_disposed) {
      return;
    }

    final id = _generateId();
    _subscriptionListeners[id] = listener;
    disposer?.register(() => _subscriptionListeners.remove(id));
    skipSubscription = skippedCount < 0 ? 0 : skippedCount;
    _eventSubscription ??= _pipe.listen(_subscriptionEvent);
  }

  void _subscriptionEvent(T value) {
    if (_disposed) {
      return;
    }

    if (_lastSubscribeValue == value) {
      return;
    }
    _lastSubscribeValue = value;

    if (skipSubscription > 0) {
      skipSubscription--;
    } else {
      for (var listener in _subscriptionListeners.values) {
        listener(value);
      }
    }
  }

  void _textEditingControllerListener() {
    _safePipeSinkAdd(value);
  }

  void callSubscriber() {
    if (_disposed) {
      return;
    }

    _subscriptionEvent(value);
  }

  void forceCallSubscriber() {
    if (_disposed) {
      return;
    }

    for (var listener in _subscriptionListeners.values) {
      listener(value);
    }
  }

  String _generateId() => '${ff.func.randomChar(5)}${DateTime.now().millisecondsSinceEpoch}';

  @protected
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      _eventSubscription?.cancel();
      textEditingController?.dispose();
      _pipe.close();
      _errPipe?.close();
      _subscriptionListeners.clear();
    }
  }
}
