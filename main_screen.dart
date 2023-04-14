import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:perpet/screens/IoT_screen.dart';
import 'package:perpet/screens/community_screen.dart';
import 'package:perpet/screens/diary_calender_screen.dart';
import 'package:perpet/screens/myPage_screen.dart';
import 'package:perpet/screens/home_screen.dart';
import 'package:perpet/screens/diary_write_screen.dart';
import 'package:perpet/screens/login_screen.dart';
import 'package:perpet/screens/sign_up_pet_screen.dart';
import 'package:perpet/screens/sign_up_user_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          //LoginScreen(),
          //SignUpUserScreen(),
          //SignUpPetScreen(),
          //WriteScreen(),
          HomeScreen(),
          DiaryScreen(),
          IoTScreen(),
          CommunityScreen(),
          myPageScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.pink[50],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(FontAwesomeIcons.home),
            backgroundColor: Colors.pink[100],
            label: "",
          ),
          BottomNavigationBarItem(
            icon: const Icon(FontAwesomeIcons.book),
            backgroundColor: Colors.pink[100],
            label: "",
          ),
          BottomNavigationBarItem(
            icon: const Icon(FontAwesomeIcons.ellipsisH),
            backgroundColor: Colors.pink[100],
            label: "",
          ),
          BottomNavigationBarItem(
            icon: const Icon(FontAwesomeIcons.comment),
            backgroundColor: Colors.pink[100],
            label: "",
          ),
          BottomNavigationBarItem(
            icon: const Icon(FontAwesomeIcons.user),
            backgroundColor: Colors.pink[100],
            label: "",
          ),
        ],
      ),
    );
  }
}
