

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

 UserCredential userCredential = 
      await FirebaseAuth.instance.signInWithCredential(credential);

  if (userCredential.user != null && userCredential.user!.email != null && userCredential.user!.displayName != null) {
    String email = userCredential.user!.email!;
    String displayName = email.split('@').first; // Hapus bagian setelah @
    
    await userCredential.user!.updateDisplayName(displayName);
    
    // Perbarui data user lokal
    await userCredential.user!.reload();
  }

    // Once signed in, return the UserCredential
    return userCredential;
  }