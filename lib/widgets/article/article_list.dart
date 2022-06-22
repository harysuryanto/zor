import 'package:flutter/material.dart';

import '../global/custom_scroll_behavior.dart';
import 'article_list_tile.dart';

class ArticleList extends StatelessWidget {
  const ArticleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior().copyWith(scrollbars: false),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: const [
            ArticleListTile(key: ValueKey('article1')),
            ArticleListTile(key: ValueKey('article2')),
            ArticleListTile(key: ValueKey('article3')),
            ArticleListTile(key: ValueKey('article4')),
          ],
        ),
      ),
    );
  }
}
