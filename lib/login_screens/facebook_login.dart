//import 'package:firebase_auth/firebase_auth.dart';
//
//class FacebookAuth {
//  FacebookLogin facebookLogin = FacebookLogin();
//  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//
//  void facebookLoginUser() async {
//    final FacebookLoginResult result = await facebookLogin.logIn(['email']);
//    switch (result.status) {
//      case FacebookLoginStatus.loggedIn:
//        final FacebookAccessToken accessToken = result.accessToken;
//        final AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: '$accessToken');
//        _firebaseAuth.signInWithCredential(credential);
//        print('Successful');
//        print(accessToken.userId);
//        break;
//      case FacebookLoginStatus.cancelledByUser:
//        print('Cancelled');
//        break;
//      case FacebookLoginStatus.error:
//        print(result.errorMessage);
//        break;
//    }
//  }
//
//  Future<Null> logOut() async {
//    await facebookLogin.logOut();
//    _firebaseAuth.signOut();
//  }
//}
