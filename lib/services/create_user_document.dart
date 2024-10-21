import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

Future<void> createUserDocument(String? uid, String? email) async {
  Logger().d("User ID: $uid");
  Logger().d("Email: ${email ?? 'No email provided'}");

  if (uid == null) {
    Logger().e("UID is null. User document will not be created.");
    return; // Early exit if uid is null
  }

  DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(uid);
  DocumentSnapshot userSnapshot = await userRef.get();

  if (!userSnapshot.exists) {
    Logger().d("Creating document for user ID: $uid");
    await userRef.set({
      'uid': uid,
      'email': email ?? "",
      'recipeCount': 0,
    });
    Logger().d("User document created successfully.");
  } else {
    Logger().d("User document already exists.");
  }
}
