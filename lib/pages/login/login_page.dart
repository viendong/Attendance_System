import 'package:face_net_authentication/base/base_screen.dart';
import 'package:face_net_authentication/base/base_statefull.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/face/face_view.dart';
import 'package:face_net_authentication/pages/login/login_controller.dart';
import 'package:face_net_authentication/pages/student/student_page.dart';
import 'package:face_net_authentication/pages/teacher/teacher_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends BaseStatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  static const String NAME = '/new_home';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController _controller = locator<LoginController>();

  bool isChange = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.loading.value) {
        return Material(
          child: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }

      return BaseScreen(
        body: Material(
          child: Scaffold(
            appBar: PreferredSize(
              child: Center(
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              preferredSize: Size.fromHeight(100),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/home.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SignInButton(
                    Buttons.Google,
                    onPressed: () async {
                      _controller.loadData(context);
                      GoogleSignInAccount? googleSignInAccount =
                          await _controller.signInWithGoogle(context);

                      if (googleSignInAccount == null) {
                        Navigator.pop(context);
                        return;
                      }

                      await _controller.signWithBackend(googleSignInAccount);
                      if (_controller
                          .userState.currentMember!.modelData!.isEmpty) {
                        final modelData =
                            await _controller.screenRouter.goToSubview(
                          FaceDetectorView(),
                        );
                        _controller.userState.currentMember!.modelData =
                            modelData;
                        isChange = true;
                      }

                      if (_controller.userState.currentMember!.role == "") {
                        await showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Obx(
                              () => Container(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Select your role',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 16.0),
                                    DropdownButton<String>(
                                      value: _controller.selectedOption.value,
                                      onChanged: (String? newValue) {
                                        _controller.selectedOption.value =
                                            newValue!;
                                      },
                                      items: [
                                        DropdownMenuItem(
                                          child: Text('Student'),
                                          value: 'Student',
                                        ),
                                        DropdownMenuItem(
                                          child: Text('Teacher'),
                                          value: 'Teacher',
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.0),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Handle the selected option here
                                        print(
                                            'Selected option: ${_controller.selectedOption.value}');
                                        Navigator.pop(
                                            context); // Close the bottom sheet
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                        _controller.userState.currentMember!.role =
                            _controller.selectedOption.value;
                        isChange = true;
                      }

                      if (isChange) {
                        await _controller.memberHttp
                            .Update(_controller.userState.currentMember!);
                        isChange = false;
                      }

                      if (_controller.userState.currentMember!.role ==
                          "Teacher")
                        _controller.screenRouter.goToAndRemoveCurrent(
                          TeacherHomePage.NAME,
                        );
                      else if (_controller.userState.currentMember!.role ==
                          "Student") {
                        _controller.screenRouter.goToAndRemoveCurrent(
                          StudentHomePage.NAME,
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
