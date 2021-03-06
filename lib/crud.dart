import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class Crud {
  String collectionName = 'data';

  Crud([String? collection]) {
    this.collectionName = collection ?? 'data';
    return;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _uid = _auth.currentUser!.uid.toString();

  addUser({Position? loc}) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(this.collectionName);

    List<String> SearchQueries = [];

    for (var i = 1; i <= this._auth.currentUser!.displayName!.length; i++) {
      SearchQueries.add(this._auth.currentUser!.displayName!.substring(0, i));
    }

    print(_uid);
    //var loc = {"Latitude": lat, "Longitude": long};
    await collectionReference.doc(_uid).set({
      "full_name": this._auth.currentUser!.displayName.toString(),
      "email": this._auth.currentUser!.email.toString(),
      "uid": _uid,
      "location": loc.toString(),
      "SearchQueries": FieldValue.arrayUnion(SearchQueries),
    });
    print("New user added");
    return;
  }

  fetchData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(this.collectionName);

    await collectionReference.doc(_uid).get().then((value) {
      return value.data();
    });
  }

  updateData({String? full_name, String? email}) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(this.collectionName);
    print(full_name);
    print(email);
    if (full_name != null) {
      List<String> SearchQueries = [];

      for (var i = 1; i <= full_name.length; i++) {
        SearchQueries.add(full_name.substring(0, i));
      }

      collectionReference.doc(_auth.currentUser!.uid.toString()).update({
        "full_name": full_name,
        "SearchQueries": FieldValue.delete(),
      });
      collectionReference.doc(_auth.currentUser!.uid.toString()).update({
        "SearchQueries": FieldValue.arrayUnion(SearchQueries),
      });

      print("full_name updated");
      print(_auth.currentUser!.uid.toString());
    }
    if (email != null) {
      collectionReference.doc(_auth.currentUser!.uid.toString()).update({
        "email": email,
      });
      print("email updated");
      print(_auth.currentUser!.uid.toString());
    }
    print(this.collectionName);
  }

  deleteData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(this.collectionName);
    await collectionReference.doc(_uid).delete().then((_) {
      print("User deleted");
    });
  }

  deleteUser() async {
    deleteData();
    _auth.currentUser!.delete();
  }

  UpdateUser({String? full_name, String? email}) async {
    if (full_name != null) {
      _auth.currentUser!.updateDisplayName(full_name);
    }
    if (email != null) {
      _auth.currentUser!.updateEmail(email);
    }
    updateData(full_name: full_name, email: email);
  }
}
