import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
int amountOfPosts = 0;

Future<void> getAmount() async {
  firestore
      .collection('Categories')
      .doc('Ovnis')
      .collection('stats')
      .get()
      .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
    for (final QueryDocumentSnapshot<Map<String, dynamic>> result
        in querySnapshot.docs) {
      amountOfPosts = result.data()['stats_amount'] as int;
    }
  });
}
