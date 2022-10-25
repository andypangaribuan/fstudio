/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

import 'package:flutter/widgets.dart';

class StreamTuple8<T1, T2, T3, T4, T5, T6, T7, T8> {
  final Stream<T1> stream1;
  final Stream<T2> stream2;
  final Stream<T3> stream3;
  final Stream<T4> stream4;
  final Stream<T5> stream5;
  final Stream<T6> stream6;
  final Stream<T7> stream7;
  final Stream<T8> stream8;

  StreamTuple8(
    this.stream1,
    this.stream2,
    this.stream3,
    this.stream4,
    this.stream5,
    this.stream6,
    this.stream7,
    this.stream8,
  );
}

class StreamInitialDataTuple8<T1, T2, T3, T4, T5, T6, T7, T8> {
  final T1? data1;
  final T2? data2;
  final T3? data3;
  final T4? data4;
  final T5? data5;
  final T6? data6;
  final T7? data7;
  final T8? data8;

  StreamInitialDataTuple8(
    this.data1,
    this.data2,
    this.data3,
    this.data4,
    this.data5,
    this.data6,
    this.data7,
    this.data8,
  );
}

class SnapshotTuple8<T1, T2, T3, T4, T5, T6, T7, T8> {
  final AsyncSnapshot<T1> snapshot1;
  final AsyncSnapshot<T2> snapshot2;
  final AsyncSnapshot<T3> snapshot3;
  final AsyncSnapshot<T4> snapshot4;
  final AsyncSnapshot<T5> snapshot5;
  final AsyncSnapshot<T6> snapshot6;
  final AsyncSnapshot<T7> snapshot7;
  final AsyncSnapshot<T8> snapshot8;

  SnapshotTuple8(
    this.snapshot1,
    this.snapshot2,
    this.snapshot3,
    this.snapshot4,
    this.snapshot5,
    this.snapshot6,
    this.snapshot7,
    this.snapshot8,
  );
}

typedef AsyncWidgetBuilder8<T1, T2, T3, T4, T5, T6, T7, T8> = Widget Function(
  BuildContext context,
  AsyncSnapshot<T1> snap1,
  AsyncSnapshot<T2> snap2,
  AsyncSnapshot<T3> snap3,
  AsyncSnapshot<T4> snap4,
  AsyncSnapshot<T5> snap5,
  AsyncSnapshot<T6> snap6,
  AsyncSnapshot<T7> snap7,
  AsyncSnapshot<T8> snap8,
);

class StreamBuilder8<T1, T2, T3, T4, T5, T6, T7, T8> extends StatelessWidget {
  final StreamTuple8<T1, T2, T3, T4, T5, T6, T7, T8> streams;
  final StreamInitialDataTuple8<T1, T2, T3, T4, T5, T6, T7, T8> initialData;
  final AsyncWidgetBuilder8<T1, T2, T3, T4, T5, T6, T7, T8> builder;

  const StreamBuilder8({
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
                return StreamBuilder<T4>(
                  stream: streams.stream4,
                  initialData: initialData.data4,
                  builder: (context, snap4) {
                    return StreamBuilder<T5>(
                      stream: streams.stream5,
                      initialData: initialData.data5,
                      builder: (context, snap5) {
                        return StreamBuilder<T6>(
                          stream: streams.stream6,
                          initialData: initialData.data6,
                          builder: (context, snap6) {
                            return StreamBuilder<T7>(
                              stream: streams.stream7,
                              initialData: initialData.data7,
                              builder: (context, snap7) {
                                return StreamBuilder<T8>(
                                  stream: streams.stream8,
                                  initialData: initialData.data8,
                                  builder: (context, snap8) {
                                    return builder(
                                      context,
                                      snap1,
                                      snap2,
                                      snap3,
                                      snap4,
                                      snap5,
                                      snap6,
                                      snap7,
                                      snap8,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
