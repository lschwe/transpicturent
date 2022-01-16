import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpicturent/constants.dart';
import 'package:transpicturent/view_models/search_view_model.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchViewModel>(
      create: (_) => SearchViewModel(context),
      child: Scaffold(
        appBar: AppBar(
          title: const _SearchAppBarTitle(),
          bottom: _SearchAppBarBottom(),
        ),
        body: Consumer<SearchViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading)
              return const Center(child: CircularProgressIndicator());

            if (viewModel.showError)
              return Center(child: Text(viewModel.errorMessage!));

            if (viewModel.hasResults) return _SearchGrid();

            if (viewModel.didSearch)
              return const Center(child: Text('No results'));

            return const Center(
              child: Text('Pictures at Your Fingertips'),
            );
          },
        ),
      ),
    );
  }
}

class _SearchGrid extends StatelessWidget {
  const _SearchGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SearchViewModel>(context, listen: false);

    return Stack(
      children: [
        Container(key: viewModel.backgroundKey),
        CustomScrollView(
          controller: viewModel.scrollController,
          slivers: [
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _SearchItem(index);
                },
                childCount: viewModel.resultsCount,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
            ),
            SliverToBoxAdapter(
              child: viewModel.canLoadMore
                  ? Padding(
                      padding: const EdgeInsets.only(
                        top: Layout.margin,
                        bottom: Layout.largeMargin,
                      ),
                      child: SizedBox(
                        key: viewModel.infiniteScrollKey,
                        height: 30,
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: viewModel.isLoadingMore
                                ? CircularProgressIndicator()
                                : Container(),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      ],
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
    final viewModel = Provider.of<SearchViewModel>(context, listen: false);
    final thumbnailUrl = viewModel.thumbnailUrlAtIndex(index);
    if (thumbnailUrl == null) return Container();

    return Stack(
      children: [
        Container(
          color: Colors.black12,
        ),
        Positioned.fill(
          child: Image.network(
            thumbnailUrl,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: RawMaterialButton(
            onPressed: () => viewModel.onResultPressed(index),
          ),
        ),
      ],
    );
  }
}

class _SearchAppBarTitle extends StatelessWidget {
  const _SearchAppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text('Trans'),
        Text(
          'picture',
          style: TextStyle(color: AppColors.secondary),
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
    final viewModel = Provider.of<SearchViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(Layout.margin).copyWith(
          top: 0, right: viewModel.showCancelButton ? 10 : Layout.margin),
      child: Row(
        children: [
          Expanded(
            child: Focus(
              onFocusChange: viewModel.onSearchFieldFocusChanged,
              child: TextField(
                textInputAction: TextInputAction.search,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (query) => viewModel.onQuerySubmitted(query),
                decoration: InputDecoration(
                  prefixIconConstraints: const BoxConstraints(),
                  prefixIcon: const _SearchIcon(),
                  hintText: 'Search any image',
                  filled: true,
                  border: _textFieldBorder,
                  enabledBorder: _textFieldBorder,
                  focusedBorder: _textFieldFocusedBorder,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: const EdgeInsets.fromLTRB(
                      Layout.margin, 20, Layout.margin, 12),
                ),
              ),
            ),
          ),
          viewModel.showCancelButton
              ? Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: TextButton(
                    onPressed: () => viewModel.onCancelButtonPressed(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.2)),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  static const double height = 70;

  @override
  final Size preferredSize = Size(AppBar().preferredSize.width, height);

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
    borderSide:
        BorderSide(color: AppColors.secondary, width: _textFieldBorderWidth),
  );
}

class _SearchIcon extends StatelessWidget {
  const _SearchIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        left: 12,
        right: 5,
      ),
      child: Icon(
        Icons.search,
        size: 28,
      ),
    );
  }
}
