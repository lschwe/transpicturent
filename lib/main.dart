import 'package:flutter/material.dart';
import 'package:transpicturent/constants.dart';
import 'package:transpicturent/views/search_view.dart';

void main() {
  runApp(const TranspicturentApp());
}

class TranspicturentApp extends StatelessWidget {
  const TranspicturentApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transpicturent',
      theme: ThemeData(
        primarySwatch: AppColors.brand,
      ),
      home: const SearchView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
