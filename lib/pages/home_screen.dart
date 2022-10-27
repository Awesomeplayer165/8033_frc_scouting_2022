import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frc_scouting/pages/qrcode_screen.dart';
import 'package:frc_scouting/services/game_data.dart';
import 'package:path_provider/path_provider.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // TODO: Save if logged in or not from previous login, automatically assumes not logged in
  bool loggedIn = false;
  late int matchNumber;
  final matchNumberController = TextEditingController();
  late Map<String, dynamic> loginInfo;
  late Map<String, dynamic> fullMatchInfo;
  late GameData gameData;
  late Directory _appDocumentsDirectory;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    matchNumberController.dispose();
    super.dispose();
  }
  Future<void> getDirectory() async {
    _appDocumentsDirectory = await getApplicationDocumentsDirectory();
  }

  @override
  Widget build(BuildContext context) {
    getDirectory();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    return Scaffold(
      backgroundColor: const Color(0xff491365),
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png'),
                  SizedBox(width: 10,),
                  Text(
                    'Scouting App 2022',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Image.asset('assets/logo.png'),
                ],
              ),
              SizedBox(height: 50,),
              TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                // TODO: Make the font white
                controller: matchNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ], // Only numbers can be entered
                decoration: InputDecoration(

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                    borderSide: BorderSide(color: Colors.white, width: 3, ),
                  ),
                  hintText: 'Enter Match Number',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              ValueListenableBuilder(valueListenable: matchNumberController, builder: (context, value, child) {
                return ElevatedButton.icon(
                  onPressed: value.text.isNotEmpty ? () async {
                    if (loggedIn) {
                      // TODO: Make the button not pressable when textfield is empty
                      matchNumber = int.parse(matchNumberController.text);
                      matchNumberController.clear();
                      loginInfo = {
                        'useQR': false,
                        'loggedIn': true,
                        'name': 'Joe',
                      };
                    } else { // If not logged in
                      matchNumber = int.parse(matchNumberController.text);
                      matchNumberController.clear();
                      loginInfo = await Navigator.pushNamed((context), '/login') as Map<String, dynamic>;
                    }
                    fullMatchInfo = await Navigator.pushNamed((context), '/start_page') as Map<String, dynamic>;

                    // Add all the gamedata to the gamedata object
                    // TODO: Assign team number and get scouter name
                    gameData = GameData(matchNumber, 254, loginInfo['name'], fullMatchInfo['startTime'], fullMatchInfo['events'], fullMatchInfo['challengeResult'], fullMatchInfo['didDefense'], fullMatchInfo['notes'], _appDocumentsDirectory);
                    setState(() async {
                      print(gameData.toString());
                      Navigator.pushNamed((context), '/qrcode_screen', arguments: gameData);
                    });
                  } : () {
                    // If text box is empty
                    showDialog(context: context, builder: (context)
                    {
                      return AlertDialog(content: Text('Please enter the match number'));
                    });
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(5),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  label: Text(
                  'Next',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  icon: Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                  size: 30,
                  ),
                );
              }),
              ElevatedButton.icon(
                onPressed: () async {

                  String path = _appDocumentsDirectory.path;
                  List cached_data = Directory(path).listSync();

                  Navigator.pushNamed((context), '/text_qrcode_screen', arguments: cached_data);
                },
                icon: Icon(
                  Icons.qr_code,
                  color: Colors.black,
                  size: 30,
                ),
                label: Text(
                  'Generate Cached Data',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(5),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
