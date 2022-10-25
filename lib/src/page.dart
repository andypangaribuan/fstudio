/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

library ff;

import 'dart:async';
import 'dart:collection';

import 'package:fstudio/src/enum.dart';
import 'package:fstudio/src/ff.dart';
import 'package:fstudio/src/page_transition.dart';
import 'package:fstudio/stream-builder/stream_builder.dart';
import 'package:flutter/material.dart';

import 'extensions.dart';
import 'pipe.dart';

part 'disposer.dart';
part 'page_logic.dart';
part 'page_object.dart';
part 'view_logic.dart';

abstract class FPage<T extends FPageLogic> {
  final _po = _FPageObject<T>._();
  final pipe = _PagePipe._();

  T get logic => _po.logic;

  _FPageState get _state => _po._state!;

  BuildContext get context => logic.context;

  Widget getWidget() {
    if (_po._state == null) {
      return _FYPage((state) {
        _po._state = state;
        return this;
      });
    }

    return _po._state!.widget;
  }

  /// called first
  @protected
  void initialize();

  /// called second
  /// context not ready yet when this method called
  @protected
  void initState() {}

  /// called third
  @protected
  Widget buildLayout(BuildContext context);

  /// called fourth
  @protected
  void onLayoutLoaded() {}

  @protected
  void setLogic(T logic) {
    logic._getPage = () => this;
    _po.logic = logic;
  }

  @protected
  void dispose() {}
}

class _FYPage extends StatefulWidget {
  final _holder = _FYPageHolder();

  _FYPage(FPage Function(_FPageState state) pageStateExchange) {
    _holder.pageStateExchange = pageStateExchange;
  }

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _FPageState(_holder.pageStateExchange);
}

class _FYPageHolder {
  late FPage Function(_FPageState state) pageStateExchange;
  bool calledOnBuildLayoutFirstCall = false;
}

class _FPageState extends State<_FYPage> {
  late FPage page;

  _FPageObject get _po => page._po;

  _FPageState(FPage Function(_FPageState state) pageStateExchange) {
    page = pageStateExchange(this);
    page.initialize();
  }

  @override
  void initState() {
    super.initState();
    page.initState();
    page.logic.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      page.onLayoutLoaded();
      page.logic.onLayoutLoaded();
    });
  }

  @override
  Widget build(BuildContext context) {
    _po._getObjects[GetObjectType.context] = () => context;

    return page.buildLayout(context).also((_) {
      page.logic.onBuildLayout();
      if (!widget._holder.calledOnBuildLayoutFirstCall) {
        widget._holder.calledOnBuildLayoutFirstCall = true;
        page.logic.onBuildLayoutFirstCall();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    page.dispose();
    page.logic.dispose();
    page.logic.disposer._dispose();
  }
}

class _PagePipe {
  _PagePipe._();

  StreamBuilder2 onUpdate2<T1, T2>({
    required FPipe<T1> pipe1,
    required FPipe<T2> pipe2,
    required Widget Function(T1 val1, T2 val2) listener,
  }) {
    return StreamBuilder2<T1, T2>(
      streams: StreamTuple2(
        pipe1.stream,
        pipe2.stream,
      ),
      initialData: StreamInitialDataTuple2(
        pipe1.value,
        pipe2.value,
      ),
      builder: (context, s1, s2) => listener(
        s1.data as T1,
        s2.data as T2,
      ),
    );
  }

  StreamBuilder3 onUpdate3<T1, T2, T3>({
    required FPipe<T1> pipe1,
    required FPipe<T2> pipe2,
    required FPipe<T3> pipe3,
    required Widget Function(T1 val1, T2 val2, T3 val3) listener,
  }) {
    return StreamBuilder3<T1, T2, T3>(
      streams: StreamTuple3(
        pipe1.stream,
        pipe2.stream,
        pipe3.stream,
      ),
      initialData: StreamInitialDataTuple3(
        pipe1.value,
        pipe2.value,
        pipe3.value,
      ),
      builder: (context, s1, s2, s3) => listener(
        s1.data as T1,
        s2.data as T2,
        s3.data as T3,
      ),
    );
  }

  StreamBuilder4 onUpdate4<T1, T2, T3, T4>({
    required FPipe<T1> pipe1,
    required FPipe<T2> pipe2,
    required FPipe<T3> pipe3,
    required FPipe<T4> pipe4,
    required Widget Function(T1 val1, T2 val2, T3 val3, T4 val4) listener,
  }) {
    return StreamBuilder4<T1, T2, T3, T4>(
      streams: StreamTuple4(
        pipe1.stream,
        pipe2.stream,
        pipe3.stream,
        pipe4.stream,
      ),
      initialData: StreamInitialDataTuple4(
        pipe1.value,
        pipe2.value,
        pipe3.value,
        pipe4.value,
      ),
      builder: (context, s1, s2, s3, s4) => listener(
        s1.data as T1,
        s2.data as T2,
        s3.data as T3,
        s4.data as T4,
      ),
    );
  }

  StreamBuilder5 onUpdate5<T1, T2, T3, T4, T5>({
    required FPipe<T1> pipe1,
    required FPipe<T2> pipe2,
    required FPipe<T3> pipe3,
    required FPipe<T4> pipe4,
    required FPipe<T5> pipe5,
    required Widget Function(T1 val1, T2 val2, T3 val3, T4 val4, T5 val5) listener,
  }) {
    return StreamBuilder5<T1, T2, T3, T4, T5>(
      streams: StreamTuple5(
        pipe1.stream,
        pipe2.stream,
        pipe3.stream,
        pipe4.stream,
        pipe5.stream,
      ),
      initialData: StreamInitialDataTuple5(
        pipe1.value,
        pipe2.value,
        pipe3.value,
        pipe4.value,
        pipe5.value,
      ),
      builder: (context, s1, s2, s3, s4, s5) => listener(
        s1.data as T1,
        s2.data as T2,
        s3.data as T3,
        s4.data as T4,
        s5.data as T5,
      ),
    );
  }

  StreamBuilder6 onUpdate6<T1, T2, T3, T4, T5, T6>({
    required FPipe<T1> pipe1,
    required FPipe<T2> pipe2,
    required FPipe<T3> pipe3,
    required FPipe<T4> pipe4,
    required FPipe<T5> pipe5,
    required FPipe<T6> pipe6,
    required Widget Function(T1 val1, T2 val2, T3 val3, T4 val4, T5 val5, T6 val6) listener,
  }) {
    return StreamBuilder6<T1, T2, T3, T4, T5, T6>(
      streams: StreamTuple6(
        pipe1.stream,
        pipe2.stream,
        pipe3.stream,
        pipe4.stream,
        pipe5.stream,
        pipe6.stream,
      ),
      initialData: StreamInitialDataTuple6(
        pipe1.value,
        pipe2.value,
        pipe3.value,
        pipe4.value,
        pipe5.value,
        pipe6.value,
      ),
      builder: (context, s1, s2, s3, s4, s5, s6) => listener(
        s1.data as T1,
        s2.data as T2,
        s3.data as T3,
        s4.data as T4,
        s5.data as T5,
        s6.data as T6,
      ),
    );
  }

  StreamBuilder7 onUpdate7<T1, T2, T3, T4, T5, T6, T7>({
    required FPipe<T1> pipe1,
    required FPipe<T2> pipe2,
    required FPipe<T3> pipe3,
    required FPipe<T4> pipe4,
    required FPipe<T5> pipe5,
    required FPipe<T6> pipe6,
    required FPipe<T7> pipe7,
    required Widget Function(T1 val1, T2 val2, T3 val3, T4 val4, T5 val5, T6 val6, T7 val7) listener,
  }) {
    return StreamBuilder7<T1, T2, T3, T4, T5, T6, T7>(
      streams: StreamTuple7(
        pipe1.stream,
        pipe2.stream,
        pipe3.stream,
        pipe4.stream,
        pipe5.stream,
        pipe6.stream,
        pipe7.stream,
      ),
      initialData: StreamInitialDataTuple7(
        pipe1.value,
        pipe2.value,
        pipe3.value,
        pipe4.value,
        pipe5.value,
        pipe6.value,
        pipe7.value,
      ),
      builder: (context, s1, s2, s3, s4, s5, s6, s7) => listener(
        s1.data as T1,
        s2.data as T2,
        s3.data as T3,
        s4.data as T4,
        s5.data as T5,
        s6.data as T6,
        s7.data as T7,
      ),
    );
  }

  StreamBuilder8 onUpdate8<T1, T2, T3, T4, T5, T6, T7, T8>({
    required FPipe<T1> pipe1,
    required FPipe<T2> pipe2,
    required FPipe<T3> pipe3,
    required FPipe<T4> pipe4,
    required FPipe<T5> pipe5,
    required FPipe<T6> pipe6,
    required FPipe<T7> pipe7,
    required FPipe<T8> pipe8,
    required Widget Function(T1 val1, T2 val2, T3 val3, T4 val4, T5 val5, T6 val6, T7 val7, T8 val8) listener,
  }) {
    return StreamBuilder8<T1, T2, T3, T4, T5, T6, T7, T8>(
      streams: StreamTuple8(
        pipe1.stream,
        pipe2.stream,
        pipe3.stream,
        pipe4.stream,
        pipe5.stream,
        pipe6.stream,
        pipe7.stream,
        pipe8.stream,
      ),
      initialData: StreamInitialDataTuple8(
        pipe1.value,
        pipe2.value,
        pipe3.value,
        pipe4.value,
        pipe5.value,
        pipe6.value,
        pipe7.value,
        pipe8.value,
      ),
      builder: (context, s1, s2, s3, s4, s5, s6, s7, s8) => listener(
        s1.data as T1,
        s2.data as T2,
        s3.data as T3,
        s4.data as T4,
        s5.data as T5,
        s6.data as T6,
        s7.data as T7,
        s8.data as T8,
      ),
    );
  }

  StreamBuilder9 onUpdate9<T1, T2, T3, T4, T5, T6, T7, T8, T9>({
    required FPipe<T1> pipe1,
    required FPipe<T2> pipe2,
    required FPipe<T3> pipe3,
    required FPipe<T4> pipe4,
    required FPipe<T5> pipe5,
    required FPipe<T6> pipe6,
    required FPipe<T7> pipe7,
    required FPipe<T8> pipe8,
    required FPipe<T9> pipe9,
    required Widget Function(T1 val1, T2 val2, T3 val3, T4 val4, T5 val5, T6 val6, T7 val7, T8 val8, T9 val9) listener,
  }) {
    return StreamBuilder9<T1, T2, T3, T4, T5, T6, T7, T8, T9>(
      streams: StreamTuple9(
        pipe1.stream,
        pipe2.stream,
        pipe3.stream,
        pipe4.stream,
        pipe5.stream,
        pipe6.stream,
        pipe7.stream,
        pipe8.stream,
        pipe9.stream,
      ),
      initialData: StreamInitialDataTuple9(
        pipe1.value,
        pipe2.value,
        pipe3.value,
        pipe4.value,
        pipe5.value,
        pipe6.value,
        pipe7.value,
        pipe8.value,
        pipe9.value,
      ),
      builder: (context, s1, s2, s3, s4, s5, s6, s7, s8, s9) => listener(
        s1.data as T1,
        s2.data as T2,
        s3.data as T3,
        s4.data as T4,
        s5.data as T5,
        s6.data as T6,
        s7.data as T7,
        s8.data as T8,
        s9.data as T9,
      ),
    );
  }
}
