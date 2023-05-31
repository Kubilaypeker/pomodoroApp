import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pomodoroapp/screens/timeoutScreen.dart';
import 'package:flutter/services.dart' show rootBundle;



class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  late String textFromFile;
  AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();



  int _seconds = 00;
  int _minutes = 25;
  var f = NumberFormat("00");
  late Timer _timer;
  bool _enabledButton = true;

  getTxt() async {
    String response;
    response = await rootBundle.loadString('assets/pomodoro.txt');
    setState(() {
      textFromFile = response;
    });
  }

  void _startTimer(){

      player.open(
        Audio("assets/music.mp3"),
        loopMode: LoopMode.single,
      );

    if (_minutes > 0){
      _seconds = _minutes * 60;
    }
    if (_seconds >60){
      _minutes = (_seconds/60).floor();
      _seconds -= (_minutes * 60);
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0){
          _seconds--;
        }
        else {
          if (_minutes >0){
            _seconds = 59;
            _minutes--;
          }
          else {
            timer.cancel();
            player.stop();
            setState(() {
              _enabledButton = true;
              showAlertDialog(context);
            });
          }
        }
      });
    }
    );

  }

  void _stopTimer(){
      player.stop();
      setState(() {
        _timer.cancel();
        _seconds = 0;
        _minutes = 25;
      });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 820));

    return Scaffold(
      backgroundColor: const Color(0xff1e2225),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff1e2225),
        title: const Text("Pomodoro", style: TextStyle(fontWeight: FontWeight.w500),),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: SizedBox(
              width: 400.h,
              height: 400.h,
              child: Stack(
                children: [
                  Center(
                    child: FractionallySizedBox(
                      heightFactor: 0.7,
                      widthFactor: 0.7,
                      child: CircularProgressIndicator(
                        value: _minutes/25+(_seconds/(60*25)),
                        strokeWidth: 7,
                        color: const Color(0xfff0c902),
                      ),
                    ),
                  ),
                  Center(
                    child: Text("${f.format(_minutes)} : ${f.format(_seconds)}", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 50.sp,
                    ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 80.h,
                width: 80.h,
                child: FloatingActionButton(
                    onPressed: () {
                    setState(() {
                      _enabledButton = true;
                    });
                    _stopTimer();
                },
                    backgroundColor: const Color(0xfff0c902),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restore_rounded, color: Colors.black,),
                        Text("Reset", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
                      ],
                    )
                ),
              ),
              SizedBox(
                height: 80.h,
                width: 80.h,
                child: FloatingActionButton(
                    onPressed: () {
                      if(_enabledButton == true){
                        setState(() {
                          _enabledButton = false;
                        });
                        _startTimer();
                      }
                      else {

                      }
                    },
                    backgroundColor: const Color(0xfff0c902),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.not_started_outlined, color: Colors.black,),
                        Text("Başlat", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
                      ],
                    )
                ),
              ),
            ],
          ),
          SizedBox(
            height: 80.h,
            width: 80.h,
            child: FloatingActionButton(
                onPressed: () {
                  player.stop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const timeOutScreen()));
                },
                backgroundColor: const Color(0xfff0c902),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer_outlined, color: Color(0xff1e2225),),
                    Text("Mola Ver", style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xff1e2225))),
                  ],
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.h),
            child: TextButton(onPressed: () {
              getTxt();
              showModalBottomSheet(
                backgroundColor: const Color(0xff1e2225),
                  useSafeArea: true,
                  context: context,
                  builder: (context) => ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(textFromFile, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),)
                      ),
                    ],
                  )
              );
            },
                child: const Text(
                  "Nasıl Kullanırım?",
                  style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xfff0c902),)
                )
            ),
          )
        ],
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(const Color(0xfff0c902))
    ),
    child: const Text("Tamam",
      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
    ),
    onPressed: () {
      Navigator.of(context).pop();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const timeOutScreen()));
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: const Color(0xFF282828),
    title: Lottie.asset("assets/congrats.json", repeat: false),
    content: const Text("Tebrikler! Şimdi mola zamanı.",
      style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
      ),
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}