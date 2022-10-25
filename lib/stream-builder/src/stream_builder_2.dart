/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

import 'package:flutter/widgets.dart';

class StreamTuple2<T1, T2> {
  final Stream<T1> stream1;
  final Stream<T2> stream2;

  StreamTuple2(
    this.stream1,
    this.stream2,
  );
}

class StreamInitialDataTuple2<T1, T2> {
  final T1? data1;
  final T2? data2;

  StreamInitialDataTuple2(
    this.data1,
    this.data2,
  );
}

class SnapshotTuple2<T1, T2> {
  final AsyncSnapshot<T1> snapshot1;
  final AsyncSnapshot<T2> snapshot2;

  SnapshotTuple2(
    this.snapshot1,
    this.snapshot2,
  );
}

typedef AsyncWidgetBuilder2<T1, T2> = Widget Function(
  BuildContext context,
  AsyncSnapshot<T1> snap1,
  AsyncSnapshot<T2> snap2,
);

class StreamBuilder2<T1, T2> extends StatelessWidget {
  final StreamTuple2<T1, T2> streams;
  final StreamInitialDataTuple2<T1, T2> initialData;
  final AsyncWidgetBuilder2<T1, T2> builder;

  const StreamBuilder2({
    Key? key,
    required this.streams,
    required this.initialData,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T1>(
      stream: streams.stream1,
      initialData: initialData.data1,
      builder: (context, snap1) {
        return StreamBuilder<T2>(
          stream: streams.stream2,
          initialData: initialData.data2,
          builder: (context, snap2) {
            return builder(
              context,
              snap1,
              snap2,
            );
          },
        );
      },
    );
  }
}
