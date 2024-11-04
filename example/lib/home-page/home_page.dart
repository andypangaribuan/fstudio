/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

import 'package:fstudio/fstudio.dart';
import 'package:flutter/material.dart';

import 'home_page_logic.dart';

class HomePage extends FPage<HomePageLogic> {
  @override
  void initialize() {
    setLogic(HomePageLogic());
  }

  @override
  Widget buildLayout(BuildContext context) {
    return Scaffold(
      key: logic.scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Home Page'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ListView(
          children: <Widget>[
            ElevatedButton(
              onPressed: logic.onClickOpenInfoPage,
              child: const Text('Open Info Page'),
            ),
            divider,
            logic.textPipe.onErrUpdate((_, err) {
              return TextFormField(
                controller: logic.textPipe.textEditingController,
                decoration: InputDecoration(
                  labelText: 'Type: error',
                  errorText: err.isError ? err.message : null,
                  border: const OutlineInputBorder(),
                  suffixIcon: err.isError ? const Icon(Icons.error) : null,
                ),
              );
            }),
            divider,
            Row(
              children: [
                ElevatedButton(
                  onPressed: logic.onClickAddMoreNumber,
                  child: const Text('Add more number'),
                ),
                Expanded(
                  child: logic.countPipe.onUpdate((val) {
                    return Text(
                      'Number: $val',
                      textAlign: TextAlign.center,
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get divider => Container(
        color: Colors.red,
        height: 2,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
      );
}
