/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

library ff.page_transition;

import 'package:flutter/material.dart';

import 'enum.dart';

part 'page_transition_holder.dart';

class FPageTransition<T> extends PageRouteBuilder<T> {
  /// Child for your next page
  final Widget child;

  // ignore: public_member_api_docs
  final PageTransitionsBuilder matchingBuilder;

  /// Child for your next page
  final Widget? childCurrent;

  /// Transition types
  /// - fade, rightToLeft, leftToRight, upToDown, downToUp
  /// - scale, rotate, size, rightToLeftWithFade, leftToRightWithFade
  final FPageTransitionType type;

  /// Curves for transitions
  final Curve curve;

  /// Alignment for transitions
  final Alignment? alignment;

  /// Duration for your transition default is 300 ms
  final Duration duration;

  /// Duration for your pop transition default is 300 ms
  final Duration reverseDuration;

  /// Context for inherit theme
  final BuildContext? ctx;

  /// Optional inherit theme
  final bool inheritTheme;

  /// Optional fullscreen dialog mode
  final bool isFullscreenDialog;

  final bool isOpaque;

  // ignore: public_member_api_docs
  final bool isIos;

  late FPageTransitionHolder holder;

  /// Page transition constructor. We can pass the next page as a child,
  FPageTransition({
    Key? key,
    required this.child,
    required this.type,
    this.childCurrent,
    this.ctx,
    this.inheritTheme = false,
    this.curve = Curves.linear,
    this.alignment,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration = const Duration(milliseconds: 300),
    this.isFullscreenDialog = false,
    this.isOpaque = false,
    this.isIos = false,
    this.matchingBuilder = const CupertinoPageTransitionsBuilder(),
    RouteSettings? settings,
  })  : assert(inheritTheme ? ctx != null : true, "'ctx' adalah cannot be null when 'inheritTheme' is true, set ctx: context"),
        super(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
            return inheritTheme ? InheritedTheme.captureAll(ctx!, child) : child;
          },
          settings: settings,
          maintainState: true,
          opaque: isOpaque,
          fullscreenDialog: isFullscreenDialog,
        ) {
    holder = FPageTransitionHolder._(pageTransition: () => this);
  }

  @override
  Duration get transitionDuration => duration;

  @override
  // ignore: public_member_api_docs
  Duration get reverseTransitionDuration => reverseDuration;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (!holder.animationEnabled) {
      return child;
    }

    final animate = holder
        ._buildAnimation(
          context: () => context,
          animation: () => animation,
          secondaryAnimation: () => secondaryAnimation,
          child: () => child,
        )
        .exec;

    switch (type) {
      case FPageTransitionType.theme:
        return Theme.of(context).pageTransitionsTheme.buildTransitions(this, context, animation, secondaryAnimation, child);

      case FPageTransitionType.fade:
        return animate(
          animation: FadeTransition(opacity: animation, child: child),
        );

      /// PageTransitionType.rightToLeft which is the give us right to left transition
      case FPageTransitionType.rightToLeft:
        // var slideTransition = SlideTransition(
        //   position: Tween<Offset>(
        //     begin: const Offset(1, 0),
        //     end: Offset.zero,
        //   ).animate(animation),
        //   child: child,
        // );

        return animate(
          animation: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );

      // return !isIos
      //     ? slideTransition
      //     : matchingBuilder.buildTransitions(this, context, animation, secondaryAnimation, child);

      /// PageTransitionType.leftToRight which is the give us left to right transition
      case FPageTransitionType.leftToRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
        // ignore: dead_code
        break;

      /// PageTransitionType.topToBottom which is the give us up to down transition
      case FPageTransitionType.topToBottom:
        if (isIos) {
          var topBottom = SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
          return matchingBuilder.buildTransitions(this, context, animation, secondaryAnimation, topBottom);
        }
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
        // ignore: dead_code
        break;

      /// PageTransitionType.downToUp which is the give us down to up transition
      case FPageTransitionType.bottomToTop:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
        // ignore: dead_code
        break;

      /// PageTransitionType.scale which is the scale functionality for transition you can also use curve for this transition
      case FPageTransitionType.scale:
        assert(alignment != null, """
                When using type "scale" you need argument: 'alignment'
                """);
        if (isIos) {
          var scale = ScaleTransition(
            alignment: alignment!,
            scale: animation,
            child: child,
          );
          return matchingBuilder.buildTransitions(this, context, animation, secondaryAnimation, scale);
        }
        return ScaleTransition(
          alignment: alignment!,
          scale: CurvedAnimation(
            parent: animation,
            curve: Interval(
              0.00,
              0.50,
              curve: curve,
            ),
          ),
          child: child,
        );
        // ignore: dead_code
        break;

      /// PageTransitionType.rotate which is the rotate functionality for transition you can also use alignment for this transition
      case FPageTransitionType.rotate:
        assert(alignment != null, """
                When using type "RotationTransition" you need argument: 'alignment'
                """);
        return RotationTransition(
          alignment: alignment!,
          turns: animation,
          child: ScaleTransition(
            alignment: alignment!,
            scale: animation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        );
        // ignore: dead_code
        break;

      /// PageTransitionType.size which is the rotate functionality for transition you can also use curve for this transition
      case FPageTransitionType.size:
        assert(alignment != null, """
                When using type "size" you need argument: 'alignment'
                """);
        return Align(
          alignment: alignment!,
          child: SizeTransition(
            sizeFactor: CurvedAnimation(
              parent: animation,
              curve: curve,
            ),
            child: child,
          ),
        );
        // ignore: dead_code
        break;

      /// PageTransitionType.rightToLeftWithFade which is the fade functionality from right o left
      case FPageTransitionType.rightToLeftWithFade:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
        );
        // ignore: dead_code
        break;

      /// PageTransitionType.leftToRightWithFade which is the fade functionality from left o right with curve
      case FPageTransitionType.leftToRightWithFade:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: curve,
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
        );
        // ignore: dead_code
        break;

      case FPageTransitionType.rightToLeftJoined:
        assert(childCurrent != null, """
                When using type "rightToLeftJoined" you need argument: 'childCurrent'
                example:
                  child: MyPage(),
                  childCurrent: this
                """);
        return Stack(
          children: <Widget>[
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.0),
                end: const Offset(-1.0, 0.0),
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
              ),
              child: childCurrent,
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
              ),
              child: child,
            )
          ],
        );
        // ignore: dead_code
        break;

      case FPageTransitionType.leftToRightJoined:
        assert(childCurrent != null, """
                When using type "leftToRightJoined" you need argument: 'childCurrent'
                example:
                  child: MyPage(),
                  childCurrent: this
                """);
        return Stack(
          children: <Widget>[
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: const Offset(0.0, 0.0),
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
              ),
              child: child,
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.0),
                end: const Offset(1.0, 0.0),
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
              ),
              child: childCurrent,
            )
          ],
        );
        // ignore: dead_code
        break;

      case FPageTransitionType.topToBottomJoined:
        assert(childCurrent != null, """
                When using type "topToBottomJoined" you need argument: 'childCurrent'
                example:
                  child: MyPage(),
                  childCurrent: this
                """);
        return Stack(
          children: <Widget>[
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, -1.0),
                end: const Offset(0.0, 0.0),
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
              ),
              child: child,
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.0),
                end: const Offset(0.0, 1.0),
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
              ),
              child: childCurrent,
            )
          ],
        );
        // ignore: dead_code
        break;

      case FPageTransitionType.bottomToTopJoined:
        assert(childCurrent != null, """
                When using type "bottomToTopJoined" you need argument: 'childCurrent'
                example:
                  child: MyPage(),
                  childCurrent: this
                """);
        return Stack(
          children: <Widget>[
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: const Offset(0.0, 0.0),
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
              ),
              child: child,
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.0),
                end: const Offset(0.0, -1.0),
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
              ),
              child: childCurrent,
            )
          ],
        );
        // ignore: dead_code
        break;

      case FPageTransitionType.rightToLeftPop:
        assert(childCurrent != null, """
                When using type "rightToLeftPop" you need argument: 'childCurrent'
                example:
                  child: MyPage(),
                  childCurrent: this
                """);
        return Stack(
          children: <Widget>[
            child,
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.0),
                end: const Offset(-1.0, 0.0),
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
              ),
              child: childCurrent,
            ),
          ],
        );
        // ignore: dead_code
        break;

      case FPageTransitionType.leftToRightPop:
        assert(childCurrent != null, """
                When using type "leftToRightPop" you need argument: 'childCurrent'
                example:
                  child: MyPage(),
                  childCurrent: this
                """);
        return Stack(
          children: <Widget>[
            child,
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.0),
                end: const Offset(1.0, 0.0),
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
              ),
              child: childCurrent,
            )
          ],
        );
        // ignore: dead_code
        break;

      case FPageTransitionType.topToBottomPop:
        assert(childCurrent != null, """
                When using type "topToBottomPop" you need argument: 'childCurrent'
                example:
                  child: MyPage(),
                  childCurrent: this
                """);
        return Stack(
          children: <Widget>[
            child,
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.0),
                end: const Offset(0.0, 1.0),
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
              ),
              child: childCurrent,
            )
          ],
        );
        // ignore: dead_code
        break;

      case FPageTransitionType.bottomToTopPop:
        assert(childCurrent != null, """
                When using type "bottomToTopPop" you need argument: 'childCurrent'
                example:
                  child: MyPage(),
                  childCurrent: this
                """);
        return Stack(
          children: <Widget>[
            child,
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.0),
                end: const Offset(0.0, -1.0),
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
              ),
              child: childCurrent,
            )
          ],
        );
        // ignore: dead_code
        break;

      /// FadeTransitions which is the fade transition
      default:
        return FadeTransition(opacity: animation, child: child);
    }
  }
}
