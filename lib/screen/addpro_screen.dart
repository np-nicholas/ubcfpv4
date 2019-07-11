import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ubcfpv3/screen/pro_screen.dart';
import 'package:ubcfpv3/screen/thank_screen.dart';
import 'package:ubcfpv3/screen/user.dart';
import 'dart:io';
import 'home_screen.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';




class AddproScreen extends StatefulWidget
{
  User userInfo;
  State<StatefulWidget> createState()
  {
    return _AddproScreenStatr();
  }
}


class _AddproScreenStatr extends State <AddproScreen>
{
  File sampleImage;
  String _myValue;
  String prourl;
  final formKey = new GlobalKey<FormState>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  Future getImage() async
  {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);



    setState(()
    {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave()
  {
    final form = formKey.currentState;

    if(form.validate())
    {
      form.save();
      return true;
    }
    else
    {
      return false;
    }
  }



  void uploadStatusImage() async
  {
    if(validateAndSave()) {
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("(Post Images");

      var timeKey = new DateTime.now();

      final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

      var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      prourl = ImageUrl.toString();

      print("Image Url = " + prourl);


      goToHomeScreen();
      saveToDatabase(prourl);
  }
}

void saveToDatabase(url) {
  var dbTimeKey = new DateTime.now();
  var formatData = new DateFormat('MMM d, yyyy');
  var formatTime = new DateFormat('EEEE, hh:mm aaa');

  String date = formatData.format(dbTimeKey);
  String time = formatTime.format(dbTimeKey);

  DatabaseReference ref = FirebaseDatabase.instance.reference();

  var data =  {
    "image": url,
    "description": _myValue,
    "date": date,
    "time": time,
  };

  ref.child("Posts").push().set(data);
}

void goToHomeScreen() async
{
  FirebaseUser firebaseUser = await firebaseAuth.currentUser();
  Navigator.push
    (
      context,
      MaterialPageRoute(builder: (context)
      {
        return new HomeScreen(firebaseUser: firebaseUser);
      }
      )
  );
}




  @override

  Widget build(BuildContext context)
  {
    return new Scaffold
      (
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        backgroundColor: Colors.brown[400],
        title: new Text("Add Promotion"),
        centerTitle: true,
      ),

      body: new Center
        (
        child: sampleImage == null? Text("เลือกรูปภาพที่คุณต้องการโปรโมท"): enableUpload(),
      ),
      floatingActionButton: new FloatingActionButton
        (
        onPressed: getImage,
        tooltip: 'Add Image',
        child:  new Icon(Icons.add_a_photo),backgroundColor: Colors.brown,
      ),

    );
  }
  Widget enableUpload()
  {
    return new Container
      (
      child: new Form
        (
        key:  formKey,

        child: Column
          (
          children: <Widget>
          [

            Image.file(sampleImage, height: 310.0,width: 660.0, ),

            SizedBox(height: 15.0,),

            TextFormField
              (
              maxLines: 2,
              decoration: new InputDecoration(labelText: 'description'),

              validator: (value){
                return value.isEmpty ? 'กรุณาใส่รายละเอียดเกี่ยวกับโปรโมชั่น' :null;
              },

              onSaved: (value){
                return _myValue = value;
              },

            ),

            SizedBox(height: 15.0,),

            RaisedButton
              (
              elevation: 10.0,
              child: Text('Add a New Post'),
              textColor: Colors.white,
              color: Colors.brown,

              onPressed: uploadStatusImage,
            )
          ],
        ),
      ),
    );
  }
}