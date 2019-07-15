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

          child: postsList.length == 0 ? new Text("No Blog Post availablr") : new ListView.builder
            (
              itemCount: postsList.length,
              itemBuilder: (_, index)
              {
                return PostsUI(postsList[index].image, postsList[index].description, postsList[index].date, postsList[index].time,);
              }
          )



        ),





      )

    );


  }
  Widget PostsUI(String image, String description, String data, String time){
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
                     data,
                     style: Theme.of(context).textTheme.subtitle,
                     textAlign: TextAlign.center,
                   ),

                   new Text
                     (
                     time,
                     style: Theme.of(context).textTheme.subtitle,
                     textAlign: TextAlign.center,
                   )
             ],
           ),

            SizedBox(height: 10.0,),

            new Image.network(image, fit: BoxFit.cover,),

            SizedBox(height: 10.0,),

                  new Text
                    (
                    description,
                    style: Theme.of(context).textTheme.subhead,
                    textAlign: TextAlign.center,
                  ),
            SizedBox(height: 10.0,),
            ListTile(
              title: Text('dsdsd',textAlign: TextAlign.center,),
              onTap: (){},
              trailing: IconButton(icon: Icon(Icons.more_vert,), onPressed: (){})
            )
          ],
        ),
      ),
    );
  }
}