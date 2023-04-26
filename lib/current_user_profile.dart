import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'edit_profile.dart';

/* Displaying the details of the logged in user */
class UserProfile extends StatefulWidget {
  final BuildContext context;
  final String userId;

  const UserProfile({Key? key, required this.context, required this.userId}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>{
  String _userId = '';
  late ImageProvider imageProvider;

  @override
  void initState(){
    super.initState();
    _userId = widget.userId; // setting the id to the logged in user
  }


  void _navigateToEditProfile() {
    // navigate to allow profile edits
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfile(userId: _userId)),
    );
  }


  Future<Map<String, dynamic>> _getUserDeets(String userId) async {
    // retrieving user information to be displayed in the profile card
    final url = Uri.parse('https://webtechfinals-383417.uc.r.appspot.com/users/$userId');
    final response = await http.get(url);
    if (response.statusCode == 200){
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to load user details');
    }
  }

  @override
  Widget build(BuildContext context) {
    // structure of the profile page allowing for live updates in case of any changes
    return FutureBuilder(
      future: _getUserDeets(_userId), // Call the API to get user details
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          // Display user details if data is available
          final userDetails = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:  AssetImage('assets/user_profile.png'),
              ),
              SizedBox(height: 16),
              Text(
                userDetails['name'] ?? '', // Display user name
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2),
              Text(
                userDetails['email'] ?? '', // Display user email
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 14),
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Year Group: ',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              userDetails['year_grp'] ?? '',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Major: ',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              userDetails['major'] ?? '',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Favourite food: ',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              userDetails['fav_food'] ?? '',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Favourite Movie: ',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              userDetails['fav_movie'] ?? '',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Residence: ',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              userDetails['residence'] ?? '',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Birthday: ',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              userDetails['DOB'] ?? '',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _navigateToEditProfile,
                child: Text('Edit Profile'),
              ),
            ],
          );
        } else {
          // Display loading indicator while waiting for data
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}