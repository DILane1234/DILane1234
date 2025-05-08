import 'package:flutter/material.dart';
import 'package:ecogestion/screens/auth/splash_screen.dart';
import 'package:ecogestion/screens/auth/login_screen.dart';
import 'package:ecogestion/screens/auth/register_screen.dart';
import 'package:ecogestion/screens/auth/forgot_password_screen.dart';
import 'package:ecogestion/screens/auth/change_password_screen.dart';
import 'package:ecogestion/screens/auth/auth_check.dart';
import 'package:ecogestion/screens/dashboard/tenant_dashboard.dart';
import 'package:ecogestion/screens/dashboard/owner_dashboard.dart';
import 'package:ecogestion/screens/settings/settings_screen.dart';

class AppRoutes {
  // Constantes pour les noms de routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot_password';
  static const String tenantDashboard = '/tenant_dashboard';
  static const String ownerDashboard = '/owner_dashboard';
  static const String authCheck = '/auth_check';
  static const String changePassword = '/change_password';
  // Futures routes potentielles
  // static const String propertyDetails = '/property_details';
  // static const String tenantDetails = '/tenant_details';
  static const String settings = '/settings';
  // static const String notifications = '/notifications';
  // static const String userProfile = '/user_profile';

  // Dans la méthode get routes
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    changePassword: (context) => const ChangePasswordScreen(),
    tenantDashboard: (context) => const TenantDashboard(),
    ownerDashboard: (context) => const OwnerDashboard(),
    authCheck: (context) => const AuthCheck(),
    settings: (context) => const SettingsScreen(),
  };
}
