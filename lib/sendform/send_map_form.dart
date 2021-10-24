// ignore_for_file: require_trailing_commas

import 'dart:io';
import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enigmamap520/Models/auth.dart';
import 'package:enigmamap520/SendForm/upload_complete.dart';
import 'package:enigmamap520/translation/localizations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class SendForm extends StatefulWidget {
  const SendForm({Key key, @required this.latitude, @required this.longitude})
      : super(key: key);
  final String longitude;
  final String latitude;

  @override
  // ignore: no_logic_in_create_state
  _SendFormState createState() => _SendFormState(longitude, latitude);
}

class _SendFormState extends State<SendForm> {
  Reference storageRef = FirebaseStorage.instance.ref();
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  File file;
  final ImagePicker picker = ImagePicker();
  String postId = const Uuid().v4();
  bool isUploading;
  String userName;
  String userImg;
  UploadTask task;
  bool isTyped = false;
  String standardImg =
      'https://firebasestorage.googleapis.com/v0/b/enigma-map-87c99.appspot.com/o/enigmamaplogo.png?alt=media&token=aa2c501d-b885-49bc-9a5d-fd7695ed36b8';
  bool isImgPicked = false;
  final DateTime now = DateTime.now();

  Future<void> _handleInfo() async {
    try {
      final GoogleSignInAccount data = await googleSignIn.signIn();
      setState(() {
        if (data != null) {
          userName = data.displayName;
          userImg = data.photoUrl;
        }
      });
    } catch (error) {
      return error;
    }
  }

  Future<void> getImage() async {
    final PickedFile pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 13);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
        isImgPicked = true;
      } else {
        debugPrint('Nenhum imagem selecionada');
        file = File(standardImg);
        isImgPicked = false;
      }
    });
  }

  String longitude;
  String latitude;
  // ignore: sort_constructors_first
  _SendFormState(this.longitude, this.latitude);

  //setting down here the controllers
  final TextEditingController titleController = TextEditingController(); //Title
  final TextEditingController descriptionController =
      TextEditingController(); //Description
  final TextEditingController subtitleController =
      TextEditingController(); //Nome do local
  final TextEditingController firstDetailController =
      TextEditingController(); //Primeiro detalhe
  final TextEditingController secondDetailController =
      TextEditingController(); //Segundo detalhe
  final TextEditingController fontController =
      TextEditingController(); //Fonte do usuário

  dynamic checkTextFieldIsEmptyOrNot() {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      isTyped = false;
    } else {
      isTyped = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _handleInfo();
  }

  String imgID;

  @override
  Widget build(BuildContext context) {
    setState(() {
      checkTextFieldIsEmptyOrNot();
    });

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  AppLocalizations.instance.translate('fill_the_fields_two'),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              if (file == null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 82,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey,
                    ),
                    child: GestureDetector(
                      onTap: getImage,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.backup,
                            color: Colors.white70,
                          ),
                          Center(
                            child: Text(
                              AppLocalizations.instance.translate('pick_image'),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                showPhotoDetails(),
              const SizedBox(
                height: 10,
              ),
              BeautyTextfield(
                width: double.maxFinite,
                height: 60,
                duration: const Duration(milliseconds: 300),
                inputType: TextInputType.text,
                placeholder: AppLocalizations.instance.translate('title'),
                maxLines: 2,
                onChanged: (String text) {
                  titleController.text = text;
                  if (text.isEmpty) {
                    isTyped = false;
                  } else {
                    isTyped = true;
                  }
                },
                prefixIcon: const Icon(Icons.label),
              ),
              BeautyTextfield(
                width: double.maxFinite,
                height: 120,
                duration: const Duration(milliseconds: 300),
                inputType: TextInputType.text,
                placeholder: AppLocalizations.instance.translate('description'),
                onChanged: (String text) {
                  descriptionController.text = text;
                },
                prefixIcon: const Icon(Icons.edit),
              ),
              BeautyTextfield(
                width: double.maxFinite,
                height: 60,
                duration: const Duration(milliseconds: 300),
                inputType: TextInputType.text,
                placeholder:
                    AppLocalizations.instance.translate('first_detail'),
                onChanged: (String text) {
                  firstDetailController.text = text;
                },
                prefixIcon: const Icon(Icons.add),
              ),
              BeautyTextfield(
                width: double.maxFinite,
                height: 60,
                duration: const Duration(milliseconds: 300),
                inputType: TextInputType.text,
                placeholder: AppLocalizations.instance.translate('font'),
                onChanged: (String text) {
                  fontController.text = text;
                },
                prefixIcon: const Icon(Icons.public),
              ),
              const Text(
                'Caso não tenha fonte, deixe em branco',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(
                height: 32,
              ),
              if (isTyped == true)
                sendButton()
              else
                const SizedBox(
                  height: 0,
                ),
            ],
          ),
        ),
      ),
    );
  }

  dynamic circularProgress() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: const Center(
          child: LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
          ),
        ));
  }

  Future<void> uploadImage(File imageFile) async {
    final UploadTask uploadTask =
        storageRef.child('post_$postId.jpg').putFile(imageFile);

    imgID = 'post_$postId.jpg';

    // setState(() async {
    //   imgID = 'post_$postId.jpg';
    //   return circularProgress();
    // });

    // if (uploadTask.) {
    //   return circularProgress();
    // }

    // ignore: void_checks
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) async {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    });
  }

  dynamic handleSubmit() async {
    setState(() {
      isUploading = true;
    });

    if (isImgPicked == true) {
      final String mediaUrl = uploadImage(file) as String;
      addUserPost(
        mediaUrl: mediaUrl,
      );
    } else {
      addUserPost(mediaUrl: standardImg);
    }

    setState(() {
      file = null;
      isUploading = false;
      postId = const Uuid().v4();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => UploadCompleteScreen(),
        ),
      );
    });
  }

  Widget showPhotoDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 220,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(file),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  dynamic addUserPost({String mediaUrl}) async {
    final double lat = double.tryParse(latitude);
    final double long = double.tryParse(longitude);
    final GeoFirePoint point = geo.point(latitude: lat, longitude: long);

    firestoreInstance.collection('Categories/Ovnis/Sites').add({
      'imageID': imgID,
      'ImageURL': mediaUrl,
      'description': descriptionController.text,
      'title': titleController.text,
      'siteName': titleController.text,
      'authorName': userName,
      'authorImage': userImg,
      'fontUrl': fontController.text,
      'location': point.geoPoint,
      'status': 'pending',
      'otherOptions': ['Compartilhar', 'Pedir revisão'],
      'details': {
        'Primeiro detalhe': firstDetailController.text,
      }
    });
  }

  Widget sendButton() {
    return GestureDetector(
      onTap: () {
        handleSubmit();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xff111724),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  AppLocalizations.instance.translate('send_button'),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
