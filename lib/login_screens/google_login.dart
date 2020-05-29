import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fetchride/HomeScreens/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = GoogleSignIn();
  InitialLocation initialLocation = InitialLocation();

  void googleLogInUser() async {
    final GoogleSignInAccount googleSignInAccount = await _googlSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    _firebaseAuth.signInWithCredential(credential);

    final users = await Firestore.instance.collection('users').getDocuments();
    int cnt = 0;
    for (var user in users.documents) {
      if (user.data['email'] == googleSignInAccount.email) {
        cnt++;
        await initialLocation.getCurrentLocation().whenComplete(() {
          user.reference.updateData({
            'latitude': initialLocation.latitude,
            'longitude': initialLocation.longitude,
          });
        });
      }
    }
    if (cnt == 0) {
      await initialLocation.getCurrentLocation().whenComplete(() {
        Firestore.instance.collection('users').document('${googleSignInAccount.email}').setData({
          'email': googleSignInAccount.email,
          'displayName': googleSignInAccount.displayName,
          'id': googleSignInAccount.id,
          'photoUrl': googleSignInAccount.photoUrl,
          'latitude': initialLocation.latitude,
          'longitude': initialLocation.longitude,
        });
      });
    }
  }

  void googleLogOutUser() {
    GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
  }
}
