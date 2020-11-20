import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tugas_firebase_wisata/services/shared_preference_service.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  SharedPrefService prefService = SharedPrefService();

  Future<User> getCurrentuser() async {
    User user = _auth.currentUser;
    return user;
  }

  Future<User> handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn().catchError((onError) => print(onError));

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential authResult = await _auth.signInWithCredential(credential);
      final User user = authResult.user;

      if (user != null) {
        await prefService.saveDataPref(
          dataType: 'bool',
          key: 'isLogin',
          value: true,
        );

        return user;
      }

      return null;
    } catch (e) {
      print('Google Sign-In error');
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await prefService.clearLoginData();
  }
}
