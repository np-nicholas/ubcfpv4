import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ubcfpv3/screen/addpro_screen.dart';
import 'package:ubcfpv3/screen/login_screen.dart';
import 'package:ubcfpv3/screen/me_screen.dart';
import 'package:ubcfpv3/screen/pro_screen.dart';
import 'package:ubcfpv3/screen/stroe_screen.dart';
import 'package:ubcfpv3/screen/user.dart';
import 'package:firebase_auth/firebase_auth.dart';


GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class HomeScreen extends StatefulWidget {
  final FirebaseUser firebaseUser;

  HomeScreen({this.firebaseUser});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<Null> _handleSignOut() async {
    await _googleSignIn.disconnect();
    await facebookSignIn.logOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  int currentIndex = 0;
  List pages = [ProScreen(), StroeScreen(), MeScreen()];

  @override
  Widget build(BuildContext context) {
    Widget appBar = AppBar(
      backgroundColor: Colors.brown[400],
      title: Text(
        'UBONCOFFEEPRO',
      ),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.add), onPressed: () {
          Navigator.push
            (
              context,
              MaterialPageRoute(builder: (context)
              {
                return new AddproScreen ();
              })

          );
        }),
      ],
    );

    Widget bottomNavBar = BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on), title: Text('โปรโมชั่น')),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), title: Text('ร้านค้า')),
          BottomNavigationBarItem(
              icon: Icon(Icons.gps_fixed), title: Text('ใกล้ๆคุณ')),
        ]);

    Widget drawer = Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.firebaseUser.photoUrl,
                ),
              ),
              title: Text(
                widget.firebaseUser.displayName,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              subtitle: Text(
                widget.firebaseUser.email,
                style: TextStyle(color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill, image: AssetImage('assets/images/p24.jpg')),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.star,
              color: Colors.yellowAccent,
            ),
            title: Text(
              'ร้านที่คุณชอบ',
              style: TextStyle(fontSize: 20.0),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            subtitle: Text('แสดงข้อมูลที่คุณกดให้ดาวไว้'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.forum,
              color: Colors.redAccent,
            ),
            title: Text(
              'ร้านที่กำลังมาแรง',
              style: TextStyle(fontSize: 20.0),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            subtitle: Text('แสดงร้านที่มีคนใช้โปรโมชั่นเยอะที่สุด'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.contacts,
              color: Colors.orangeAccent,
            ),
            title: Text(
              'ติดต่อ',
              style: TextStyle(fontSize: 20.0),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            subtitle: Text('หากสนใจลงโฆษณา หรือแจ้งปัญหาการใช้งานm'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.directions_bike,
              color: Colors.deepPurple,
            ),
            title: Text(
              'สั่งเดลิเวอรี่',
              style: TextStyle(fontSize: 20.0),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            subtitle: Text('สามารถสั่งไปส่งได้ ผ่านแอปพลิเคชั่น'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.green,
            ),
            title: Text(
              'ตั้งค่า',
              style: TextStyle(fontSize: 20.0),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            subtitle: Text('ตั้งค่าต่างๆ'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            title: Text(
              'ออกจากระบบ',
              style: TextStyle(fontSize: 20.0),
            ),
            trailing: Icon(
              Icons.exit_to_app,
              color: Colors.blue,
            ),
            subtitle: Text('ขอบคุณที่ใช้บริการแอปของเรา'),
            onTap: () => _handleSignOut(),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: pages[currentIndex],
      bottomNavigationBar: bottomNavBar,
      resizeToAvoidBottomPadding: true,
    );
  }
}
