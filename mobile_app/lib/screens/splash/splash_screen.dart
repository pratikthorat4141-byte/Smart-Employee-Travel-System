import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<double> _scaleAnimation;

  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1200,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: .75,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();

    Timer(
      const Duration(seconds: 3),
      _navigate,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigate() async {

    if (!mounted) return;

    final auth =
        context.read<AuthProvider>();

    if (auth.isLoggedIn) {

      if (auth.isAdmin) {

        Navigator.pushReplacementNamed(
          context,
          AppRouter.adminDashboard,
        );

      } else if (auth.isEmployee) {

        Navigator.pushReplacementNamed(
          context,
          AppRouter.employeeDashboard,
        );

      } else if (auth.isDriver) {

        Navigator.pushReplacementNamed(
          context,
          AppRouter.driverDashboard,
        );

      } else {

        Navigator.pushReplacementNamed(
          context,
          AppRouter.login,
        );

      }

    } else {

      Navigator.pushReplacementNamed(
        context,
        AppRouter.login,
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        height: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topLeft,

            end: Alignment.bottomRight,

            colors: [

              Color(0xff0D47A1),

              Color(0xff1976D2),

              Color(0xff42A5F5),

            ],

          ),

        ),

        child: SafeArea(

          child: Center(

            child: Padding(

              padding: const EdgeInsets.symmetric(

                horizontal: 24,

              ),

              child: FadeTransition(

                opacity: _fadeAnimation,

                child: ScaleTransition(

                  scale: _scaleAnimation,

                  child: Column(

                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [
                                            Container(

                        height: 170,

                        width: 170,

                        decoration: BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(35),

                          boxShadow: const [

                            BoxShadow(

                              color: Colors.black26,

                              blurRadius: 30,

                              offset: Offset(0, 15),

                            ),

                          ],

                        ),

                        child: Padding(

                          padding: const EdgeInsets.all(22),

                          child: Hero(

                            tag: "admin_logo",

                            child: Image.asset(

                              "assets/images/admin_logo.png",

                              fit: BoxFit.contain,

                            ),

                          ),

                        ),

                      ),

                      const SizedBox(
                        height: 35,
                      ),

                      const Text(

                        "Smart Employee",

                        textAlign: TextAlign.center,

                        style: TextStyle(

                          color: Colors.white,

                          fontSize: 31,

                          fontWeight: FontWeight.bold,

                          letterSpacing: 1,

                        ),

                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      const Text(

                        "Travel Solution",

                        textAlign: TextAlign.center,

                        style: TextStyle(

                          color: Colors.white,

                          fontSize: 31,

                          fontWeight: FontWeight.bold,

                          letterSpacing: 1,

                        ),

                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      Container(

                        padding: const EdgeInsets.symmetric(

                          horizontal: 18,

                          vertical: 10,

                        ),

                        decoration: BoxDecoration(

                          color: Colors.white24,

                          borderRadius:
                              BorderRadius.circular(30),

                        ),

                        child: const Text(

                          "AI Enabled Smart Travel Management System",

                          textAlign: TextAlign.center,

                          style: TextStyle(

                            color: Colors.white,

                            fontSize: 15,

                            fontWeight: FontWeight.w500,

                          ),

                        ),

                      ),

                      const SizedBox(
                        height: 45,
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      const CircularProgressIndicator(

                        strokeWidth: 3,

                        color: Colors.white,

                      ),

                      const SizedBox(
                        height: 45,
                      ),

                      Container(

                        padding: const EdgeInsets.symmetric(

                          horizontal: 22,

                          vertical: 14,

                        ),

                        decoration: BoxDecoration(

                          color: Colors.white10,

                          borderRadius:
                              BorderRadius.circular(18),

                          border: Border.all(

                            color: Colors.white24,

                          ),

                        ),

                        child: const Column(

                          children: [
                                                        Text(

                              "Developed By",

                              style: TextStyle(

                                color: Colors.white70,

                                fontSize: 14,

                              ),

                            ),

                            SizedBox(
                              height: 8,
                            ),

                            Text(

                              "Pratik Thorat",

                              style: TextStyle(

                                color: Colors.white,

                                fontSize: 24,

                                fontWeight:
                                    FontWeight.bold,

                                letterSpacing: 1,

                              ),

                            ),

                            SizedBox(
                              height: 6,
                            ),

                            Text(

                              "AI & Machine Learning Engineer",

                              textAlign: TextAlign.center,

                              style: TextStyle(

                                color: Colors.white70,

                                fontSize: 14,

                              ),

                            ),

                          ],

                        ),

                      ),

                      const Spacer(),

                      const Text(

                        "Version 1.0.0",

                        style: TextStyle(

                          color: Colors.white60,

                          fontSize: 12,

                        ),

                      ),

                      const SizedBox(
                        height: 15,
                      ),
                                          ],

                  ),

                ),

              ),

            ),

          ),

        ),

      ),

    );

  }

}