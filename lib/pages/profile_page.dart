import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myst_app/models/profile.dart';

class ProfilePage extends StatefulWidget {
  final String playerName;

  ProfilePage({required this.playerName});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Profile> profiles = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://sky.shiiyu.moe/api/v2/profile/${widget.playerName}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Profile> loadedProfiles = data
          .map((profileData) => Profile.fromJson(profileData))
          .toList();

      setState(() {
        profiles = loadedProfiles;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load profiles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profiles for ${widget.playerName}'),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : profiles.isEmpty
          ? Center(
        child: Text('No profiles found'),
      )
          : ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return ListTile(
            title: Text(profile.displayName),
            subtitle: Text('Category: ${profile.category}'),
            onTap: () {
              // Handle profile tap
            },
          );
        },
      ),
    );
  }
}
