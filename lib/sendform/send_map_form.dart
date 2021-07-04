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
  final String longitude;
  final String latitude;

  SendForm(
      {Key key,
        @required this.latitude,
        @required this.longitude})
      : super(key: key);

  @override
  _SendFormState createState() =>
      _SendFormState(longitude, latitude);
}

class _SendFormState extends State<SendForm> {
  StorageReference storageRef = FirebaseStorage.instance.ref();
  final firestoreInstance = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  File file;
  final picker = ImagePicker();
  String postId = Uuid().v4();
  bool isUploading = false;
  String userName;
  String userImg;
  StorageUploadTask task;
  bool isTyped = false;
  String standardImg =
      'https://firebasestorage.googleapis.com/v0/b/enigma-map-87c99.appspot.com/o/enigmamaplogo.png?alt=media&token=aa2c501d-b885-49bc-9a5d-fd7695ed36b8';
  bool isImgPicked = false;
  final DateTime now = DateTime.now();

  Future<void> _handleInfo() async {
    try {
      GoogleSignInAccount data = await googleSignIn.signIn() ?? null;
      print(data.toString());
      setState(() {
        if (data != null) {
          userName = data.displayName.toString();
          userImg = data.photoUrl.toString();
        }
      });
    } catch (error) {
      print(error);
    }
  }

  Future getImage() async {
    final pickedFile =
    await picker.getImage(source: ImageSource.gallery, imageQuality: 13);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
        print(pickedFile.path);
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
  _SendFormState(this.longitude, this.latitude);

  //setting down here the controllers
  final titleController = TextEditingController(); //Title
  final descriptionController = TextEditingController(); //Description
  final subtitleController = TextEditingController(); //Nome do local
  final firstDetailController = TextEditingController(); //Primeiro detalhe
  final secondDetailController = TextEditingController(); //Segundo detalhe
  final fontController = TextEditingController(); //Fonte do usuário

  checkTextFieldIsEmptyOrNot() {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty) {
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

    return isUploading == false
        ? Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: Container(
                  child: Text(
                    AppLocalizations.instance
                        .translate('fill_the_fields_two'),
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              file == null
                  ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
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
                      children: [
                        Icon(
                          Icons.backup,
                          color: Colors.white70,
                        ),
                        Center(
                          child: Text(
                            AppLocalizations.instance
                                .translate('pick_image'),
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  : showPhotoDetails(),
              SizedBox(
                height: 10,
              ),
              BeautyTextfield(
                width: double.maxFinite,
                height: 60,
                duration: Duration(milliseconds: 300),
                inputType: TextInputType.text,
                placeholder: AppLocalizations.instance
                    .translate('title'),
                maxLines: 2,
                onChanged: (text) {
                  titleController.text = text;
                  print(titleController.text);
                  if (text.isEmpty) {
                    isTyped = false;
                  } else {
                    isTyped = true;
                  }
                },
                prefixIcon: Icon(Icons.label),
              ),
              BeautyTextfield(
                width: double.maxFinite,
                height: 120,
                duration: Duration(milliseconds: 300),
                inputType: TextInputType.text,
                placeholder: AppLocalizations.instance
                    .translate('description'),
                autocorrect: false,
                onChanged: (text) {
                  descriptionController.text = text;
                  print(descriptionController.text);
                },
                prefixIcon: Icon(Icons.edit),
              ),
              BeautyTextfield(
                width: double.maxFinite,
                height: 60,
                duration: Duration(milliseconds: 300),
                inputType: TextInputType.text,
                placeholder: AppLocalizations.instance
                    .translate('first_detail'),
                onChanged: (text) {
                  firstDetailController.text = text;
                  print(firstDetailController.text);
                },
                prefixIcon: Icon(Icons.add),
              ),
              BeautyTextfield(
                width: double.maxFinite,
                height: 60,
                duration: Duration(milliseconds: 300),
                inputType: TextInputType.text,
                placeholder: AppLocalizations.instance
                    .translate('font'),
                onChanged: (text) {
                  fontController.text = text;
                  print(fontController.text);
                },
                prefixIcon: Icon(Icons.public),
              ),
              Text('Caso não tenha fonte, deixe em branco', style: TextStyle(color: Colors.white70),),
              SizedBox(
                height: 32,
              ),
              isTyped == true
                  ? sendButton()
                  : SizedBox(
                height: 0,
              ),

            ],
          ),
        ),
      ),
    )
        : circularProgress();
  }

  circularProgress() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Center(
          child: LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.purple),
          ),
        ));
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
    storageRef.child("post_$postId.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;

    setState(() {
      imgID = ("post_$postId.jpg");
      print("post_$postId.jpg");
      return circularProgress();
    });

    if (uploadTask.isInProgress) {
      return circularProgress();
    } /*else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UploadCompleteScreen()),
      );
    }*/

    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });

    if (isImgPicked == true) {
      String mediaUrl = await uploadImage(file);
      addUserPost(
        mediaUrl: mediaUrl,
      );
    } else {
      addUserPost(mediaUrl: standardImg);
    }

    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UploadCompleteScreen()),
      );
    });
  }

  showPhotoDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
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

  addUserPost({String mediaUrl}) async {
    var lat = double.tryParse(latitude);
    var long = double.tryParse(longitude);
    GeoFirePoint point = geo.point(latitude: lat, longitude: long);

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

  sendButton() {
    return GestureDetector(
      onTap: isUploading ? false : () => handleSubmit(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xff111724),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  AppLocalizations.instance
                      .translate('send_button'),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}