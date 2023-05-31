import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'homeScreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class timeOutScreen extends StatefulWidget {
  const timeOutScreen({Key? key}) : super(key: key);

  @override
  State<timeOutScreen> createState() => _timeOutScreenState();
}

class _timeOutScreenState extends State<timeOutScreen> {

  late String textFromFile;




  int _seconds = 00;
  int _minutes = 5;
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
    setState(() {
      _timer.cancel();
      _seconds = 0;
      _minutes = 5;
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
        title: Text("Pomodoro", style: TextStyle(fontWeight: FontWeight.w500),),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
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
                          value: (_minutes/5)+(_seconds/(60*5)),
                          strokeWidth: 7,
                          color: const Color(0xfff00245),
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
                      backgroundColor: const Color(0xfff00245),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.restore_rounded, color: Color(0xff1e2225),),
                          Text("Reset", style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xff1e2225))),
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
                      backgroundColor: const Color(0xfff00245),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.not_started_outlined, color: Color(0xff1e2225),),
                          Text("Başlat", style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xff1e2225))),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const homeScreen()));
                  },
                  backgroundColor: const Color(0xfff00245),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.not_started_outlined, color: Color(0xff1e2225),),
                      Text("Çalışmaya\ndön",textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xff1e2225))),
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
                            padding: EdgeInsets.all(10.h),
                            child: Text(textFromFile, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14.sp),)
                        ),
                      ],
                    )
                );
              },
                  child: const Text(
                      "Nasıl Kullanırım?",
                      style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xfff00245),)
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = ElevatedButton(
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xfff00245))
    ),
    child: const Text("Tamam",
      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
    ),
    onPressed: () {
      Navigator.of(context).pop();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const homeScreen()));
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: const Color(0xFF282828),
    title: Lottie.asset("assets/work.json",),
    content: const Text("Mola Bitti! Çalışmaya dön.",
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