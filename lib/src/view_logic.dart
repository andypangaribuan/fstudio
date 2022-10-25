/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

part of ff;

abstract class FViewLogic<T> {
  late T logic;
  final disposer = FDisposer();

  @protected
  void setLogic(T logic) {
    this.logic = logic;
  }

  // must call super.finish
  @protected
  void finish() {
    disposer._dispose();
  }
}
