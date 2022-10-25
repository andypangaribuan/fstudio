/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

import 'package:flutter/widgets.dart';

class StreamTuple3<T1, T2, T3> {
  final Stream<T1> stream1;
  final Stream<T2> stream2;
  final Stream<T3> stream3;

  StreamTuple3(
    this.stream1,
    this.stream2,
    this.stream3,
  );
}

class StreamInitialDataTuple3<T1, T2, T3> {
  final T1? data1;
  final T2? data2;
  final T3? data3;

  StreamInitialDataTuple3(
    this.data1,
    this.data2,
    this.data3,
  );
}

class SnapshotTuple3<T1, T2, T3> {
  final AsyncSnapshot<T1> snapshot1;
  final AsyncSnapshot<T2> snapshot2;
  final AsyncSnapshot<T3> snapshot3;

  SnapshotTuple3(
    this.snapshot1,
    this.snapshot2,
    this.snapshot3,
  );
}

typedef AsyncWidgetBuilder3<T1, T2, T3> = Widget Function(
  BuildContext context,
  AsyncSnapshot<T1> snap1,
  AsyncSnapshot<T2> snap2,
  AsyncSnapshot<T3> snap3,
);

class StreamBuilder3<T1, T2, T3> extends StatelessWidget {
  final StreamTuple3<T1, T2, T3> streams;
  final StreamInitialDataTuple3<T1, T2, T3> initialData;
  final AsyncWidgetBuilder3<T1, T2, T3> builder;

  const StreamBuilder3({
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
            return StreamBuilder<T3>(
              stream: streams.stream3,
              initialData: initialData.data3,
              builder: (context, snap3) {
                return builder(
                  context,
                  snap1,
                  snap2,
                  snap3,
                );
              },
            );
          },
        );
      },
    );
  }
}
