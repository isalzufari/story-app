import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/enum/state.dart';
import 'package:story_app/provider/story_detail.dart';
import 'package:story_app/widget/card_detail.dart';

class DetailStoryPage extends StatelessWidget {
  final String storyId;
  final VoidCallback onCloseDetailPage;

  const DetailStoryPage({
    super.key,
    required this.storyId,
    required this.onCloseDetailPage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Detail Story")),
      body: SafeArea(
        child: ChangeNotifierProvider<DetailStoryProvider>(
          create: (context) => DetailStoryProvider(ApiService(), storyId),
          builder: (context, child) => Consumer<DetailStoryProvider>(
            builder: (context, provider, _) {
              switch (provider.state) {
                case ResultState.loading:
                  return const Center(child: CircularProgressIndicator());
                case ResultState.hasData:
                  return DetailStory(story: provider.story);
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
                          onPressed: () => {provider.getDetailStory(storyId)},
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
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            onCloseDetailPage();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
