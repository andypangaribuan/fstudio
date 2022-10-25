/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

library fstudio;

import 'package:flutter/material.dart';

extension ObjectExt<T> on T {
  R let<R>(R Function(T it) op) => op(this);

  T also(void Function(T it) op) {
    op(this);
    return this;
  }
}

extension ContextExt on BuildContext {
  void dismissKeyboard() {
    final currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
