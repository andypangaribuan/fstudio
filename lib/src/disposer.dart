/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

part of ff;

class FDisposer {
  final _funcs = <void Function()>[];

  FDisposer();

  void register(void Function() dispose) {
    _funcs.add(dispose);
  }

  void _dispose() {
    for (var dispose in _funcs) {
      dispose();
    }
    _funcs.clear();
  }
}
