import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/widgets/rounded_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  // Set default `_initialized` and `_error` state to false
  bool _loading = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _loading = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
    _loading = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initializeFlutterFire();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    // animation = CurvedAnimation(parent: controller, curve: Curves.bounceInOut); // ini bikin animasi yang non linear, jadi naiknya tu ga linear 0 ke 1 gitu.
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white70).animate(
        controller); // ini tween untuk yang warna, ada banyak macem tween liat2 aja.
    controller.forward(); // untuk jalan ke depan
//    controller.reverse(from: 100.0); jalan kebalik.
    controller.addListener(() {
      //add listener terus taroh setstate di dalamnya, jadi setiap ada perubahan dia rebuild.
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: controller.value * 60,
                    ),
                  ),
                  TypewriterAnimatedTextKit(
                    text: ['Flash Chat'],
                    textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                    speed: Duration(milliseconds: 500),
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                onPressed: () {
                  if (_error) {
                    print('ERROR, SOMETHING\'S HAPPENING');
                  } else {
                    //Go to registration screen.
                    Navigator.pushNamed(context, LoginScreen.id);
                  }
                },
                text: 'Log In',
              ),
              RoundedButton(
                color: Colors.blueAccent,
                text: 'Register',
                onPressed: () {
                  if (_error) {
                    print('ERROR, SOMETHING\'S HAPPENING');
                  } else {
                    //Go to registration screen.
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
