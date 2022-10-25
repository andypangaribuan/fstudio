/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

import 'dart:async' show Timer, Zone;

import 'package:clock/clock.dart' show clock;

class FTimer implements Timer {
  final Zone _zone;
  Stopwatch? _stopwatch = clock.stopwatch();
  Timer? _timer;
  int _tick = 0;

  void Function() callback;
  Duration duration;

  Duration get elapsed => _stopwatch?.elapsed ?? duration;
  bool get isPaused => _timer == null && !isExpired;
  bool get isExpired => _stopwatch == null;

  @override
  bool get isActive => _timer != null;

  @override
  int get tick => _tick;

  FTimer(this.duration, this.callback)
      : assert(duration >= Duration.zero),
        _zone = Zone.current;

  void start() {
    if (isActive || isExpired) {
      return;
    }

    _startTimer();
  }

  void pause() {
    _stopwatch?.stop();
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    _stopwatch = clock.stopwatch();

    if (isActive) {
      _timer!.cancel();
      _startTimer();
    }
  }

  void resetAndStart() {
    _stopwatch = clock.stopwatch();

    if (!isActive) {
      cancel();
      _startTimer();
    } else {
      _timer!.cancel();
      _startTimer();
    }
  }

  @override
  void cancel() {
    _stopwatch?.stop();
    _timer?.cancel();
    _timer = null;
  }

  void _startTimer() {
    assert(_stopwatch != null);

    _timer = _zone.createTimer(duration - _stopwatch!.elapsed, () {
      _tick++;
      _timer = null;
      _stopwatch = null;
      _zone.run(callback);
    });

    _stopwatch!.start();
  }
}
