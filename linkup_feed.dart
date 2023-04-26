import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'current_user_profile.dart';
import 'feed_stream.dart';
import 'login.dart';
import 'custom_textField.dart';

/* Main aim, feed page with user profile displayed */
class Content extends StatefulWidget {
  final String userId;
  const Content({Key? key, required this.userId}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  // declaring needed variables
  String _userId = '';
  String _errorMsg = '';

  // declaring controllers and form key
  final _formKey = GlobalKey<FormState>();
  final _userEmailCtrl = TextEditingController();
  final _userPostCtrl = TextEditingController();

  @override
  void initState(){
    super.initState();
    _userId = widget.userId; //setting the user id as the logged in user
  }

  void _makePost() async{
    // submitting the post (api sends the email)
    final response = await http.post(
      Uri.parse('https://webtechfinals-383417.uc.r.appspot.com/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        "email": _userEmailCtrl.text,
        "message": _userPostCtrl.text,
      }),
    );

    if (response.statusCode == 200){
      // close dialogue after successful submission
      Navigator.pop(context);
    } else {
      //display error message
      String errorMsg = json.decode(response.body)['error'];
      setState(() {
        _errorMsg = errorMsg;
      });
    }
  }

  void _showForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Post a Link Up-date'),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: 300.0,
            height: 150.0,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8.0),
                      SizedBox(
                        width: 250,
                        child: CustomTextField(
                          text: 'Email',
                          ctrl: _userEmailCtrl,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        width: 250,
                        child: CustomTextField(
                          text: 'Post',
                          ctrl: _userPostCtrl,
                        ),
                      ),
                      if (_errorMsg != null) // displaying the error message
                        Text(
                          _errorMsg,
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()){
                  // if the form constraints are satisfied
                  _makePost();
                };
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _logOut(){
    // allowing the user to logout
    Navigator.push(
        context,
      MaterialPageRoute(builder: (context) => Login()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // structuring the feed page
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
          children: [
          AppColors.linkUpText,
          Text(
            "   -   LinkUp-dates",
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
        child: Row(
          children: [
            SizedBox(
              width: 400,
              child: Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Card(
                      margin: EdgeInsets.all(16.0),
                      color: Colors.white.withOpacity(0.8),
                      child: SizedBox(
                        height: 600.0,
                        width: double.infinity,
                        child: UserProfile(context: context, userId: _userId), // displaying user profile
                      ),
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    SizedBox(height: 20), // Add some space
                    SizedBox(
                      height: 50,
                      width: 120,
                      child: ElevatedButton.icon(
                        onPressed: _logOut,
                        icon: Icon(Icons.logout),
                        label: Text('Logout'),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(100, 50)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Center(
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: double.infinity,
                    width: 600.0,
                    child: FeedStream(), // displaying the live feed
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: _showForm,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}


