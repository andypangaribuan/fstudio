/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

import 'package:fstudio/fstudio.dart';

import 'info_page.dart';

class InfoPageLogic extends FPageLogic<InfoPage> {
  void onClickBack() {
    pageBack(result: 1);
  }
}
