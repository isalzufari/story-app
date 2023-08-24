import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/enum/state.dart';
import 'package:story_app/data/preferences/token.dart';
import 'package:story_app/provider/story_list.dart';
import 'package:story_app/widget/card_list.dart';

import '../data/model/story.dart';
import '../routes/page_manager.dart';
import '../util/helper.dart';

class ListStoryPage extends StatefulWidget {
  final VoidCallback onLogoutSuccess;
  final Function(String?) onStoryClicked;
  final VoidCallback onAddStoryClicked;

  const ListStoryPage({
    super.key,
    required this.onLogoutSuccess,
    required this.onStoryClicked,
    required this.onAddStoryClicked,
  });

  @override
  State<ListStoryPage> createState() => _ListStoryPageState();
}

class _ListStoryPageState extends State<ListStoryPage> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _scrollController = ScrollController();
  late ListStoryProvider _listStoryProvider;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        _listStoryProvider.getStories();
      }
    });

    afterBuildWidgetCallback(() async {
      final pageManager = context.read<PageManager>();
      final shoudRefresh = await pageManager.waitForResult();

      if (shoudRefresh) {
        _refreshKey.currentState?.show();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("List Story"),
        actions: [
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              var tokenPref = Token();
              tokenPref.setToken("");

              widget.onLogoutSuccess();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onAddStoryClicked,
        child: const Icon(Icons.add),
      ),
      body: ChangeNotifierProvider<ListStoryProvider>(
        create: (context) => ListStoryProvider(ApiService()),
        builder: (context, child) => Consumer<ListStoryProvider>(
          builder: (context, provider, _) {
            _listStoryProvider = provider;

            switch (provider.state) {
              case ResultState.loading:
              case ResultState.hasData:
                return RefreshIndicator(
                  key: _refreshKey,
                  onRefresh: () => provider.getStories(isRefresh: true),
                  child: _listStories(context, provider.stories),
                );
              case ResultState.error:
              case ResultState.noData:
                hasMoreData = false;
                return RefreshIndicator(
                  key: _refreshKey,
                  onRefresh: () => provider.getStories(isRefresh: true),
                  child: _listStories(context, provider.stories),
                );
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _listStories(BuildContext context, List<Story> stories) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      controller: _scrollController,
      itemCount: stories.length + (hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < stories.length) {
          return CardList(
            story: stories[index],
            onStoryClicked: () => widget.onStoryClicked(stories[index].id),
          );
        } else {
          return Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: const CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
