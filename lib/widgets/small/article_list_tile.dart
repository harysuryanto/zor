import 'package:flutter/material.dart';
import 'package:zor/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArticleListTile extends StatelessWidget {
  final String imageUrl;
  final String title;

  const ArticleListTile({
    this.imageUrl = 'https://picsum.photos/250',
    this.title = 'Tetap FIt dan Bugar di Usia 40-an',
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: 160,
        // height: 100,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          color: lightColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
