import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtenir l'utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Stream pour suivre l'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Inscription avec email et mot de passe
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String userType, // 'owner' ou 'tenant'
    String? name, // Ajout du paramètre nom
  }) async {
    try {
      // Créer l'utilisateur dans Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Stocker les informations supplémentaires dans Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'userType': userType,
        'name': name ?? '', // Stockage du nom (vide si non fourni)
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Connexion avec email et mot de passe
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Messages d'erreur améliorés
      switch (e.code) {
        case 'user-not-found':
          throw Exception('Aucun compte ne correspond à cet e-mail.');
        case 'wrong-password':
          throw Exception('Mot de passe incorrect. Veuillez réessayer.');
        case 'invalid-email':
          throw Exception('Format d\'e-mail invalide.');
        case 'user-disabled':
          throw Exception('Ce compte a été désactivé. Veuillez contacter le support.');
        case 'too-many-requests':
          throw Exception('Trop de tentatives de connexion. Veuillez réessayer plus tard.');
        default:
          throw Exception('Erreur de connexion: ${e.message}');
      }
    } catch (e) {
      throw Exception('Une erreur s\'est produite. Veuillez réessayer.');
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Récupérer le type d'utilisateur (propriétaire ou locataire)
  Future<String?> getUserType() async {
    try {
      if (currentUser != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .get();
        
        if (userDoc.exists) {
          return userDoc.get('userType') as String?;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Récupérer le nom de l'utilisateur
  Future<String?> getUserName() async {
    try {
      if (currentUser != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .get();
        
        if (userDoc.exists && userDoc.data() is Map<String, dynamic>) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          return userData['name'] as String?;
        }
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération du nom: $e');
      return null;
    }
  }

  // Changer le mot de passe
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // Vérifier que l'utilisateur est connecté
      final user = currentUser;
      if (user == null) {
        throw Exception('Aucun utilisateur connecté');
      }
      
      // Récupérer l'email de l'utilisateur
      final email = user.email;
      if (email == null) {
        throw Exception('Email de l\'utilisateur non disponible');
      }
      
      // Réauthentifier l'utilisateur avec son mot de passe actuel
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      
      try {
        await user.reauthenticateWithCredential(credential);
      } catch (e) {
        if (e is FirebaseAuthException) {
          if (e.code == 'wrong-password') {
            throw Exception('Le mot de passe actuel est incorrect');
          } else if (e.code == 'too-many-requests') {
            throw Exception('Trop de tentatives échouées. Veuillez réessayer plus tard');
          } else if (e.code == 'user-not-found') {
            throw Exception('Utilisateur non trouvé');
          }
        }
        rethrow;
      }
      
      // Changer le mot de passe
      try {
        await user.updatePassword(newPassword);
      } catch (e) {
        if (e is FirebaseAuthException) {
          if (e.code == 'weak-password') {
            throw Exception('Le nouveau mot de passe est trop faible');
          } else if (e.code == 'requires-recent-login') {
            throw Exception('Veuillez vous reconnecter avant de changer votre mot de passe');
          }
        }
        rethrow;
      }
    } catch (e) {
      print('Erreur lors du changement de mot de passe: $e');
      rethrow;
    }
  }
}