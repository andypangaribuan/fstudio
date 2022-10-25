/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class FSizeMeasure extends SingleChildRenderObjectWidget {
  final void Function(Size size) onChange;

  const FSizeMeasure({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _FSizeMeasureRenderObject(onChange, () => context);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderObject renderObject) {
    super.updateRenderObject(context, renderObject);
    if (renderObject is _FSizeMeasureRenderObject) {
      if (renderObject.hasSize) {
        double screenWidth = MediaQuery.of(context).size.width;
        if (renderObject.screenWidth == screenWidth) {
          onChange(renderObject.size);
        }
        renderObject.screenWidth = screenWidth;
      }
    }
  }
}

class _FSizeMeasureRenderObject extends RenderProxyBox {
  Size? oldSize;
  double? screenWidth;
  final void Function(Size size) onChange;
  final BuildContext Function() context;

  _FSizeMeasureRenderObject(this.onChange, this.context);

  @override
  void performLayout() {
    screenWidth = MediaQuery.of(context()).size.width;

    onChange(const Size(-1, -1));
    super.performLayout();

    Size newSize = child!.size;
    if (oldSize == newSize) {
      onChange(newSize);
      return;
    }

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}
