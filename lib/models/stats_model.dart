import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
int amountOfPosts = 0;

Future<void> getAmount() async{
  firestore.collection('Categories').doc('Ovnis').collection('stats').get().then((querySnapshot){
    querySnapshot.docs.forEach((result) {
      print(result.data()['stats_amount']);

      amountOfPosts = result.data()['stats_amount'];
    });
  });
}