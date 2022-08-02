import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:plantpomodoro/utils/constants.dart';
import 'package:plantpomodoro/widget/progress_icons.dart';
import 'package:plantpomodoro/widget/custom_button.dart';
import 'package:plantpomodoro/model/pomodoro_status.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

const _btnTextStart = 'START POMODORO';
const _btnTextResumePomodoro = 'RESUME POMODORO';
const _btnTextResumeBreak = 'RESUME BREAK';
const _btnTextStartShortBreak = 'TAKE SHORT BREAK';
const _btnTextStartLongBreak = 'TAKE LONG BREAK';
const _btnTextStartNewSet = 'START NEW SET';
const _btnTextPause = 'PAUSE';
const _btnTextReset = 'RESET';


class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    int remainingTime = pomodoroTotalTime;
    String mainBtnText = _btnTextStart;
    PomodoroStatus pomodoroStatus = PomodoroStatus.pausedPomodoro;
    Timer _timer;
    int pomodoroNum = 0;
    int setNum = 0;

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
                'Pomodoro Number: $pomodoroNum',
                style: TextStyle(fontSize: 32, color: Colors.grey[400]),
              ),
              Text(
                'Set : $setNum',
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
                    Text('status description',
                    style : TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                        onTap: () {},
                      text: 'Start',
                    ),
                    CustomButton(
                      onTap: () {},
                      text: 'Reset',
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
