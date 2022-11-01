import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/post_game_screen.dart';
import 'package:get/get.dart';
import 'dart:math';

import '../services/event_types.dart';
import '../services/getx_business_logic.dart';

class DataEntryScreen extends StatelessWidget {
  final BusinessLogicController c = Get.find();

  void move() {
    Get.to(() => PostGameScreen());
  }

  @override
  Widget build(BuildContext context) {
    var rng = Random();

    // FIXME: This is a hack to get the match data to update.
    Future.delayed(const Duration(seconds: 2), () => move);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Entry'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () =>
                  Text("Number of events: ${c.matchData.value.events.length}"),
            ),
            ElevatedButton(
              child: const Text('Add Dummy Event'),
              onPressed: () {
                c.insertEvent(Event(
                    timeSince: rng.nextInt(100),
                    type: EventType.shotSuccess,
                    position: 2));
                c.update();
              },
            ),
            ElevatedButton(
              child: const Text('Next'),
              onPressed: () {
                move();
              },
            ),
          ]),
    );
  }
}
