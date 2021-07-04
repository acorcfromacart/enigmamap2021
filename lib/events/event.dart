import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<QuerySnapshot> checkingUfoSights() async {
  Stream<QuerySnapshot> sights =
  firestore.collection('Categories/Ovnis').orderBy('status').snapshots();

  return sights.first;
}

Future<QuerySnapshot> checkingCategory() async {
  Stream<QuerySnapshot> categories = firestore
      .collection('Categories/' + 'Ovnis' + '/Sites/')
      .orderBy('status')
      .snapshots();

  return categories.first;
}
