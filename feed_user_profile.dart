import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatelessWidget {
  final BuildContext context;
  final String userEmail;

  const UserProfile({Key? key, required this.context, required this.userEmail}) : super(key: key);


  Future<Map<String, dynamic>> _getUserDeets(String userEmail) async {
    String userId = '';
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();
    final List<String> ids = snapshot.docs.map((doc) => doc.id).toList();
    if (ids.isNotEmpty){
      userId = ids.first;
    }
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
    return FutureBuilder(
      future: _getUserDeets(userEmail), // Call the API to get user details
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          // Display user details if data is available
          final userDetails = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/user_profile.png'),
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
              Align(
                alignment: Alignment.center,
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
              // SizedBox(height: 16),
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

