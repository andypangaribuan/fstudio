/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

import 'package:fstudio/enums/e_visibility.dart';
import 'package:flutter/material.dart';

import 'simple_visibility.dart';

class FSimpleButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? splashColor;
  final Color? highlightColor;
  final double elevation;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final EVisibility visibility;
  final Widget? child;
  final VoidCallback? onTap;

  /// Rounded: const CircleBorder()
  /// Rounded Corner:
  ///   RoundedRectangleBorder(
  ///     borderRadius: BorderRadius.circular(10),
  ///     side: const BorderSide(width: 1, color: Colors.red),
  ///   )
  final ShapeBorder? shape;

  const FSimpleButton({
    Key? key,
    this.backgroundColor = Colors.transparent,
    this.splashColor,
    this.highlightColor,
    this.elevation = 0,
    this.width,
    this.height,
    this.margin = EdgeInsets.zero,
    this.padding,
    this.child,
    this.onTap,
    this.visibility = EVisibility.visible,
    this.shape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final splashColor = this.splashColor ?? Colors.white.withOpacity(0.75);
    Widget? child = this.child;
    if (child != null && padding != null) {
      child = Padding(padding: padding!, child: child);
    }
    if (child != null && (width != null || height != null)) {
      child = SizedBox(width: width, height: height, child: child);
    }

    return FSimpleVisibility(
      visibility: visibility,
      child: Card(
        shape: shape,
        color: backgroundColor,
        elevation: elevation,
        margin: margin,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: splashColor,
          highlightColor: highlightColor,
          child: child,
        ),
      ),
    );
  }
}
