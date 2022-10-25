/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

import 'package:example/home-page/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FApp());
}

class FApp extends StatefulWidget {
  const FApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FAppState();

}

class _FAppState extends State<FApp> {
  HomePage? _homePage;
  HomePage get homePage {
    _homePage ??= HomePage();
    return _homePage!;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FStudio Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: homePage.getWidget(),
    );
  }

}