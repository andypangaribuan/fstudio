/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

import 'package:fstudio/fstudio.dart';
import 'package:flutter/material.dart';

import 'info_page_logic.dart';

class InfoPage extends FPage<InfoPageLogic> {
  @override
  void initialize() {
    setLogic(InfoPageLogic());
  }

  @override
  Widget buildLayout(BuildContext context) {
    return Scaffold(
      key: logic.scaffoldKey,
      // appBar: AppBar(
      //   title: const Text('Info Page'),
      // ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const Text('Info Page'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: logic.onClickBack,
        tooltip: 'Back',
        child: const Icon(Icons.close),
      ),
    );
  }
}
