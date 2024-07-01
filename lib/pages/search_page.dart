import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myst_app/models/profile.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Profile> profiles = [];

  Future<void> fetchProfiles(String username) async {
    final response = await http.get(
      Uri.parse('https://sky.shiiyu.moe/api/v2/profile/$username'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Profile> tempProfiles = [];
      jsonData.forEach((profileId, profileData) {
        Profile profile = Profile.fromJson(profileData);
        tempProfiles.add(profile);
      });
      setState(() {
        profiles = tempProfiles;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch profiles. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SkyBlock Profile Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String username = _controller.text.trim();
                if (username.isNotEmpty) {
                  fetchProfiles(username);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Please enter a username.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Search'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  final profile = profiles[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Profile ID: ${profile.profileId}'),
                          Text('Cute Name: ${profile.cuteName}'),
                          Text('Current: ${profile.current}'),
                          Text('Last Save: ${profile.lastSave}'),
                          Text('Raw: ${profile.raw}'),
                          Text('Items: ${profile.items}'),
                          Text('Data: ${profile.data}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
