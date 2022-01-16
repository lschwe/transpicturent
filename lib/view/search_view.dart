import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpicturent/constants.dart';
import 'package:transpicturent/view_model/search_view_model.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final SearchViewModel viewModel = SearchViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _SearchAppBarTitle(),
        bottom: _SearchAppBarBottom(),
      ),
      body: ChangeNotifierProvider<SearchViewModel>(
        create: (_) => viewModel,
        child: CustomScrollView(
          slivers: [
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _SearchItem(index);
                },
                childCount: 20,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchItem extends StatelessWidget {
  const _SearchItem(
    this.index, {
    Key? key,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            'https://cdn-prod.medicalnewstoday.com/content/images/articles/322/322868/golden-retriever-puppy.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: RawMaterialButton(
            onPressed: () {
              print('image $index pressed');
            },
          ),
        ),
      ],
    );
  }
}

class _SearchAppBarTitle extends StatelessWidget {
  _SearchAppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text('Trans'),
        Text(
          'picture',
          style: TextStyle(color: AppColors.secondaryColor),
        ),
        Text('nt'),
      ],
    );
  }
}

class _SearchAppBarBottom extends StatelessWidget with PreferredSizeWidget {
  _SearchAppBarBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16).copyWith(top: 0),
      child: TextField(
        decoration: InputDecoration(
            prefixIconConstraints: BoxConstraints(),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 5,
              ),
              child: Icon(
                Icons.search,
                size: 28,
              ),
            ),
            hintText: 'Search any image',
            filled: true,
            border: _textFieldBorder,
            enabledBorder: _textFieldBorder,
            focusedBorder: _textFieldFocusedBorder,
            fillColor: Colors.white,
            isDense: true,
            contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12)),
      ),
    );
  }

  static const double height = 70;

  @override
  Size preferredSize = Size(AppBar().preferredSize.width, height);

  static const double _textFieldBorderRadius = 40;
  static const double _textFieldBorderWidth = 3;
  static final _textFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(_textFieldBorderRadius),
    ),
  );

  static final _textFieldFocusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(_textFieldBorderRadius),
    ),
    borderSide: BorderSide(
        color: AppColors.secondaryColor, width: _textFieldBorderWidth),
  );
}
