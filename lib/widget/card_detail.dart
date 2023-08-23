import 'package:flutter/material.dart';
import 'package:story_app/data/model/detail_story.dart';

class DetailStory extends StatelessWidget {
  final Story story;

  const DetailStory({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 400,
                width: widthScreen,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(story.photoUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story.name![0].toUpperCase() +
                                story.name!.substring(1),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Description :',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  story.description!,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
