import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/Models/user.dart';
import 'package:shop_app/Services/database.dart';

class AuthServices {
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  signInOTP(smsCode, verId, name, phoneNo) {
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);

    signIn(authCredential: authCredential, name: name, phoneNo: phoneNo);
  }

  User _fromFirebaseUser(FirebaseUser user) {
    return user != null ? User(id: user.uid, phone: this.phoneNo) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_fromFirebaseUser);
  }

  Future verifyPhone(String phonenumber) async {
    print('otp send');
    this.phoneNo = phonenumber;
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo,
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
          },
          codeSent: smsOTPSent,
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            _auth
                .signInWithCredential(phoneAuthCredential)
                .then((AuthResult val) {
              if (val.user != null) onAuthSuccess();
            });
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {}
  }

  onAuthSuccess() async {
    print("suth success " + this.phoneNo);

    final snapShot = await Firestore.instance
        .collection('posts')
        .document(this.phoneNo)
        .get();

    if (snapShot == null || !snapShot.exists) {
      print("Does not exits");
      DatabaseServices().createUser(this.phoneNo);
    } else {
      print("Exits");
    }
  }

  // Future signIn(String otp) async {
  //   this.smsOTP = otp;
  //   try {
  //     final AuthCredential credential = PhoneAuthProvider.getCredential(
  //       verificationId: verificationId,
  //       smsCode: smsOTP,
  //     );
  //     final user = await _auth.signInWithCredential(credential);
  //     final FirebaseUser currentUser = await _auth.currentUser();
  //     assert(user.user.uid == currentUser.uid);
  //     onAuthSuccess();
  //   } catch (e) {}
  // }
  signIn({AuthCredential authCredential, String name, String phoneNo}) async {
    this.phoneNo = phoneNo;
    print("On sign in " + phoneNo);
    AuthResult result = await _auth.signInWithCredential(authCredential);
    FirebaseUser user = result.user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    onAuthSuccess();

    // await DataBaseServices(uid: user.uid).createUserDatabase(name, phoneNo);
  }

  void signOut() {
    print("Logout call");
    _auth.signOut();
  }
}
