import 'package:fetchride/login_screens/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuth {
  Future<void> phoneSignOut() async{
    FirebaseAuth.instance.signOut();
  }

  Future<void> phoneSignIn(AuthCredential authCreds) async{
    FirebaseAuth.instance.signInWithCredential(authCreds).whenComplete(() {

    });
    AuthService().handleAuth();
  }

  Future<void> phoneSignInWithOTP(smsCode, verId) async{
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    phoneSignIn(authCreds);
  }
}