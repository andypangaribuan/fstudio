/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

import 'package:fstudio/enums/e_visibility.dart';
import 'package:flutter/widgets.dart';

class FSimpleVisibility extends StatelessWidget {
  final Widget child;
  final EVisibility visibility;

  const FSimpleVisibility({
    Key? key,
    required this.visibility,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (visibility) {
      case EVisibility.visible:
        return child;
      case EVisibility.invisible:
        return Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: child,
        );
      case EVisibility.gone:
        return Visibility(
          visible: false,
          child: child,
        );
    }
  }
}
