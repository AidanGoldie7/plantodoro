import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:plantpomodoro/widget/progress_icons.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Pomodoro Application',
                style: TextStyle(fontSize: 32, color: Colors.grey[400]),
              ),
              Text(
                'Set : 3',
                style: TextStyle(fontSize: 22, color: Colors.grey[400]),
              ),
              Expanded(
                //centering the clock
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 220.0,
                      lineWidth: 15.0,
                      percent: 0.3,
                      //making timer line rounded instead of a straight line going around the circle
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text('14:36',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                      progressColor: Colors.green,
                    ),
                    SizedBox(
                        height: 10
                    ),
                    const ProgressIcons(
                      total: 4,
                      done: 3,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
