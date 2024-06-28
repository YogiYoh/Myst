import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../services/api_service.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  ProfilePage({required this.username});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Profile> futureProfile;

  @override
  void initState() {
    super.initState();
    futureProfile = ApiService().fetchProfile(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SkyBlock Profile'),
      ),
      body: Center(
        child: FutureBuilder<Profile>(
          future: futureProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.error, color: Colors.red, size: 50),
                    SizedBox(height: 10),
                    Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data found'));
            } else {
              Profile profile = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Username: ${profile.profileId}'),
                  Text('UUID: ${profile.cuteName}'),
                  Text('Game Mode: ${profile.gameMode}'),
                  Text('Current: ${profile.current}'),
                  Text('Skills:'),
                  Text('Farming XP: ${profile.skills.farming.xp}'),
                  Text('Farming level: ${profile.skills.farming.level}'),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
