<!--
Account publishing pub.dev on iam.pangaribuan@gmail.com

Publish to pub.dev
1. Edit version on pubspec.yaml
2. Add information on CHANGELOG.md
3. Check the package
   $ fvm flutter pub publish --dry-run
4. Publish to pub.dev
   $ fvm flutter pub publish

Flutter commands:
- Analyze your code
  $ fvm flutter analyze
- Get all dependencies:
  $ fvm flutter pub get
- Doctor
  $ fvm flutter doctor -v

IntelliJ Shortcuts
✦ opt + (↑ OR ↓)    ︎〉extend selection
✦ ctrl + opt + I    ︎〉auto-indent lines
✦ ctrl + shift + E  ︎〉next highlighted error (custom)
✦ ctrl + tab        ︎〉switcher
✦ cmd + .  ︎         〉collapse or expand block
✦ ctrl + shift + -  ︎〉collapse all
✦ ctrl + shift + +  ︎〉expand all
-->

# FStudio

Flutter Studio

* Split UI and logic, and provide connection to each other.
* Easy state management with auto disposal.

## Getting started

Example:

```dart
import 'package:fstudio/fstudio.dart';
import 'home-page-logic.dart';

class HomePage extends FPage<HomePageLogic> {
  HomePage({Key? key}) : super(key: key) {
    setLogic(HomePageLogic());
  }

  @override
  Widget buildLayout(BuildContext context) {
    return Scaffold(
      key: logic.scaffoldKey,
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            logic.countPipe.onUpdate((val) => Text(
              '$val',
              style: Theme.of(context).textTheme.headline4,
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: logic.onClickAdd,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

```dart
import 'package:fstudio/fstudio.dart';
import 'home-page.dart';
import 'info-page.dart';

class HomePageLogic extends FPageLogic<HomePage> {
  late FPipe<int> countPipe;

  HomePageLogic() {
    countPipe = FPipe(initValue: 0, disposer: disposer);
  }

  @override
  void initState() {}

  @override
  void onBuildLayout() {}

  @override
  void onLayoutLoaded() {}

  void onClickAdd() async {
    countPipe.update(countPipe.value + 1);
    if (countPipe.value == 3) {
      countPipe.update(0);
      var value = await pageOpen<int>(InfoPage());
    }
  }
}
```

## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an [`issue`](https://github.com/andypangaribuan/fstudio/issues).  
If you fixed a bug or implemented a feature, please send a [`pull request`](https://github.com/andypangaribuan/fstudio/pulls).
