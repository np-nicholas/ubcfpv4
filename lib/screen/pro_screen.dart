import 'package:flutter/material.dart';
import 'package:ubcfpv3/screen/posts.dart';
import 'package:firebase_database/firebase_database.dart';



class ProScreen extends StatefulWidget {
  @override
  _ProScreenState createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  List <Posts> postsList = [];

  void initState() {
    super.initState();

    DatabaseReference postsRef = FirebaseDatabase.instance.reference().child("Posts");

    postsRef.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      postsList.clear();

      for(var individuakey in KEYS)
        {
          Posts posts = new Posts
        (
          DATA[individuakey]['image'],
          DATA[individuakey]['description'],
          DATA[individuakey]['date'],
          DATA[individuakey]['time'],
          DATA[individuakey]['shopname'],
      );
          postsList.add(posts);
        }
      setState(() {
        print('Length : $postsList.length');
      });
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      home: Scaffold (
        body: Center(

          child: postsList.length == 0 ? new Text("กำลังโหลดโปรโมชั่น") : new ListView.builder
            (
              itemCount: postsList.length,
              itemBuilder: (_, index)
              {
                return PostsUI(postsList[index].image, postsList[index].description, postsList[index].date, postsList[index].time,postsList[index].shopname,);
              }
          )



        ),





      )

    );


  }
  Widget PostsUI(String image, String description, String data, String time, String shopname){
    return new Card(

      elevation: 4.0,
      margin: EdgeInsets.all(10.0),

      child: new Container(
        padding: new EdgeInsets.all(10.0),
        child:  new Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
           new Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,

             children: <Widget>[
               new Text
                     (
                     shopname,
                     style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
                   ),
               IconButton(icon: Icon(Icons.more_horiz), onPressed: (){})
             ],

           ),

            SizedBox(height: 10.0,),

            new Image.network(image, fit: BoxFit.cover,),

            SizedBox(height: 10.0,),

                  new Text
                    (
                    description,
                    style: TextStyle(fontSize: 17.0),
                    textAlign: TextAlign.center,
                  ),


            SizedBox(height: 10.0,),

            new Text
              (
              data + "  " + time,
              style: TextStyle(fontSize: 15.0,color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            ListTile(
              title: new Text
                (
                "เข้าดูรายละเอียดเพิ่มเติม ++ ",
                style: TextStyle(fontSize: 17.0),
                textAlign: TextAlign.center,
              ),
              onTap: (){},
            )
          ],
        ),
      ),
    );
  }
}