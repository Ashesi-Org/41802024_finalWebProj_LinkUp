import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'feed_user_profile.dart';


class FeedStream extends StatelessWidget {
  void _viewProfile(context, userEmail){
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('User Profile'),
              CloseButton(),
            ],
          ),
          content: Container(
            height: 200.0,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: SingleChildScrollView(
                child: UserProfile(context: context, userEmail: userEmail
                ),
            ),
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return Text('Loading...');
        }

        final posts = snapshot.data!.docs
            .map((document) => Post.fromFirestore(document))
            .where((post) => post != null)
            .toList();

        posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        return ListView(
          children: posts.map((post) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2.0,
              color: Colors.white.withOpacity(0.8),
              child: Container(
                height: 100.0,
                width: 300.0,
                child: ListTile(
                  title: GestureDetector(
                    child: Text(
                      post.user_email,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                      ),
                    ),
                    onTap: () => _viewProfile(context, post.user_email)
                  ),
                  subtitle: Text(post.user_post),
                  trailing: Text(post.timestamp.toDate().toString()),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class Post {
  final Timestamp timestamp;
  final String user_email;
  final String user_post;

  Post({
    required this.timestamp,
    required this.user_email,
    required this.user_post,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      return Post(user_email: '', user_post: '', timestamp: Timestamp.now());
    }

    return Post(
      timestamp: data['timestamp'] != null
          ? Timestamp.fromDate(DateTime.parse(data['timestamp']))
          : Timestamp.now(),
      user_email: data['email'] ?? '',
      user_post: data['message'] ?? '',
    );
  }
}

