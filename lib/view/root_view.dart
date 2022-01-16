import 'package:flutter/material.dart';
import 'package:transpicturent/view/search_view.dart';

class RootView extends StatefulWidget {
  const RootView({Key? key}) : super(key: key);

  @override
  _RootViewState createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        MaterialPage(child: SearchView()),
      ],
      onPopPage: (root, result) {
        return true;
      },
    );
  }
}
