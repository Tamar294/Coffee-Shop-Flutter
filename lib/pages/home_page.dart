// import 'package:coffee_new_app/components/bottom_nav_bar.dart';
// import 'package:coffee_new_app/const.dart';
// import 'package:coffee_new_app/pages/cart_page.dart';
// import 'package:coffee_new_app/pages/login_page.dart';
// import 'package:flutter/material.dart';

// import 'about_page.dart';
// import 'coffee_manager_page.dart';
// import 'shop_page.dart';

// class HomePage extends StatefulWidget {

//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;

//   void navigateBottomBar(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   final List _pages = [
//     ShopPage(),
//     CartPage(),
//   ];

//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       bottomNavigationBar: MyBottomNavBar(onTabChange:  navigateBottomBar),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: Builder(
//           builder: (context) => IconButton(
//             icon: Padding(
//               padding: EdgeInsets.all(14),
//               child: Icon(Icons.menu, color: Colors.black),
//             ),
//             onPressed: () {
//               Scaffold.of(context).openDrawer();
//             },
//           ),
//         ),
//       ),
//       drawer: Drawer(
//         backgroundColor: backgroundColor,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               children: [
//                 SizedBox(height: 80),
//                 Image.asset("lib/images/espresso.png", height: 160),
//                 Padding(
//                   padding: EdgeInsets.all(25),
//                   child: Divider(color: Colors.white),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 25),
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => HomePage()),
//                       );
//                     },
//                     child: ListTile(
//                       leading: Icon(Icons.home),
//                       title: Text("Home"),
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => AboutPage())
//                     );
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 25),
//                     child: ListTile(
//                       leading: Icon(Icons.info),
//                       title: Text("About"),
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => CoffeeManager())
//                     );
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 25),
//                     child: ListTile(
//                       leading: Icon(Icons.person_add),
//                       title: Text("Manage Priducts"),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => LoginPage())
//                     );
//               },
//               child: Padding(
//                 padding: EdgeInsets.only(left: 25, bottom: 25),
//                 child: ListTile(
//                   leading: Icon(Icons.logout),
//                   title: Text("Logout"),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//       body: _pages[_selectedIndex],
//     );
//   }
// }

import 'package:coffee_new_app/components/bottom_nav_bar.dart';
import 'package:coffee_new_app/const.dart';
import 'package:coffee_new_app/pages/cart_page.dart';
import 'package:coffee_new_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'about_page.dart';
import 'coffee_manager_page.dart';
import 'shop_page.dart';

class HomePage extends StatefulWidget {
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isManager = false;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [
    ShopPage(),
    CartPage(),
  ];

  @override
  void initState() {
    super.initState();
    _checkIfManager();
  }

  Future<void> _checkIfManager() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email == 'tamarcohen294@gmail.com') {
      setState(() {
        _isManager = true;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: MyBottomNavBar(onTabChange: navigateBottomBar),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Padding(
              padding: EdgeInsets.all(14),
              child: Icon(Icons.menu, color: Colors.black),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(height: 80),
                Image.asset("lib/images/espresso.png", height: 160),
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Divider(color: Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: ListTile(
                      leading: Icon(Icons.home),
                      title: Text("Home"),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AboutPage()));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: ListTile(
                      leading: Icon(Icons.info),
                      title: Text("About"),
                    ),
                  ),
                ),
                if (_isManager)
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CoffeeManager()));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 25),
                      child: ListTile(
                        leading: Icon(Icons.person_add),
                        title: Text("Manage Products"),
                      ),
                    ),
                  ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Padding(
                padding: EdgeInsets.only(left: 25, bottom: 25),
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                ),
              ),
            )
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
