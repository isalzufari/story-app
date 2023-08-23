import 'package:flutter/material.dart';
import 'package:story_app/data/model/detail_story.dart';

class CardList extends StatelessWidget {
  final Story story;
  final VoidCallback onStoryClicked;

  const CardList(
      {super.key, required this.story, required this.onStoryClicked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onStoryClicked,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 100,
                width: 150,
                child: Image.network(
                  story.photoUrl ?? "",
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey[400],
                        ),
                      );
                    }
                  },
                  errorBuilder: (_, __, ___) {
                    return Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey[400],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    story.name ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
