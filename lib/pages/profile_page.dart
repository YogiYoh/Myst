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
  late String selectedProfileName;
  @override
  void initState() {
    super.initState();
    selectedProfileName = ''; 
    futureProfile = ApiService().fetchProfile(widget.username);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SkyBlock Profile', style: TextStyle(fontFamily: 'Minecraftia')),
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
                      style: TextStyle(color: Colors.red, fontFamily: 'Minecraftia'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data found', style: TextStyle(fontFamily: 'Minecraftia')));
            } else {
              Profile profile = snapshot.data!;
              return buildProf(profile);
            }
          },
        ),
      ),
    );
  }
  Widget buildProf(Profile profile) {
    List<String> otherNames = profile.otherNames.toSet().toList(); 
    String selectedValue = profile.cuteName; 
    return Container(
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.topRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget> [
              Text('Username: ${profile.name.name} on ', style: TextStyle(fontFamily: 'Minecraftia')),
              DropdownButton<String>(
                  value: selectedValue, 
                  items: otherNames.map((String name){
                    return DropdownMenuItem(
                      value: name, 
                      child: Text(name, style: TextStyle(fontFamily: 'Minecraftia'))
                    );
                  }).toList(), 
                  onChanged: (String? newValue){
                    setState((){
                      selectedProfileName = newValue!;
                      futureProfile = ApiService().newProfile(profile.name.name, newValue!); 
                    });
                  },
                ),
              ],
            ), 
            
            Text('Game Mode: ${profile.profileId}', style: TextStyle(fontFamily: 'Minecraftia')),
            Text('Game Mode: ${profile.gameMode}', style: TextStyle(fontFamily: 'Minecraftia')),
            Text('Current: ${profile.current}', style: TextStyle(fontFamily: 'Minecraftia')),
            Text('Levels: ', style: TextStyle(fontFamily: 'Minecraftia')),
            Text('Level: ${profile.levels.level}', style: TextStyle(fontFamily: 'Minecraftia')),
            Text('${profile.levels.xpCurrent} / ${profile.levels.xpForNext}', style: TextStyle(fontFamily: 'Minecraftia')),

            SizedBox(height: 20), // Adjust the height as needed

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Skills',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Minecraftia'),
                  ),

                  SizedBox(height: 10), // Optional: Add some space between the title and the other text

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children:[
                          Text('Taming level: ${profile.skills.taming.level}', style: TextStyle(fontFamily: 'Minecraftia')),
                          Text('Taming XP: ${profile.skills.taming.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                      Column(
                        children:[
                          Text('Farming level: ${profile.skills.farming.level}', style: TextStyle(fontFamily: 'Minecraftia')),
                          Text('Farming XP: ${profile.skills.farming.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                      Column(
                        children:[
                          Text('Mining level: ${profile.skills.mining.level}', style: TextStyle(fontFamily: 'Minecraftia')),
                          Text('Mining XP: ${profile.skills.mining.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10), // Optional: Add some space between the title and the other text

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children:[
                          Text('Combat level: ${profile.skills.combat.level}', style: TextStyle(fontFamily: 'Minecraftia')),
                          Text('Combat XP: ${profile.skills.combat.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                      Column(
                        children:[
                          Text('Foraging level: ${profile.skills.foraging.level}', style: TextStyle(fontFamily: 'Minecraftia')),
                          Text('Foraging XP: ${profile.skills.foraging.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                      Column(
                        children:[
                          Text('Fishing level: ${profile.skills.fishing.level}', style: TextStyle(fontFamily: 'Minecraftia')),
                          Text('Fishing XP: ${profile.skills.fishing.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10), // Optional: Add some space between the title and the other text

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children:[
                          Text('Enchanting level: ${profile.skills.enchanting.level}', style: TextStyle(fontFamily: 'Minecraftia')),
                          Text('Enchanting XP: ${profile.skills.enchanting.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                      Column(
                        children:[
                          Text('Alchemy level: ${profile.skills.alchemy.level}', style: TextStyle(fontFamily: 'Minecraftia')),
                          Text('Alchemy XP: ${profile.skills.alchemy.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                      Column(
                        children:[
                          Text('Carpentry level: ${profile.skills.carpentry.level}', style: TextStyle(fontFamily: 'Minecraftia')),
                          Text('Carpentry XP: ${profile.skills.carpentry.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children:[
                          Text('Runecrafting level: ${profile.skills.runecrafting.level}', style: TextStyle(fontFamily: 'Minecraftia')),
                          Text('Runecrafting XP: ${profile.skills.runecrafting.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}