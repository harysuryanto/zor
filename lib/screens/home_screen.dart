import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/user_auth.dart';
import '../utils/colors.dart';
import '../widgets/article/article_list.dart';
import '../widgets/plan/plan_list.dart';
import '../widgets/reminder/plan_reminder_list.dart';
import 'loading_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = UserAuth();
    final user = Provider.of<User?>(context);

    if (user == null) {
      return const LoadingScreen();
    }

    final displayName = user.displayName ?? user.email ?? 'anonim';

    return Scaffold(
      backgroundColor: primaryColor,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Logout',
        onPressed: () async {
          await auth.logout();
          // ignore: use_build_context_synchronously
          GoRouter.of(context).go('/login');
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
            child: SafeArea(
              bottom: false,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hai, ${displayName.split(' ')[0]} 👋',
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
          ),

          /// Body
          SingleChildScrollView(
            child: Column(
              children: [
                const SafeArea(bottom: false, child: SizedBox(height: 160)),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
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
                              '👟 Jadwal hari ini (WIP)',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const PlanReminderList(),

                          const SizedBox(height: 30),

                          /// Plan List
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  '📆 ',
                                  style: TextStyle(fontSize: 18),
                                ),
                                const Expanded(
                                  child: Text(
                                    'Rencana olahragamu',
                                    softWrap: false,
                                    style: TextStyle(
                                      fontSize: 16,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: () =>
                                      GoRouter.of(context).push('/all-plans'),
                                  child: Row(
                                    children: const [
                                      Text(
                                        'Lihat semua',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const PlanList(
                            limit: 3,
                            isScrollable: false,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                          ),

                          const SizedBox(height: 30),

                          /// Article List
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              '📰 Artikel untukmu (WIP)',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const ArticleList(),

                          const SizedBox(height: 30),
                          const Center(child: Text('v0.5.0')),
                          const SizedBox(height: 20),
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
