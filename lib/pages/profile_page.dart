import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

var numberFormat = NumberFormat('#,###');

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
              return buildProf(context, profile);
            }
          },
        ),
      ),
    );
  }

  String formatNumber(double number) {
    if (number >= 1e12) {
      return '${(number / 1e12).toStringAsFixed(2)}T';
    } else if (number >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(2)}B';
    } else if (number >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(2)}M';
    } else if (number >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(3)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }

  Widget buildProf(BuildContext context, Profile profile) {
    // Get the screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    List<String> otherNames = profile.otherNames.toSet().toList();
    String selectedValue = profile.cuteName;

    // Calculate a scaling factor based on the screen size
    double scaleFactor = screenWidth / 375.0; // Assuming 375 is the base width for scaling

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
              children: <Widget>[
                Text('Username: ${profile.name.name} on ', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 16 * scaleFactor)),
                DropdownButton<String>(
                  value: selectedValue,
                  items: otherNames.map((String name) {
                    return DropdownMenuItem(
                      value: name,
                      child: Text(name, style: TextStyle(fontFamily: 'Minecraftia', fontSize: 16 * scaleFactor)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedProfileName = newValue!;
                      futureProfile = ApiService().newProfile(profile.name.name, newValue!);
                    });
                  },
                ),
              ],
            ),
            Text('Game Mode: ${profile.gameMode}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 16 * scaleFactor)),
            Text('Current: ${profile.current}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 16 * scaleFactor)),
            Text('Levels: ', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 16 * scaleFactor)),
            Text('Level: ${profile.levels.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 16 * scaleFactor)),
            Text('${profile.levels.xpCurrent} / ${profile.levels.xpForNext}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 16 * scaleFactor)),
            SizedBox(height: 20 * scaleFactor), // Adjust the height as needed
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Joined: ${profile.year.joinedYear}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 4 * scaleFactor)),
                    ],
                  ),
                  SizedBox(width: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Networth: ${formatNumber(profile.cash.networth)} ', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 4 * scaleFactor)),
                    ],
                  ),
                  SizedBox(width: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Purse: ${formatNumber(profile.cash.purse)} ', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 4 * scaleFactor)),
                    ],
                  ),
                  SizedBox(width: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (profile.cash.bank > 0)
                        Text('Bank Account: ${formatNumber(profile.cash.bank)} ', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 4 * scaleFactor)),
                    ],
                  ),
                  SizedBox(width: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Lily Weight: ${numberFormat.format((profile.lily.lilyWeight).toInt())} ', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 4 * scaleFactor)),
                    ],
                  ),
                  SizedBox(width: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Senither Weight: ${numberFormat.format((profile.senither.senitherWeight).toInt())} ', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 4 * scaleFactor)),
                    ],
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Skills',
                    style: TextStyle(fontSize: 20 * scaleFactor, fontWeight: FontWeight.bold, fontFamily: 'Minecraftia'),
                  ),
                  SizedBox(height: 10 * scaleFactor), // Optional: Add some space between the title and the other text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: [
                          Text('Taming level: ${profile.skills.taming.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          // Text('Taming XP: ${profile.skills.taming.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Farming level: ${profile.skills.farming.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          // Text('Farming XP: ${profile.skills.farming.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Mining level: ${profile.skills.mining.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          // Text('Mining XP: ${profile.skills.mining.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10 * scaleFactor), // Optional: Add some space between the title and the other text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: [
                          Text('Combat level: ${profile.skills.combat.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          // Text('Combat XP: ${profile.skills.combat.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Foraging level: ${profile.skills.foraging.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          // Text('Foraging XP: ${profile.skills.foraging.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Fishing level: ${profile.skills.fishing.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          // Text('Fishing XP: ${profile.skills.fishing.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10 * scaleFactor), // Optional: Add some space between the title and the other text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: [
                          Text('Enchanting level: ${profile.skills.enchanting.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          // Text('Enchanting XP: ${profile.skills.enchanting.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Alchemy level: ${profile.skills.alchemy.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          // Text('Alchemy XP: ${profile.skills.alchemy.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Carpentry level: ${profile.skills.carpentry.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          // Text('Carpentry XP: ${profile.skills.carpentry.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10 * scaleFactor), // Optional: Add some space between the title and the other text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: [
                          Text('Runecrafting level: ${profile.skills.runecrafting.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          // Text('Runecrafting XP: ${profile.skills.runecrafting.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),
                      /*Column(
                        children: [
                          Text('Social level: ${profile.skills.social.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          // Text('Social XP: ${profile.skills.social.xp}', style: TextStyle(fontFamily: 'Minecraftia')),
                        ],
                      ),*/
                    ],
                  ),
                  SizedBox(height: 20 * scaleFactor), // Adjust the height as needed
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 60 * scaleFactor, // Adjust the height as needed
                      viewportFraction: 0.25, // Adjust the viewport fraction for the item width
                      enableInfiniteScroll: false,
                      initialPage: 0,
                    ),
                    items: [
                      'Armor',
                      'Weapons',
                      'Accessories',
                      'Pets',
                      'Inventory',
                      'Skills',
                      'Dungeons',
                      'Slayer',
                      'Minions',
                      'Bestiary',
                      'Collections',
                      'Crimson Isle'
                    ].map((category) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: screenWidth * 0.25, // Adjust the width as needed
                            child: Center(
                              child: Text(
                                category,
                                style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
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
