import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/enum/state.dart';
import 'package:story_app/data/model/detail_story.dart';
import 'package:story_app/data/preferences/token.dart';
import 'package:story_app/provider/story_list.dart';
import 'package:story_app/routes/page_manager.dart';
import 'package:story_app/util/helper.dart';
import 'package:story_app/widget/card_list.dart';

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

  @override
  void initState() {
    super.initState();

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
            switch (provider.state) {
              case ResultState.loading:
                return const Center(child: CircularProgressIndicator());
              case ResultState.hasData:
                return RefreshIndicator(
                  key: _refreshKey,
                  onRefresh: () => provider.getStories(),
                  child: _listStories(context, provider.stories),
                );
              case ResultState.error:
              case ResultState.noData:
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(provider.message),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => {provider.getStories()},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text('Refresh')],
                        ),
                      ),
                    ],
                  ),
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
      itemCount: stories.length,
      itemBuilder: (_, index) {
        return CardList(
          story: stories[index],
          onStoryClicked: () => widget.onStoryClicked(stories[index].id),
        );
      },
    );
  }
}
