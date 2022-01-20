import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zor/utils/colors.dart';
import 'package:zor/widgets/big/plan_reminder_list.dart';

import '../models/auth.dart';
import '../widgets/big/plan_list.dart';
import '../widgets/big/article_list.dart';

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
    final auth = Auth();

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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 60,
                right: 30,
                bottom: 30,
                left: 30,
              ),
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
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    /// Draggable indicator
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

                    /// Body
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          child: Column(
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
                              PlanReminderList(key: UniqueKey()),

                              const SizedBox(height: 30),

                              /// List of Exercise
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '📆 Rencana olahragamu',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    InkWell(
                                      child: Row(
                                        children: const [
                                          Text('Lihat semua'),
                                          Icon(Icons.chevron_right_rounded),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      onTap: () => context.push('/all-plans'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              const PlanList(isScrollable: false, limit: 3),

                              const SizedBox(height: 30),

                              /// News Carousel
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  '📰 Artikel untukmu',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ArticleList(key: UniqueKey()),

                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
