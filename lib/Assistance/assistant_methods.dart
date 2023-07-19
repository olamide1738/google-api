import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:users/global/global.dart';

import '../models/user_model.dart';

class AssistantMethods {
  static void readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userReference =
        FirebaseDatabase.instance.ref().child("users").child(currentUser!.uid);

    userReference.once().then((snap) => {
          if (snap.snapshot.value != null)
            {userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot)}
        });
  }

}
