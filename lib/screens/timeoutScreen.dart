import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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


  getTxt() async {
    String response;
    response = await rootBundle.loadString('assets/pomodoro.txt');
    setState(() {
      textFromFile = response;
    });
  }

  int _seconds = 00;
  int _minutes = 5;
  var f = NumberFormat("00");
  late Timer _timer;

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
            showAlertDialog(context);
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
        title: Text("Pomodoro", style: GoogleFonts.roboto(fontWeight: FontWeight.w500),),
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
                      child: Text("${f.format(_minutes)} : ${f.format(_seconds)}", style: GoogleFonts.roboto(
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
                        _stopTimer();
                      },
                      backgroundColor: const Color(0xfff00245),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.restore_rounded, color: Color(0xff1e2225),),
                          Text("Reset", style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xff1e2225))),
                        ],
                      )
                  ),
                ),
                SizedBox(
                  height: 80.h,
                  width: 80.h,
                  child: FloatingActionButton(
                      onPressed: () {
                        _startTimer();
                      },
                      backgroundColor: const Color(0xfff00245),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.not_started_outlined, color: Color(0xff1e2225),),
                          Text("Başlat", style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xff1e2225))),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.not_started_outlined, color: Color(0xff1e2225),),
                      Text("Çalışmaya\ndön",textAlign: TextAlign.center, style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xff1e2225))),
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
                            child: Text(textFromFile, style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14.sp),)
                        ),
                      ],
                    )
                );
              },
                  child: Text(
                      "Nasıl Kullanırım?",
                      style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: const Color(0xfff00245),)
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
    child: Text("Tamam",
      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.black),
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
    title: Lottie.network("https://assets9.lottiefiles.com/packages/lf20_gjjlq5lu.json", repeat: false),
    content: Text("Mola Bitti! Çalışmaya dön.",
      style: GoogleFonts.poppins(
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