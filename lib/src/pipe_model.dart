/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

part of ff.pipe;

class FPipeErrModel {
  bool isError = false;
  bool get isNotError => !isError;
  String? message;
  Object? _object;
  final Function(FPipeErrModel value) _doUpdate;

  FPipeErrModel? _lastModel;

  FPipeErrModel._(this._doUpdate);

  T object<T>() {
    return _object as T;
  }

  void setError(String message, {Object? object}) {
    isError = true;
    this.message = message;
    _object = object;
  }

  void update() {
    _doUpdate(this);
  }

  void softUpdate() {
    if (_lastModel?.isError == isError && _lastModel?.message == message && _lastModel?._object == _object) {
      return;
    }
    _lastModel = this;
    _doUpdate(this);
  }
}
