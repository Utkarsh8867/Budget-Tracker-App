// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class EditProfile extends StatefulWidget {
//   const EditProfile({Key? key});

//   @override
//   _EditProfileState createState() => _EditProfileState();
// }

// class _EditProfileState extends State<EditProfile> {
//   late TextEditingController _name;
//   late TextEditingController _email;

//   @override
//   void initState() {
//     super.initState();
//     // Fetch previously saved values from SharedPreferences if any
//     _loadProfileData();
//     _name = TextEditingController();
//     _email = TextEditingController();
//   }

//   // Function to load profile data from SharedPreferences
//   _loadProfileData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _name.text = prefs.getString('name') ?? '';
//       _email.text = prefs.getString('email') ?? '';
//     });
//   }

//   // Function to save profile data to SharedPreferences
//   _saveProfileData(String name, String email) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('name', name);
//     await prefs.setString('email', email);
//   }

//   @override
//   void dispose() {
//     _name.dispose();
//     // _email.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Profile'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedContainer(
//               duration: Duration(milliseconds: 500),
//               curve: Curves.easeInOut,
//               width: 300,
//               height: 60,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30),
//                 color: Color.fromARGB(255, 255, 125, 65),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: TextField(
//                   controller: _name,
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     hintText: 'Enter your Name',
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 // Save the profile data to SharedPreferences
//                 _saveProfileData(_name.text, _email.text);
//                 // Navigate back to the previous screen
//                 Navigator.pop(context);
//               },
//               child: Text('Save'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({Key? key}) : super(key: key);

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _name;
  late TextEditingController _email;

  @override
  void initState() {
    super.initState();
    // Fetch previously saved values from SharedPreferences if any
    _loadProfileData();
    _name = TextEditingController();
    _email = TextEditingController();
  }

  // Function to load profile data from SharedPreferences
  _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name.text = prefs.getString('name') ?? '';
      _email.text = prefs.getString('email') ?? '';
    });
  }

  // Function to save profile data to SharedPreferences
  _saveProfileData(String name, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              decoration: InputDecoration(
                hintText: 'Enter your Name',
              ),
            ),
            TextField(
              controller: _email,
              decoration: InputDecoration(
                hintText: 'Enter your Email',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            // Save the profile data to SharedPreferences
            _saveProfileData(_name.text, _email.text);
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

