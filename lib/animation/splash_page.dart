// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import '../auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
//import 'package:flutter_svg/svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              r"assets/images/Pe.png",
              width: 200.0,
              height: 200.0,
              //width: MediaQuery.of(context).size.width * 0.8,
              fit: BoxFit.cover,
            )
                //  SvgPicture.asset(
                //   r"assets\images\logo2.svg",
                //   width: 100,
                //   // height: 100,
                // ),
                // SvgPicture.asset(
                //   // "assets/images/logo2.svg",
                //  r"assets\images\logo2.svg",
                //   // SvgPicture.network(
                //   //   "https://raw.githubusercontent.com/ducksoupdev/svg-example/master/freesample.svg",
                //  semanticsLabel: 'Acme Logo',
                //)
                .animate()
                .fadeIn(
                  duration: 3000.ms,
                )
                .scale(
                  duration: 3000.ms,
                )
                .move(
                  duration: 3000.ms,
                ),
/*
            Image.network(
              "https://images.unsplash.com/photo-1484517586036-ed3db9e3749e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
               width: 200.0,
              width: MediaQuery.of(context).size.width * 0.8,
               svg
             / height: 200.0,
              fit: BoxFit.cover,
            )
                .animate()
                .fadeIn(
                  duration: 2000.ms,
                )
                .scale(
                  duration: 2000.ms,
                )
                .move(
                  duration: 2000.ms,
                ),*/
          ],
        ),
      ),
    );
  }
}
