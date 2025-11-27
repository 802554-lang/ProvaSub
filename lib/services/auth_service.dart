import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future<String?> registerWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Cadastro realizado com sucesso!";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'A senha fornecida é muito fraca.';
      } else if (e.code == 'email-already-in-use') {
        return 'O e-mail já está em uso por outra conta.';
      } else {
        return e.message; 
      }
    } catch (e) {
      return 'Ocorreu um erro desconhecido.';
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Nenhum usuário encontrado para este e-mail.';
      } else if (e.code == 'wrong-password') {
        return 'Senha incorreta fornecida para este usuário.';
      } else {
        return e.message; 
      }
    } catch (e) {
      return 'Ocorreu um erro desconhecido.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}