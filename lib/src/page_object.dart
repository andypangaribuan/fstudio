/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

part of ff;

class _FPageObject<T extends FPageLogic> {
  late T logic;
  final _getObjects = HashMap<GetObjectType, Object? Function()>();
  _FPageState? _state;

  _FPageObject._();

  Object? getObject(GetObjectType type) {
    for (var kv in _getObjects.entries) {
      if (kv.key == type) {
        return kv.value();
      }
    }
    return null;
  }
}
