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
              return buildProf(profile);
            }
          },
        ),
      ),
    );
  }


  Widget buildProf(Profile profile){
    return Container(
          padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.topRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text('Username: ${profile.name.name} on ${profile.cuteName}'),
            Text('Game Mode: ${profile.gameMode}'),
            Text('Current: ${profile.current}'),
            Text('Levels: '),
            Text('Level: ${profile.levels.level}'),
            Text('${profile.levels.xpCurrent} / ${profile.levels.xpForNext}'),



            SizedBox(height: 20), // Adjust the height as needed
             
             
           Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Skills',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  
                  
                  
                  SizedBox(height: 10), // Optional: Add some space between the title and the other text
                  
                  
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children:[
                          Text('Taming level: ${profile.skills.taming.level}'),
                          Text('Taming XP: ${profile.skills.taming.xp}'),
                        ],
                      ),


                      Column(
                        children:[
                          Text('Farming level: ${profile.skills.farming.level}'),
                          Text('Farming XP: ${profile.skills.farming.xp}'),
                        ],
                      ),

                      Column(
                        children:[
                          Text('Mining level: ${profile.skills.mining.level}'),
                          Text('Mining XP: ${profile.skills.mining.xp}'),
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
                        Text('Combat level: ${profile.skills.combat.level}'),
                        Text('Combat XP: ${profile.skills.combat.xp}'),
                        ],
                      ),


                      Column(
                        children:[
                        Text('Foraging level: ${profile.skills.foraging.level}'),
                        Text('Foraging XP: ${profile.skills.foraging.xp}'),
                        ],
                      ),

                      Column(
                        children:[
                        Text('Fishing level: ${profile.skills.fishing.level}'),
                        Text('Fishing XP: ${profile.skills.fishing.xp}'),
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
                          Text('Enchanting level: ${profile.skills.enchanting.level}'),
                          Text('Enchanting XP: ${profile.skills.enchanting.xp}'),
                        ],
                      ),


                      Column(
                        children:[
                          Text('Alchemy level: ${profile.skills.alchemy.level}'),
                          Text('Alchemy XP: ${profile.skills.alchemy.xp}'),
                        ],
                      ),

                      Column(
                        children:[
                          Text('Carpentry level: ${profile.skills.carpentry.level}'),
                          Text('Carpentry XP: ${profile.skills.carpentry.xp}'),
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
                          Text('Runecrafting level: ${profile.skills.runecrafting.level}'),
                          Text('Runecrafting XP: ${profile.skills.runecrafting.xp}'),
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

