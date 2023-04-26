import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'login.dart';
import 'linkup_feed.dart';
import 'custom_textField.dart';

/* Sign up page*/
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // defining text controllers
  final _userIdCtrl = TextEditingController();
  final _userNameCtrl = TextEditingController();
  final _userEmailCtrl = TextEditingController();
  final _userDoBCtrl = TextEditingController();
  final _userYearCtrl = TextEditingController();
  final _userMajorCtrl = TextEditingController();
  final _userResidenceCtrl = TextEditingController();
  final _userFoodCtrl = TextEditingController();
  final _userMovieCtrl = TextEditingController();

  // defining key variables
  String _errorMsg = '';
  String? _selectedVal;
  final _formKey = GlobalKey<FormState>();

  void _navigateToLogin() {
    // redirect user to login page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  void _showErrorDialog(errorMsg) {
    // display errors as an alert dialogue
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMsg),
          actions: [
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


  void _signUpUser() async{
    // signing up the user -sending the request to api
    final response = await http.post(
        Uri.parse('https://webtechfinals-383417.uc.r.appspot.com/users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      body: jsonEncode(<String, String>{
        "stu_id": _userIdCtrl.text,
        "name": _userNameCtrl.text,
        "email": _userEmailCtrl.text,
        "DOB": _userDoBCtrl.text,
        "year_grp": _userYearCtrl.text,
        "major": _userMajorCtrl.text,
        "residence": _userResidenceCtrl.text,
        "fav_food": _userFoodCtrl.text,
        "fav_movie": _userMovieCtrl.text,
      }),
    );

    if (response.statusCode == 200){
      // if user exists, navigate to feed page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Content(userId: _userIdCtrl.text,)),
      );
    } else{
      // display error message in the alert box
      Map<String, dynamic> errorJson = json.decode(response.body);
      _errorMsg = errorJson['error'];
      _showErrorDialog(_errorMsg);
    }
  }


  @override
  Widget build(BuildContext context) {
    //displaying layout of signup page
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              AppColors.linkUpText,
              Text(
                "   -   Sign Up",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child:
            Container(
                width: 600.0,
                height: 650.0,
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(20.0),
                  ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Welcome to LinkUp!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        const Text(
                          'Create an account or Log in if you already have an account',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          width: 400.0,
                          child: Column(
                              children: [
                                CustomTextField(
                                    text: 'User Id',
                                    ctrl: _userIdCtrl
                                ),
                                const SizedBox(height: 4.0),
                                CustomTextField(
                                    text: 'Name',
                                    ctrl: _userNameCtrl
                                ),
                                const SizedBox(height: 4.0),
                                CustomTextField(
                                    text: 'Email',
                                    ctrl: _userEmailCtrl
                                ),
                                const SizedBox(height: 4.0),
                                CustomTextField(
                                    text: 'Date of Birth',
                                    ctrl: _userDoBCtrl
                                ),
                                const SizedBox(height: 4.0),
                                CustomTextField(
                                    text: 'Year Group',
                                    ctrl: _userYearCtrl
                                ),
                                const SizedBox(height: 4.0),
                                CustomTextField(
                                    text: 'Major',
                                    ctrl: _userMajorCtrl
                                ),
                                const SizedBox(height: 4.0),
                                DropdownButtonFormField<String>(
                                  validator: (value){
                                    if (value == null || value.isEmpty){
                                      return "Please fill this thing";
                                    }
                                  },
                                  value: _selectedVal,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Residence',
                                    filled: true,
                                    fillColor: Colors.white70,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedVal = value;
                                      _userResidenceCtrl.text = _selectedVal ?? '';
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem(
                                      value: 'On-campus',
                                      child: Text('On-campus'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Off-campus',
                                      child: Text('Off-campus'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                CustomTextField(
                                    text: 'Favourite Food',
                                    ctrl: _userFoodCtrl
                                ),
                                const SizedBox(height: 4.0),
                                CustomTextField(
                                    text: 'Favourite Movie',
                                    ctrl: _userMovieCtrl
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextButton(
                                              onPressed: _navigateToLogin,
                                              child: const Text(
                                                  'Login',
                                                  style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    decoration: TextDecoration.underline,
                                                    fontWeight: FontWeight.bold,
                                                  )
                                              ),
                                            ),
                                          ),

                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: (){
                                              if (_formKey.currentState!.validate()){
                                                _signUpUser();
                                              };
                                            },
                                            child: const Text('Sign Up'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ),
          ),
        ],
      ),
    );
  } // widget
}