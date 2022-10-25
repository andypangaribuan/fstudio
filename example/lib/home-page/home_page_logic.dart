/*
 * Copyright (c) 2022.
 * Created by Andy Pangaribuan. All Rights Reserved.
 *
 * This product is protected by copyright and distributed under
 * licenses restricting copying, distribution and decompilation.
 */

import 'package:example/info-page/info_page.dart';
import 'package:fstudio/fstudio.dart';

import 'home_page.dart';

class HomePageLogic extends FPageLogic<HomePage> {
  late FPipe<int> countPipe;
  late FPipe<String> textPipe;

  HomePageLogic() {
    countPipe = FPipe(initValue: 0, disposer: disposer);
    textPipe = FPipe(initValue: '', disposer: disposer, withTextEditingController: true, withErrPipe: true);

    textPipe.subscribe(listener: (val) {
      var isErr = textPipe.errValue.isError;
      if (!isErr && val == 'error') {
        var err = textPipe.errValue
          ..isError = true
          ..message = 'you type: error';
        textPipe.errUpdate(err);
      }
      if (isErr && val != 'error') {
        var err = textPipe.errValue
          ..isError = false
          ..message = null;
        textPipe.errUpdate(err);
      }
    });
  }

  void onClickOpenInfoPage() async {
    var value = await pageOpen<int?>(InfoPage().getWidget());
    if (value == null) {
      ff.log(['value is null']);
    } else {
      ff.log(['value: $value']);
    }
  }

  void onClickAddMoreNumber() {
    countPipe.update(countPipe.value + 1);
  }
}
