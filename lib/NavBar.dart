


import 'package:flutter/material.dart';
import 'package:expense_tracker/EditProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late String name = '';

  @override
  void initState() {
    super.initState();
    // Fetch saved name from SharedPreferences
    _loadProfileData();
  }

  // Function to load profile data from SharedPreferences
  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
    });
  }

  // Function to show the edit profile dialog
  Future<void> _showEditProfileDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => EditProfileDialog(),
    );

    // Reload profile data after editing
    _loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 242, 239, 239),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              '''Hi! $name''',
              
              style: TextStyle(fontSize: 22),
            ),
           
            // Use an empty Text widget as a placeholder for accountEmail
            accountEmail: Text(''),

            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 139, 6),
            ),
          ),
          //  UserAccountsDrawerHeader(accountName: '$name',),
          Divider(),
          _buildAnimatedListTile(
            icon: Icons.person,
            title: 'Edit Profile',
            onTap: () => _showEditProfileDialog(context),
          ),
          Divider(),
          _buildAnimatedListTile(
            icon: Icons.exit_to_app,
            title: 'Exit',
            onTap: () {
              Navigator.pop(context); // Close the drawer
            },
          ),
          Divider(),
          _buildAnimatedListTile(
            icon: Icons.refresh,
            title: 'Refresh',
            onTap: () {
              // icon: Icon(Icons.refresh);
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedListTile(
      {required IconData icon,
      required String title,
      required Function onTap}) {
    return InkWell(
      onTap: () => onTap(),
      child: ListTile(
        leading: Icon(icon),
        title: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Text(title),
        ),
      ),
    );
  }
}
