/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

part of ff;

abstract class FPageLogic<T> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool canPopPage = true;

  final disposer = FDisposer();
  final holder = <String, dynamic>{};

  late FPage Function() _getPage;

  T get page => _getPage() as T;

  _FPageObject get _po => _getPage()._po;

  BuildContext get context {
    return scaffoldKey.currentContext ?? _po.getObject(GetObjectType.context) as BuildContext;
  }

  Future<bool> onWillPop() async {
    return canPopPage;
  }

  /// called first
  /// context not ready yet when this method called
  @protected
  void initState() {}

  /// called second
  @protected
  void onBuildLayout() {}

  /// called second - ext: only called once
  @protected
  void onBuildLayoutFirstCall() {}

  /// called third
  @protected
  void onLayoutLoaded() {}

  void pageBack({Object? result}) {
    ff.func.pageBack(context, result: result);
  }

  Future<X> pageOpen<X>(
    dynamic page, {
    FPageTransitionType? transitionType,
    void Function(FPageTransitionHolder holder)? getTransitionHolder,
  }) async {
    Widget widget = Container();
    if (page is Widget) {
      widget = page;
    } else if (page is FPage) {
      widget = page.getWidget();
    }

    return ff.func.pageOpen<X>(
      context,
      _getPage()._state.widget,
      widget,
      transitionType: transitionType,
      getTransitionHolder: getTransitionHolder,
    );
  }

  // @protected
  void pageOpenAndRemovePrevious(dynamic page) {
    ff.func.pageOpenAndRemovePrevious(context, page);
  }

  // @protected
  void pageOpenAndReplaceCurrent(dynamic page) {
    ff.func.pageOpenAndReplaceCurrent(context, page);
  }

  // @protected
  void dismissKeyboard() => context.dismissKeyboard();

  @protected
  void dispose() {}
}
