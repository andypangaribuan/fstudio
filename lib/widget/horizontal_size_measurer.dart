/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

import 'package:fstudio/src/pipe.dart';
import 'package:flutter/widgets.dart';

import 'size_measure.dart';

/// FPipe must be persistent (initialize from FPageLogic)
/// FPipe.holder used to save value "isHaveSize"
class FHorizontalSizeMeasurer {
  static const holderKey = 'f-horizontal-size-measurer';

  final FPipe<double> pipe;
  final double widgetHeight;
  final bool visible;

  set _isHaveSize(bool value) {
    pipe.holder[holderKey] = value;
  }

  FHorizontalSizeMeasurer({
    required this.pipe,
    this.widgetHeight = 1,
    this.visible = false,
  });

  SingleChildRenderObjectWidget items(void Function(FHorizontalSizeMeasurerItems e) fn) {
    _isHaveSize = false;
    pipe.update(-1);

    final e = FHorizontalSizeMeasurerItems._();
    fn(e);

    Widget getWidget(List<dynamic> ls) {
      Widget widget = ls[0];
      bool isFittedBox = ls[1];

      if (!visible) {
        widget = SizedBox(height: widgetHeight, child: widget);
      }
      if (isFittedBox) {
        widget = FittedBox(child: widget);
      }
      return widget;
    }

    // Measure size all widget with height = 1
    // Wrap will stack vertically if width not enough
    // Not visible but still take the space of parent
    return FSizeMeasure(
        onChange: (size) {
          _isHaveSize = size.height != -1;
          pipe.update(size.height);
        },
        child: Visibility(
          visible: visible,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            children: [for (var item in e._items) getWidget(item)],
          ),
        ));
  }
}

class FHorizontalSizeMeasurerItems {
  final List<List<dynamic>> _items = [];

  FHorizontalSizeMeasurerItems._();

  void add({required Widget widget, bool fittedBox = false}) {
    _items.add([widget, fittedBox]);
  }
}
