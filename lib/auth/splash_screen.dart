import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:contact_app/firebase_service/splash_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation? animation;
  late AnimationController? animationController;
  SplashService splashService = SplashService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashService.isLogin(context);
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    animation = Tween(begin: 0.0, end: 1.0)
        .animate(animationController as Animation<double>);
    animationController?.addListener(() {
      setState(() {});
    });

    animationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var opac = 0.0;
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.blue,
      child: Center(
        child: Container(
          width: 300,
          height: 300,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: animation?.value,
                duration: Duration(seconds: 5),
                child: Text(
                  "Contact App",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SpinKitDualRing(
                size: 40,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
