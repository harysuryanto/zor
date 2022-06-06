import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../databases/database.dart';
import '../models/plan.dart';
import '../providers/user_auth.dart';
import '../utils/colors.dart';
import '../widgets/article/article_list.dart';
import '../widgets/plan/plan_list.dart';
import '../widgets/reminder/plan_reminder_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = UserAuth();
    final db = DatabaseService();

    final user = Provider.of<User?>(context);

    if (user == null) {
      return const Text('loading ya');
    }

    final displayName = user.displayName ?? user.email ?? 'anonim';

    return Scaffold(
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
              color: primaryColor,
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

          /// Body
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 150),
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
                              '👟 Jadwal hari ini',
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
                          StreamProvider<List<Plan>>.value(
                            value: db.streamPlans(user),
                            initialData: const [],
                            child:
                                const PlanList(isScrollable: false, limit: 3),
                          ),

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
