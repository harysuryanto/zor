import 'package:flutter/material.dart';
import 'package:zor/widgets/small/article_list_tile.dart';

class ArticleList extends StatelessWidget {
  const ArticleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: const [
            ArticleListTile(),
            ArticleListTile(),
            ArticleListTile(),
            ArticleListTile(),
          ],
        ),
      ),
    );
  }
}
