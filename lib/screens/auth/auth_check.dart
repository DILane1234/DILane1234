import 'package:flutter/material.dart';
import 'package:ecogestion/services/firebase_service.dart';
import 'package:ecogestion/config/routes.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    // Attendre un peu pour permettre à Firebase de s'initialiser
    await Future.delayed(const Duration(seconds: 1));
    
    if (_firebaseService.currentUser != null) {
      // L'utilisateur est connecté, vérifier son type
      String? userType = await _firebaseService.getUserType();
      
      if (mounted) {
        if (userType == 'owner') {
          Navigator.pushReplacementNamed(context, AppRoutes.ownerDashboard);
        } else if (userType == 'tenant') {
          Navigator.pushReplacementNamed(context, AppRoutes.tenantDashboard);
        } else {
          // Type d'utilisateur non défini, rediriger vers la connexion
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      }
    } else {
      // L'utilisateur n'est pas connecté, rediriger vers la connexion
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}