import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';

import 'providers/auth_provider.dart';
import 'providers/driver_provider.dart';
import 'providers/employee_provider.dart';
import 'providers/vehicle_provider.dart';
import 'providers/trip_provider.dart';
import 'providers/assignment_provider.dart';
import 'providers/live_tracking_provider.dart';
import 'providers/route_provider.dart';
import 'providers/otp_provider.dart';
import 'providers/payment_provider.dart';

import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const SmartEmployeeTravelSystem(),
  );
}

class SmartEmployeeTravelSystem extends StatelessWidget {
  const SmartEmployeeTravelSystem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => EmployeeProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => DriverProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => VehicleProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => TripProvider(),
        ),
                ChangeNotifierProvider(
          create: (_) => AssignmentProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => LiveTrackingProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => RouteProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => OtpProvider(),
        ),

        // PAYMENT PROVIDER
        ChangeNotifierProvider(
          create: (_) => PaymentProvider.instance,
        ),
      ],

      child: MaterialApp(

        debugShowCheckedModeBanner: false,

        title: "Smart Employee Travel Solution",

        theme: AppTheme.lightTheme,

        darkTheme: AppTheme.darkTheme,

        themeMode: ThemeMode.system,

        initialRoute: AppRouter.splash,

        onGenerateRoute: AppRouter.generateRoute,
                builder: (context, child) {

          return MediaQuery(

            data: MediaQuery.of(context).copyWith(
              textScaler:
                  const TextScaler.linear(1.0),
            ),

            child: GestureDetector(

              behavior:
                  HitTestBehavior.translucent,

              onTap: () {

                FocusManager.instance.primaryFocus
                    ?.unfocus();

              },

              child: child!,
            ),
          );
        },

      ),
    );
  }
}