import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'linkup_feed.dart';

/* Allowing the user to make edits */
class EditProfile extends StatefulWidget {
  final String userId;
  const EditProfile({Key? key, required this.userId}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // setting relevant variables
  String _userId = '';
  String _errorMsg = '';
  String? _selectedVal;
  final _formKey = GlobalKey<FormState>();

  String _dob = '';
  String _yearGroup = '';
  String _major = '';
  String _residence = '';
  String _food = '';
  String _movie = '';

  // declaring controllers
  late TextEditingController _userDoBCtrl;
  late TextEditingController _userYearCtrl;
  late TextEditingController _userMajorCtrl;
  late TextEditingController _userResidenceCtrl;
  late TextEditingController _userFoodCtrl;
  late TextEditingController _userMovieCtrl;

  void getUserDeets(String userId) async {
    // returning the users details to be displayed in the form
    final user = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    setState(() { // set the relevant strings to be placed in the controllers
      _dob = user['DOB'];
      _yearGroup = user['year_grp'];
      _major = user['major'];
      _residence = user['residence'];
      _food = user['fav_food'];
      _movie = user['fav_movie'];
    });
  }

  @override
  void initState() {
    super.initState();
    _userId = widget.userId; //setting the user to the logged in user
    getUserDeets(_userId); // getting the details
  }

  void _showErrorDialog(errorMsg) {
    // display any error in the alert box
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMsg),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateUserDeets() async{
    // allowing the users details to be updated through the api
    final response = await http.patch(
        Uri.parse('https://webtechfinals-383417.uc.r.appspot.com/users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      body: jsonEncode(<String, String>{ // setting the fields to the items in the controllers
        "stu_id": _userId,
        "DOB": _userDoBCtrl.text,
        "year_grp": _userYearCtrl.text,
        "major": _userMajorCtrl.text,
        "residence": _userResidenceCtrl.text,
        "fav_food": _userFoodCtrl.text,
        "fav_movie": _userMovieCtrl.text,
      }),
    );

    if (response.statusCode == 200){
      // navigate back to feed page if successful
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Content(userId: _userId,)
        ),
      );
    } else{
      Map<String, dynamic> errorJson = json.decode(response.body);
      _errorMsg = errorJson['error'];
      _showErrorDialog(_errorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    //setting controllers to hold data retrieved from the database
    _userDoBCtrl = TextEditingController(text: _dob);
    _userYearCtrl = TextEditingController(text: _yearGroup);
    _userMajorCtrl = TextEditingController(text: _major);
    _userResidenceCtrl = TextEditingController(text: _residence);
    _userFoodCtrl = TextEditingController(text: _food);
    _userMovieCtrl = TextEditingController(text: _movie);

    // setting the structure for the page
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                AppColors.linkUpText,
                Text(
                  "   -   Edit Profile",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            )
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 500.0,
            height: 500.0,
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      children: [
                        Text(
                          'Update your profile',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Fill in the fields you want to change',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        )
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: _userDoBCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Date of Birth',
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  TextFormField(
                    controller: _userYearCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Year Group',
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  TextFormField(
                    controller: _userMajorCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Major',
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  TextFormField(
                    controller: _userResidenceCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Residence',
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  TextFormField(
                    controller: _userFoodCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Favourite Food',
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  TextFormField(
                    controller: _userMovieCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Favourite Movie',
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _updateUserDeets,
                      child: Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}