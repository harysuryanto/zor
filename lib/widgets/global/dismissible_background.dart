import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class DismissibleBackground extends StatelessWidget {
  const DismissibleBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 40),
      child: const Icon(Icons.delete),
    );
  }
}
