// import 'package:flutter/material.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:my_flutter_app/anasayfa.dart';
// import 'package:my_flutter_app/profil.dart';
// import 'package:my_flutter_app/tasiyicilan.dart';
// import 'package:my_flutter_app/yeni_anasayfa.dart';

// class yeniGiris extends StatefulWidget {
//   const yeniGiris({super.key});

//   @override
//   State<yeniGiris> createState() => _yenirGirisState();
// }

// class _yenirGirisState extends State<yeniGiris> {
//   List<Widget> pages = [
//     const yeniAnasayfa(),
//     const tasiyicilan(),
//     const profil(),
//   ];
//   int index = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: GNav(
//           onTabChange: (value) {
//             setState(() {
//               index=value;
//               print("object $value");
//             });
//           },
//           haptic: true, // haptic feedback
//           tabBorderRadius: 15,
//           curve: Curves.easeOutExpo, // tab animation curves
//           duration: const Duration(milliseconds: 900), // tab animation duration
//           gap: 8, // the tab button gap between icon and text
//           color: Colors.grey[800], // unselected icon color
//           iconSize: 24, // tab button icon size
//           activeColor: Colors.black,
//           padding: const EdgeInsets.symmetric(
//               horizontal: 20, vertical: 5), // navigation bar padding
//           tabs: [
//             const GButton(
//               icon: Icons.home,
//               text: 'Home',
//             ),
//             const GButton(
//               icon: Icons.list,
//               text: 'Ads',
//             ),
//             GButton(
//               icon: Icons.person,
//               text: 'Profile',
//               onPressed: () {
//                 //           Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(builder: (context) => const profil()), // LoginScreen, login.dart içinde tanımlanmış olmalıdır
//                 // );
//               },
//             )
//           ]),
//       body: pages[index],
//     );
//   }
// }
// // PageRouteBuilder _createRoute() {
// //   return PageRouteBuilder(
// //     pageBuilder: (context, animation, secondaryAnimation) => const profil(),
// //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
// //       const begin = Offset(1.0, 0.0);
// //       const end = Offset.zero;
// //       const curve = Curves.easeInOut;
// //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
// //       var offsetAnimation = animation.drive(tween);
// //       return SlideTransition(
// //         position: offsetAnimation,
// //         child: child,
// //       );
// //     },
// //   );
// // }