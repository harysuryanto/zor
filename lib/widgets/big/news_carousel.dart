import 'package:flutter/material.dart';

class NewsCarousel extends StatelessWidget {
  const NewsCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100),
      margin: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      child:
          const Center(child: Text('[ Berita olahraga dari website berita ]')),
    );
  }
}
