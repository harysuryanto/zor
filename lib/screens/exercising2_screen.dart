import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class Exercising2Screen extends StatefulWidget {
  final String planId;
  const Exercising2Screen({required this.planId, Key? key}) : super(key: key);

  @override
  _Exercising2ScreenState createState() => _Exercising2ScreenState();
}

class _Exercising2ScreenState extends State<Exercising2Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Body section
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// TODO: Got error, fix this.
                  /// Illustration
                  // Image.asset(
                  //   "assets/illustrations/man_doing_dumble_curle.png",
                  //   width: 180,
                  // ),
                  CachedNetworkImage(
                    imageUrl: "https://iili.io/l01tEP.png",
                    width: 180,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                  ),

                  const SizedBox(height: 50),

                  /// Texts
                  const Text(
                    'Russian Push Up',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Selanjutnya: Dumble Curl',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),

                  const SizedBox(height: 50),

                  /// Numbers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /// Repetitions
                      Container(
                        width: 120,
                        height: 120,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: lightColor,
                          borderRadius: BorderRadius.all(Radius.circular(80)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              '12',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'rep',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),

                      /// Sets
                      Container(
                        width: 120,
                        height: 120,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: lightColor,
                          borderRadius: BorderRadius.all(Radius.circular(80)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              '1/3',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'set',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Bottom section
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                right: 30,
                bottom: 30,
                left: 30,
              ),
              child: Row(
                children: [
                  OutlinedButton(
                    child: const Icon(
                      Icons.skip_previous_rounded,
                      color: primaryColor,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      child: const Text(
                        'Selanjutnya',
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
