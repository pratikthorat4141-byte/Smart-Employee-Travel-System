import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../routes/app_router.dart';

class AppDrawer extends StatelessWidget {
  final String? currentRoute;

  const AppDrawer({
    super.key,
    this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 25,
                bottom: 20,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff1565C0),
                    Color(0xff42A5F5),
                  ],
                ),
              ),

              child: Column(
                children: [

                  Container(
                    width: 90,
                    height: 90,
                    padding:
                        const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                              20),
                    ),
                    child: Image.asset(
                      "assets/images/admin_logo.png",
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Pratik Thorat",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius:
                          BorderRadius.circular(
                              30),
                    ),
                    child: const Text(
                      "Administrator",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Smart Employee Travel Solution",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                                    _drawerItem(
                    context,
                    icon: Icons.dashboard_rounded,
                    title: "Dashboard",
                    route: "/dashboard",
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.people_alt_rounded,
                    title: "Employees",
                    route: "/employees",
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.badge_rounded,
                    title: "Drivers",
                    route: "/drivers",
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.directions_car_filled_rounded,
                    title: "Vehicles",
                    route: "/vehicles",
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.route_rounded,
                    title: "Trips",
                    route: "/trips",
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.location_on_rounded,
                    title: "Live Tracking",
                    route: "/tracking",
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.analytics_rounded,
                    title: "Reports",
                    route: "/reports",
                  ),

                  const Divider(
                    height: 30,
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.settings,
                    ),
                    title: const Text(
                      "Settings",
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                    ),
                    title: const Text(
                      "About Application",
                    ),
                    subtitle: const Text(
                      "Version 1.0.0",
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName:
                            "Smart Employee Travel Solution",
                        applicationVersion:
                            "1.0.0",
                        applicationLegalese:
                            "© 2026 Pratik Thorat",
                      );
                    },
                  ),

                  const Divider(),
                                    ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    onTap: () async {

                      Navigator.pop(context);

                      final confirm =
                          await showDialog<bool>(
                                context: context,
                                builder: (_) =>
                                    AlertDialog(
                                  title: const Text(
                                    "Logout",
                                  ),
                                  content: const Text(
                                    "Are you sure you want to logout?",
                                  ),
                                  actions: [

                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                          context,
                                          false,
                                        );
                                      },
                                      child: const Text(
                                        "Cancel",
                                      ),
                                    ),

                                    FilledButton(
                                      onPressed: () {
                                        Navigator.pop(
                                          context,
                                          true,
                                        );
                                      },
                                      child: const Text(
                                        "Logout",
                                      ),
                                    ),

                                  ],
                                ),
                              ) ??
                              false;

                      if (!confirm) return;

                      await context
                          .read<AuthProvider>()
                          .logout();

                      if (!context.mounted) return;

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRouter.login,
                        (_) => false,
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  const Center(
                    child: Text(
                      "Developed By",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Center(
                    child: Text(
                      "Pratik Thorat",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
          required IconData icon,
    required String title,
    required String route,
  }) {

    final selected =
        currentRoute == route;

    return ListTile(

      selected: selected,

      selectedTileColor:
          Colors.blue.shade50,

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),

      leading: Icon(
        icon,
        color: selected
            ? Colors.blue
            : Colors.black87,
      ),

      title: Text(
        title,
        style: TextStyle(
          fontWeight: selected
              ? FontWeight.bold
              : FontWeight.w500,
          color: selected
              ? Colors.blue
              : Colors.black87,
        ),
      ),

      trailing: const Icon(
        Icons.chevron_right,
        size: 18,
      ),

      onTap: () {

        Navigator.pop(context);

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              "$title Screen",
            ),
          ),
        );

        // TODO:
        // Replace with Navigator.pushNamed()
        // after all routes are configured.

      },
    );
  }
}