/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

part of f_guide;

class _IsInstanceTypeOf<T> {}

class _Func {
  _Func._();

  static const _chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final _rnd = Random();

  String randomChar(int length) {
    return String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  bool isTypeOf<ThisType, OfType>() => _IsInstanceTypeOf<ThisType>() is _IsInstanceTypeOf<OfType>;

  bool isGenericTypeNullable<T>() => null is T;

  Future<T> pageOpen<T>(
    BuildContext context,
    Widget currentPage,
    page, {
    FPageTransitionType? transitionType,
    bool disableAnimation = false,
    void Function(FPageTransitionHolder holder)? getTransitionHolder,
  }) async {
    var isIOS = _osPlatform == OSPlatform.ios;
    final type = transitionType ?? FPageTransitionType.rightToLeft;
    dynamic response;
    if (disableAnimation && transitionType == null) {
      response = await Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    } else {
      final pageTransition = FPageTransition(type: type, childCurrent: currentPage, child: page, isIos: isIOS);
      getTransitionHolder?.call(pageTransition.holder);
      response = await Navigator.push(context, pageTransition);
    }
    return response as T;
  }

  void pageBack(BuildContext context, {Object? result}) {
    Navigator.pop(context, result);
  }

  void pageOpenAndRemovePrevious(BuildContext context, dynamic page) {
    Widget widget = Container();
    if (page is Widget) {
      widget = page;
    } else if (page is FPage) {
      widget = page.getWidget();
    }

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => widget), ModalRoute.withName(''));
  }

  Future<T> waitNotNull<T>(T? Function() check, {int millis = 100}) async {
    T? data = check.call();
    while (data == null) {
      await Future.delayed(Duration(milliseconds: millis));
      data = check.call();
    }

    return data;
  }

  /// pipe must have withErrPipe
  void subscribeValidationLapse<T>({
    required FDisposer disposer,
    required List<FPipe<T>> pipes,
    required String? Function(T val) validation,
    bool notifyWhenValidated = false,
    Duration lapse = const Duration(milliseconds: 2500),
  }) {
    for (var pipe in pipes) {
      final timer = FTimer(lapse, () {
        final err = validation(pipe.value);
        if (err != null && err.isNotEmpty) {
          pipe.errValue
            ..setError(err)
            ..update();
        } else if (notifyWhenValidated) {
          pipe.errValue.update();
        }
      });

      pipe.subscribe(
        disposer: disposer,
        listener: (val) {
          if (pipe.errValue.isError) {
            pipe.errUpdate(pipe.errValue..isError = false);
          }
          timer.resetAndStart();
        },
      );
    }
  }

  void subscribe1<T1>({
    required FDisposer disposer,
    required FPipe<T1> pipe1,
    required void Function(T1 val1) listener,
    Duration? lapse,
    VoidCallback? listenerWithoutLapse,
  }) {
    _FuncPipeSubscribe._pipeSubs(
      disposer: disposer,
      lapse: lapse,
      callbackWithoutLapse: listenerWithoutLapse,
      pipes: [pipe1],
      callback: () {
        listener(pipe1.value);
      },
    );
  }

  void subscribe2<T1, T2>({
    required FDisposer disposer,
    required FPipe<T1> pipe1,
    required FPipe<T2> pipe2,
    required void Function(T1 val1, T2 val2) listener,
    Duration? lapse,
    VoidCallback? listenerWithoutLapse,
  }) {
    _FuncPipeSubscribe._pipeSubs(
      disposer: disposer,
      lapse: lapse,
      callbackWithoutLapse: listenerWithoutLapse,
      pipes: [pipe1, pipe2],
      callback: () {
        listener(pipe1.value, pipe2.value);
      },
    );
  }

  void subscribe3<T1, T2, T3>({
    required FDisposer disposer,
    required FPipe<T1> pipe1,
    required FPipe<T2> pipe2,
    required FPipe<T3> pipe3,
    required void Function(T1 val1, T2 val2, T3 val3) listener,
    Duration? lapse,
    VoidCallback? listenerWithoutLapse,
  }) {
    _FuncPipeSubscribe._pipeSubs(
      disposer: disposer,
      lapse: lapse,
      callbackWithoutLapse: listenerWithoutLapse,
      pipes: [pipe1, pipe2, pipe3],
      callback: () {
        listener(pipe1.value, pipe2.value, pipe3.value);
      },
    );
  }

  void subscribe4<T1, T2, T3, T4>({
    required FDisposer disposer,
    required FPipe<T1> pipe1,
    required FPipe<T2> pipe2,
    required FPipe<T3> pipe3,
    required FPipe<T4> pipe4,
    required void Function(T1 val1, T2 val2, T3 val3, T4 val4) listener,
    Duration? lapse,
    VoidCallback? listenerWithoutLapse,
  }) {
    _FuncPipeSubscribe._pipeSubs(
      disposer: disposer,
      lapse: lapse,
      callbackWithoutLapse: listenerWithoutLapse,
      pipes: [pipe1, pipe2, pipe3, pipe4],
      callback: () {
        listener(pipe1.value, pipe2.value, pipe3.value, pipe4.value);
      },
    );
  }

  void subscribe5<T1, T2, T3, T4, T5>({
    required FDisposer disposer,
    required FPipe<T1> pipe1,
    required FPipe<T2> pipe2,
    required FPipe<T3> pipe3,
    required FPipe<T4> pipe4,
    required FPipe<T5> pipe5,
    required void Function(T1 val1, T2 val2, T3 val3, T4 val4, T5 val5) listener,
    Duration? lapse,
    VoidCallback? listenerWithoutLapse,
  }) {
    _FuncPipeSubscribe._pipeSubs(
      disposer: disposer,
      lapse: lapse,
      callbackWithoutLapse: listenerWithoutLapse,
      pipes: [pipe1, pipe2, pipe3, pipe4, pipe5],
      callback: () {
        listener(pipe1.value, pipe2.value, pipe3.value, pipe4.value, pipe5.value);
      },
    );
  }

  void subscribe6<T1, T2, T3, T4, T5, T6>({
    required FDisposer disposer,
    required FPipe<T1> pipe1,
    required FPipe<T2> pipe2,
    required FPipe<T3> pipe3,
    required FPipe<T4> pipe4,
    required FPipe<T5> pipe5,
    required FPipe<T6> pipe6,
    required void Function(T1 val1, T2 val2, T3 val3, T4 val4, T5 val5, T6 val6) listener,
    Duration? lapse,
    VoidCallback? listenerWithoutLapse,
  }) {
    _FuncPipeSubscribe._pipeSubs(
      disposer: disposer,
      lapse: lapse,
      callbackWithoutLapse: listenerWithoutLapse,
      pipes: [pipe1, pipe2, pipe3, pipe4, pipe5, pipe6],
      callback: () {
        listener(pipe1.value, pipe2.value, pipe3.value, pipe4.value, pipe5.value, pipe6.value);
      },
    );
  }

  void subscribe7<T1, T2, T3, T4, T5, T6, T7>({
    required FDisposer disposer,
    required FPipe<T1> pipe1,
    required FPipe<T2> pipe2,
    required FPipe<T3> pipe3,
    required FPipe<T4> pipe4,
    required FPipe<T5> pipe5,
    required FPipe<T6> pipe6,
    required FPipe<T7> pipe7,
    required void Function(T1 val1, T2 val2, T3 val3, T4 val4, T5 val5, T6 val6, T7 val7) listener,
    Duration? lapse,
    VoidCallback? listenerWithoutLapse,
  }) {
    _FuncPipeSubscribe._pipeSubs(
      disposer: disposer,
      lapse: lapse,
      callbackWithoutLapse: listenerWithoutLapse,
      pipes: [pipe1, pipe2, pipe3, pipe4, pipe5, pipe6, pipe7],
      callback: () {
        listener(pipe1.value, pipe2.value, pipe3.value, pipe4.value, pipe5.value, pipe6.value, pipe7.value);
      },
    );
  }

  void subscribe8<T1, T2, T3, T4, T5, T6, T7, T8>({
    required FDisposer disposer,
    required FPipe<T1> pipe1,
    required FPipe<T2> pipe2,
    required FPipe<T3> pipe3,
    required FPipe<T4> pipe4,
    required FPipe<T5> pipe5,
    required FPipe<T6> pipe6,
    required FPipe<T7> pipe7,
    required FPipe<T8> pipe8,
    required void Function(T1 val1, T2 val2, T3 val3, T4 val4, T5 val5, T6 val6, T7 val7, T8 val8) listener,
    Duration? lapse,
    VoidCallback? listenerWithoutLapse,
  }) {
    _FuncPipeSubscribe._pipeSubs(
      disposer: disposer,
      lapse: lapse,
      callbackWithoutLapse: listenerWithoutLapse,
      pipes: [pipe1, pipe2, pipe3, pipe4, pipe5, pipe6, pipe7, pipe8],
      callback: () {
        listener(pipe1.value, pipe2.value, pipe3.value, pipe4.value, pipe5.value, pipe6.value, pipe7.value, pipe8.value);
      },
    );
  }

  void subscribe9<T1, T2, T3, T4, T5, T6, T7, T8, T9>({
    required FDisposer disposer,
    required FPipe<T1> pipe1,
    required FPipe<T2> pipe2,
    required FPipe<T3> pipe3,
    required FPipe<T4> pipe4,
    required FPipe<T5> pipe5,
    required FPipe<T6> pipe6,
    required FPipe<T7> pipe7,
    required FPipe<T8> pipe8,
    required FPipe<T9> pipe9,
    required void Function(T1 val1, T2 val2, T3 val3, T4 val4, T5 val5, T6 val6, T7 val7, T8 val8, T9 val9) listener,
    Duration? lapse,
    VoidCallback? listenerWithoutLapse,
  }) {
    _FuncPipeSubscribe._pipeSubs(
      disposer: disposer,
      lapse: lapse,
      callbackWithoutLapse: listenerWithoutLapse,
      pipes: [pipe1, pipe2, pipe3, pipe4, pipe5, pipe6, pipe7, pipe8, pipe9],
      callback: () {
        listener(pipe1.value, pipe2.value, pipe3.value, pipe4.value, pipe5.value, pipe6.value, pipe7.value, pipe8.value, pipe9.value);
      },
    );
  }
}

class _FuncPipeSubscribe {
  FTimer? _timer;
  late VoidCallback _callback;
  VoidCallback? _callbackWithoutLapse;

  _FuncPipeSubscribe({
    required FDisposer disposer,
    required VoidCallback callback,
    Duration? lapse,
    VoidCallback? callbackWithoutLapse,
  }) {
    _callbackWithoutLapse = callbackWithoutLapse;
    if (lapse != null) {
      _timer = FTimer(lapse, callback);
    } else {
      _callback = callback;
    }
  }

  static void _pipeSubs({
    required FDisposer disposer,
    required List<FPipe> pipes,
    required VoidCallback callback,
    Duration? lapse,
    VoidCallback? callbackWithoutLapse,
  }) {
    _FuncPipeSubscribe(
      disposer: disposer,
      lapse: lapse,
      callback: callback,
      callbackWithoutLapse: callbackWithoutLapse,
    ).subscribe(disposer, pipes);
  }

  void trigger() {
    if (_timer != null) {
      _timer!.resetAndStart();
      _callbackWithoutLapse?.call();
    } else {
      _callback.call();
    }
  }

  void subscribe(FDisposer disposer, List<FPipe> pipes) {
    for (var pipe in pipes) {
      pipe.subscribe(
        listener: (_) => trigger(),
        disposer: disposer,
      );
    }
  }
}
