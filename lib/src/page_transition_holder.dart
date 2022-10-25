/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */
part of ff.page_transition;

class FPageTransitionHolder {
  bool animationEnabled = true;
  bool withMatchingBuilder = true;

  late FPageTransition Function() _pageTransition;
  FPageTransition get _pt => _pageTransition();

  FPageTransitionHolder._({required FPageTransition Function() pageTransition}) {
    _pageTransition = pageTransition;
  }

  _FPageTransitionHolderAnimation _buildAnimation(
      {required BuildContext Function() context,
      required Animation<double> Function() animation,
      required Animation<double> Function() secondaryAnimation,
      required Widget Function() child}) {
    return _FPageTransitionHolderAnimation._(
      holder: () => this,
      context: context,
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
}

class _FPageTransitionHolderAnimation {
  late FPageTransitionHolder Function() _holder;
  late BuildContext Function() _context;
  late Animation<double> Function() _animation;
  late Animation<double> Function() _secondaryAnimation;
  late Widget Function() _child;

  _FPageTransitionHolderAnimation._(
      {required FPageTransitionHolder Function() holder,
      required BuildContext Function() context,
      required Animation<double> Function() animation,
      required Animation<double> Function() secondaryAnimation,
      required Widget Function() child}) {
    _holder = holder;
    _context = context;
    _animation = animation;
    _secondaryAnimation = secondaryAnimation;
    _child = child;
  }

  Widget exec({required Widget animation}) {
    FPageTransitionHolder h = _holder();

    if (!h.withMatchingBuilder) {
      return animation;
    }

    return !h._pt.isIos ? animation : h._pt.matchingBuilder.buildTransitions(h._pt, _context(), _animation(), _secondaryAnimation(), _child());
  }
}
