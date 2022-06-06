import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/user_auth.dart';
import '../utils/colors.dart';
import '../widgets/article/article_list.dart';
import '../widgets/plan/plan_list.dart';
import '../widgets/reminder/plan_reminder_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  String get _displayName {
    final currentUser = FirebaseAuth.instance.currentUser!;
    return currentUser.displayName?.split(' ')[0] ??
        currentUser.email ??
        'anonim';
  }

  @override
  Widget build(BuildContext context) {
    final auth = UserAuth();

    return Scaffold(
      backgroundColor: primaryColor,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Logout',
        onPressed: () async {
          await auth.logout();
          context.go('/login');
        },
        child: const Icon(Icons.logout_rounded),
      ),
      body: Stack(
        children: [
          /// Banner
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hai, $_displayName 👋',
                    style: const TextStyle(fontSize: 24),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Senang melihatmu kembali!',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),

          /// Body
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 150),
                Container(
                  decoration: const BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 30),
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: lightColor,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Plan Reminder
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              '👟 Jadwal hari ini',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const PlanReminderList(),

                          const SizedBox(height: 30),

                          /// Exercise List
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '📆 Rencana olahragamu',
                                  style: TextStyle(fontSize: 18),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: () => context.push('/all-plans'),
                                  child: Row(
                                    children: const [
                                      Text('Lihat semua'),
                                      Icon(Icons.chevron_right_rounded),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const PlanList(isScrollable: false, limit: 3),

                          const SizedBox(height: 30),

                          /// Article List
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              '📰 Artikel untukmu',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const ArticleList(),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
