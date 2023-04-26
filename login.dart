import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';
import 'create_profile.dart';
import 'linkup_feed.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _userIdCtrl = TextEditingController();
  String _errorMsg = '';

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUp()),
    );
  }

  void _login() async{
    String userId = _userIdCtrl.text.trim();

    if (userId.isEmpty){
      setState(() {
        _errorMsg = 'Please provide an Id';
      });
      return;
    }
    final user = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (user.exists){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Content(userId: userId,)
        ),
      );
    } else{
      setState(() {
        _errorMsg = 'User not found.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
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
