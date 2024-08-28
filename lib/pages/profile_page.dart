import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/profile.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    List<String> otherNames = profile.otherNames.toSet().toList();
    String selectedValue = profile.cuteName;

    double scaleFactor = screenWidth / 375.0; // Assuming 375 is the base width for scaling

  
  return Stack(
  children: <Widget>[
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 20), // Padding to move the entire row to the right
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Center aligns the dropdown with the text
          children: <Widget>[
            Text(
              '${profile.name.name} on ',
              style: TextStyle(fontFamily: 'Minecraftia', fontSize: 16 * scaleFactor),
            ),
            DropdownButton<String>(
              value: selectedValue,
              items: otherNames.map((String name) {
                return DropdownMenuItem(
                  value: name,
                  child: Text(
                    name,
                    style: TextStyle(fontFamily: 'Minecraftia', fontSize: 16 * scaleFactor),
                  ),
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
      ),
    ],
    ),


    Align(
      alignment: Alignment.topLeft,
      child: Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 70),
      child: CachedNetworkImage(
        imageUrl: 'https://mineskin.eu/armor/body/${profile.name.name}',
        width: MediaQuery.of(context).size.width * 0.3, // Responsive width
        height: MediaQuery.of(context).size.width * 0.3, // Responsive height
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    ),
    ),


    Padding(
      padding: const EdgeInsets.only(top: 30, right: 60),
      child: Align(
        alignment: Alignment.topRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: 30 * scaleFactor),
            Text('Joined: ${profile.year.joinedYear}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
            Text('Networth: ${formatNumber(profile.cash.networth)} ', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
            Text('Purse: ${formatNumber(profile.cash.purse)} ', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
            Text('Lily Weight: ${numberFormat.format((profile.lily.lilyWeight).toInt())} ', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
            Text('Senither Weight: ${numberFormat.format((profile.senither.senitherWeight).toInt())} ', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
            if (profile.cash.bank > 0)
              Text('Bank Account: ${formatNumber(profile.cash.bank)} ', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
            Image.asset(
              'assets/icons/wise_dragon_boots.png',
            ),
          ],
        ),
      ), 
    ),
      
      Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 100 * scaleFactor), // Adjust the height as needed
                  Text(
                    'Level: ${profile.levels.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 12 * scaleFactor)
                  ),
                  SizedBox(height: 5 * scaleFactor),
                  Stack(
                    children: <Widget>[
                      Container(
                          width: 1000 * scaleFactor, // Adjust as needed
                          height: 10,
                          child: LinearProgressIndicator(
                            value: (profile.levels.xpForNext > 0 ? profile.levels.xpCurrent / profile.levels.xpForNext : 0.0),
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ), 
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                          '${(profile.levels.xpCurrent)} / ${profile.levels.xpForNext}',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Minecraftia',
                                fontWeight: FontWeight.bold,
                                fontSize: 4 * scaleFactor, // Adjust font size as needed
                              ),
                            ),
                          ),
                      ),
                    ]
                  ),
                  SizedBox(height: 10 * scaleFactor), // Optional: Add some space between the title and the other text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: [
                          Text('Taming: ${profile.skills.taming.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          SizedBox(height: 10 * scaleFactor), // Space between text and progress bar
                          if(profile.skills.taming.xpForNext != 0)
                            Stack(
                            children: <Widget>[
                            Container(
                              width: 100 * scaleFactor, // Adjust as needed
                              height: 10,
                              child: LinearProgressIndicator(
                                value: (profile.skills.taming.xpForNext > 0 ? profile.skills.taming.xpCurrent / profile.skills.taming.xpForNext : 0.0),
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                              ), 
                            ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                  '${formatNumber(profile.skills.taming.xpCurrent)} / ${formatNumber(profile.skills.taming.xpForNext)}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Minecraftia',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4 * scaleFactor, // Adjust font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Stack(
                            children: <Widget>[
                            Container(
                              width: 100 * scaleFactor, // Adjust as needed
                              height: 10,
                              child: LinearProgressIndicator(
                                value: 100,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                              ), 
                            ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                  '${formatNumber(profile.skills.taming.xpCurrent)} XP',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Minecraftia',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4 * scaleFactor, // Adjust font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),


                      Column(
                        children: [
                          Text('Farming: ${profile.skills.farming.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          SizedBox(height: 10 * scaleFactor), // Space between text and progress bar
                          if(profile.skills.farming.xpForNext != 0)
                            Stack(
                              children: <Widget>[
                              Container(
                                width: 100 * scaleFactor, // Adjust as needed
                                height: 10,
                                child: LinearProgressIndicator(
                                  value: (profile.skills.farming.xpForNext > 0 ? profile.skills.farming.xpCurrent / profile.skills.farming.xpForNext : 0.0),
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ), 
                              ),
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  '${formatNumber(profile.skills.farming.xpCurrent)} / ${formatNumber(profile.skills.farming.xpForNext)} XP',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Minecraftia',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4 * scaleFactor, // Adjust font size as needed
                                  ),
                                )
                                ),
                              ),
                            ],
                          )
                          else
                            Stack(
                              children: <Widget>[
                                Container(
                                  width: 100 * scaleFactor, // Adjust as needed
                                  height: 10,
                                  child: LinearProgressIndicator(
                                    value: 100,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                  ), 
                                ),
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                '${formatNumber(profile.skills.farming.xpCurrent)} XP',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Minecraftia',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 4 * scaleFactor, // Adjust font size as needed
                                ),
                              )
                            ),
                          ),
                        ],
                      )
                  ],
                ),
                      Column(
                        children: [
                          Text('Mining: ${profile.skills.mining.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          SizedBox(height: 10 * scaleFactor), // Space between text and progress bar
                          if(profile.skills.mining.xpForNext != 0)
                            Stack(
                                  children: <Widget>[
                                  Container(
                                    width: 100 * scaleFactor, // Adjust as needed
                                    height: 10,
                                    child: LinearProgressIndicator(
                                      value: (profile.skills.mining.xpForNext > 0 ? profile.skills.mining.xpCurrent / profile.skills.mining.xpForNext : 0.0),
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                    ), 
                                  ),
                                  Positioned.fill(
                                    child: Center(
                                      child: Text(
                                      '${formatNumber(profile.skills.mining.xpCurrent)} / ${formatNumber(profile.skills.mining.xpForNext)} XP',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Minecraftia',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 4 * scaleFactor, // Adjust font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Stack(
                                children: <Widget>[
                                Container(
                                  width: 100 * scaleFactor, // Adjust as needed
                                  height: 10,
                                  child: LinearProgressIndicator(
                                    value: 100,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                  ), 
                                ),
                                Positioned.fill(
                                  child: Center(
                                    child: Text(
                                    '${formatNumber(profile.skills.mining.xpCurrent)} XP',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Minecraftia',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 4 * scaleFactor, // Adjust font size as needed
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
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
                          Text('Combat: ${profile.skills.combat.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          SizedBox(height: 10 * scaleFactor), // Space between text and progress bar
                          if(profile.skills.combat.xpForNext != 0)
                            Stack(
                              children: <Widget>[
                              Container(
                                width: 100 * scaleFactor, // Adjust as needed
                                height: 10,
                                child: LinearProgressIndicator(
                                  value: (profile.skills.combat.xpForNext > 0 ? profile.skills.combat.xpCurrent / profile.skills.combat.xpForNext : 0.0),
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ), 
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                  '${formatNumber(profile.skills.combat.xpCurrent)} / ${formatNumber(profile.skills.combat.xpForNext)} XP',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Minecraftia',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4 * scaleFactor, // Adjust font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Stack(
                              children: <Widget>[
                              Container(
                                width: 100 * scaleFactor, // Adjust as needed
                                height: 10,
                                child: LinearProgressIndicator(
                                  value: 100,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                ), 
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                  '${formatNumber(profile.skills.combat.xpCurrent)} XP',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Minecraftia',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4 * scaleFactor, // Adjust font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    Column(
                        children: [
                          Text('Foraging: ${profile.skills.foraging.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          SizedBox(height: 10 * scaleFactor), // Space between text and progress bar
                          if(profile.skills.foraging.xpForNext != 0)
                            Stack(
                              children: <Widget>[
                              Container(
                                width: 100 * scaleFactor, // Adjust as needed
                                height: 10,
                                child: LinearProgressIndicator(
                                  value: (profile.skills.foraging.xpForNext > 0 ? profile.skills.foraging.xpCurrent / profile.skills.foraging.xpForNext : 0.0),
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ), 
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                  '${formatNumber(profile.skills.foraging.xpCurrent)} / ${formatNumber(profile.skills.foraging.xpForNext)}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Minecraftia',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4 * scaleFactor, // Adjust font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Stack(
                              children: <Widget>[
                              Container(
                                width: 100 * scaleFactor, // Adjust as needed
                                height: 10,
                                child: LinearProgressIndicator(
                                  value: 100,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                ), 
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                  '${formatNumber(profile.skills.foraging.xpCurrent)} XP',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Minecraftia',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4 * scaleFactor, // Adjust font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                      Column(
                        children: [
                          Text('Fishing: ${profile.skills.fishing.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          SizedBox(height: 10 * scaleFactor), // Space between text and progress bar
                          if(profile.skills.fishing.xpForNext != 0)
                            Stack(
                              children: <Widget>[
                              Container(
                                width: 100 * scaleFactor, // Adjust as needed
                                height: 10,
                                child: LinearProgressIndicator(
                                  value: (profile.skills.fishing.xpForNext > 0 ? profile.skills.fishing.xpCurrent / profile.skills.fishing.xpForNext : 0.0),
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ), 
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                  '${formatNumber(profile.skills.fishing.xpCurrent)} / ${formatNumber(profile.skills.fishing.xpForNext)} XP',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Minecraftia',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4 * scaleFactor, // Adjust font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Stack(
                              children: <Widget>[
                              Container(
                                width: 100 * scaleFactor, // Adjust as needed
                                height: 10,
                                child: LinearProgressIndicator(
                                  value: 100,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                ), 
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                  '${formatNumber(profile.skills.fishing.xpCurrent)} XP',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Minecraftia',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4 * scaleFactor, // Adjust font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
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
                          Text('Enchanting: ${profile.skills.enchanting.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          SizedBox(height: 10 * scaleFactor), // Space between text and progress bar
                          if(profile.skills.enchanting.xpForNext != 0)
                            Stack(
                              children: <Widget>[
                              Container(
                                width: 100 * scaleFactor, // Adjust as needed
                                height: 10,
                                child: LinearProgressIndicator(
                                  value: (profile.skills.enchanting.xpForNext > 0 ? profile.skills.enchanting.xpCurrent / profile.skills.enchanting.xpForNext : 0.0),
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ), 
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                  '${formatNumber(profile.skills.enchanting.xpCurrent)} / ${formatNumber(profile.skills.enchanting.xpForNext)} XP',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Minecraftia',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4 * scaleFactor, // Adjust font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Stack(
                              children: <Widget>[
                              Container(
                                width: 100 * scaleFactor, // Adjust as needed
                                height: 10,
                                child: LinearProgressIndicator(
                                  value: 100,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                ), 
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                  '${formatNumber(profile.skills.enchanting.xpCurrent)} XP',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Minecraftia',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4 * scaleFactor, // Adjust font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                      Column(
                        children: [
                          Text('Alchemy: ${profile.skills.alchemy.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          SizedBox(height: 10 * scaleFactor), // Space between text and progress bar
                          if(profile.skills.alchemy.xpForNext != 0)
                            Stack(
                              children: <Widget>[
                              Container(
                                width: 100 * scaleFactor, // Adjust as needed
                                height: 10,
                                child: LinearProgressIndicator(
                                  value: (profile.skills.alchemy.xpForNext > 0 ? profile.skills.alchemy.xpCurrent / profile.skills.alchemy.xpForNext : 0.0),
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ), 
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                  '${formatNumber(profile.skills.alchemy.xpCurrent)} / ${formatNumber(profile.skills.alchemy.xpForNext)} XP',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Minecraftia',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4 * scaleFactor, // Adjust font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Stack(
                              children: <Widget>[
                              Container(
                                width: 100 * scaleFactor, // Adjust as needed
                                height: 10,
                                child: LinearProgressIndicator(
                                  value: 100,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                ), 
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                  '${formatNumber(profile.skills.alchemy.xpCurrent)} XP',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Minecraftia',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4 * scaleFactor, // Adjust font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                      Column(
                        children: [
                          Text('Carpentry: ${profile.skills.carpentry.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          SizedBox(height: 10 * scaleFactor), // Space between text and progress bar
                          if(profile.skills.carpentry.xpForNext != 0)
                            Stack(
                              children: <Widget>[
                              Container(
                                width: 100 * scaleFactor, // Adjust as needed
                                height: 10,
                                child: LinearProgressIndicator(
                                  value: (profile.skills.carpentry.xpForNext > 0 ? profile.skills.carpentry.xpCurrent / profile.skills.carpentry.xpForNext : 0.0),
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ), 
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                  '${formatNumber(profile.skills.carpentry.xpCurrent)} / ${formatNumber(profile.skills.carpentry.xpForNext)} XP',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Minecraftia',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4 * scaleFactor, // Adjust font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Stack(
                              children: <Widget>[
                              Container(
                                width: 100 * scaleFactor, // Adjust as needed
                                height: 10,
                                child: LinearProgressIndicator(
                                  value: 100,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                ), 
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                  '${formatNumber(profile.skills.carpentry.xpCurrent)} XP',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Minecraftia',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4 * scaleFactor, // Adjust font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
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
                          Text('Runecrafting: ${profile.skills.runecrafting.level}', style: TextStyle(fontFamily: 'Minecraftia', fontSize: 10 * scaleFactor)),
                          SizedBox(height: 10 * scaleFactor), // Space between text and progress bar
                          if(profile.skills.runecrafting.xpForNext != 0)
                            Stack(
                              children: <Widget>[
                              Container(
                                width: 100 * scaleFactor, // Adjust as needed
                                height: 10,
                                child: LinearProgressIndicator(
                                  value: (profile.skills.runecrafting.xpForNext > 0 ? profile.skills.runecrafting.xpCurrent / profile.skills.runecrafting.xpForNext : 0.0),
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ), 
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                  '${formatNumber(profile.skills.runecrafting.xpCurrent)} / ${formatNumber(profile.skills.runecrafting.xpForNext)} XP',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Minecraftia',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4 * scaleFactor, // Adjust font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Stack(
                              children: <Widget>[
                              Container(
                                width: 100 * scaleFactor, // Adjust as needed
                                height: 10,
                                child: LinearProgressIndicator(
                                  value: 100,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                ), 
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                  '${formatNumber(profile.skills.runecrafting.xpCurrent)} XP',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Minecraftia',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4 * scaleFactor, // Adjust font size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10 * scaleFactor), // Adjust the height as needed
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
          ),
      ],
    );
  }
}