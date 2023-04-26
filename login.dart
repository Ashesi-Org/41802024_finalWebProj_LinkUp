import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';
import 'create_profile.dart';
import 'linkup_feed.dart';

/*
* Login page of the app
*/
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // defining text controller
  final _userIdCtrl = TextEditingController();
  String _errorMsg = ''; //display this tex if there is an error

  void _navigateToSignUp() {
    /* Sends the user to the sign up page */
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUp()),
    );
  }

  void _login() async{
    /* Login information */
    String userId = _userIdCtrl.text.trim();

    if (userId.isEmpty){ //validating text field
      setState(() {
        _errorMsg = 'Please provide an Id';
      });
      return;
    }
    final user = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (user.exists){
      // send existing user to feed page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Content(userId: userId,)
        ),
      );
    } else{
      setState(() {
        _errorMsg = 'User not found.'; //invalid user text
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // creating the design for the login page
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: AppColors.linkUpText,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome Back to LinkUp!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6.0),
                const Text(
                  'Log in with your user ID or Sign up to create a new account',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16.0),
                // representing the error message if it is needed
                if (_errorMsg.isNotEmpty)
                  Text(
                    '*'+ _errorMsg,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                SizedBox(
                  width: 400.0,
                  child: TextField(
                    controller: _userIdCtrl,
                    style: TextStyle(fontSize: 14.0),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Id',
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                ),
                SizedBox(
                  width: 400.0,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _navigateToSignUp,
                              child: const Text('Sign Up'),
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
                              onPressed: _login,
                              child: const Text('Login'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  } // widget
}
