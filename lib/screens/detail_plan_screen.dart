import 'package:flutter/material.dart';

import '../providers/workouts.dart';
import '../widgets/custom_list_tile.dart';

class DetailPlanScreen extends StatelessWidget {
  const DetailPlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Get arguments
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    print(arguments['data_index']);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 60,
                        right: 30,
                        bottom: 20,
                        left: 30,
                      ),
                      child: Text(
                        'Workout Senin (detail screen)',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),

                    /// TODO: Change the list to timeline style
                    /// List of exercises
                    ListView.separated(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: CustomListTile(
                            key: UniqueKey(),
                            title: workouts[index].title,
                            subtitle: workouts[index].subtitle,
                            onTap: () {},
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemCount: workouts.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),

                      /// The children which are not visible will be disposed
                      /// and garbage collected automatically
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: false,
                    ),
                  ],
                ),
              ),
            ),

            /// Bottom section
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '20 menit',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Estimasi waktu total',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      print('Mulai olahraga 🏃‍♂️');

                      Navigator.pushNamed(context, '/exercising');
                    },
                    child: Row(
                      children: const [
                        Text(
                          'Mulai olahraga',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.run_circle_rounded),
                      ],
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
