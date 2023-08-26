import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snap_shield_alpha/resources/auth_methods.dart';
import 'package:snap_shield_alpha/responsive/mobile_screen_layout.dart';
import 'package:snap_shield_alpha/responsive/responsive_layout.dart';
import 'package:snap_shield_alpha/responsive/web_screen_layout.dart';
import 'package:snap_shield_alpha/screens/signup_screen.dart';
import 'package:snap_shield_alpha/screens/signup_screen.dart';
import 'package:snap_shield_alpha/utils/colors.dart';
import 'package:snap_shield_alpha/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
          (route) => false);

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBarVal(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    var ctime;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: WillPopScope(
          onWillPop: () {
            DateTime now = DateTime.now();
            if (ctime == null ||
                now.difference(ctime) > const Duration(seconds: 2)) {
              //add duration of press gap
              ctime = now;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      'Press Back Button Again to Exit'))); //scaffold message, you can show Toast message too.
              return Future.value(false);
            }

            return Future.value(true);
          },
          child: Stack(
            children: [
              Container(),
              Container(
                padding: EdgeInsets.only(left: 35, top: 130),
                child: Text(
                  'Welcome\nBack',
                  style: GoogleFonts.kaushanScript(
                    fontSize: 33,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            Text(
                              "Snap Shield",
                              style: GoogleFonts.kaushanScript(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                  color: Colors.black),
                            ),
                            TextField(
                              style: TextStyle(color: Colors.black),
                              controller: _emailController,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextField(
                              style: TextStyle(),
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            InkWell(
                              onTap: loginUser,
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: const ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  color: blueColor,
                                ),
                                child: !_isLoading
                                    ? const Text(
                                        'Log in',
                                      )
                                    : const CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                              ),
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'Sign in',
                            //       style: TextStyle(
                            //           fontSize: 27, fontWeight: FontWeight.w700),
                            //     ),
                            //     CircleAvatar(
                            //       radius: 30,
                            //       backgroundColor: Color(0xff4c505b),
                            //       child: IconButton(
                            //           color: Colors.white,
                            //           onPressed: () {},
                            //           icon: Icon(
                            //             Icons.arrow_forward,
                            //           )),
                            //     )
                            //   ],
                            // ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: const Text(
                                    'Dont have an account?',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen(),
                                    ),
                                  ),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: const Text(
                                      ' Signup.',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     TextButton(
                            //       onPressed: () {
                            //         Navigator.pushNamed(context, 'register');
                            //       },
                            //       child: Text(
                            //         'Sign Up',
                            //         textAlign: TextAlign.left,
                            //         style: TextStyle(
                            //             decoration: TextDecoration.underline,
                            //             color: Color(0xff4c505b),
                            //             fontSize: 18),
                            //       ),
                            //       style: ButtonStyle(),
                            //     ),
                            //     TextButton(
                            //         onPressed: () {},
                            //         child: Text(
                            //           'Forgot Password',
                            //           style: TextStyle(
                            //             decoration: TextDecoration.underline,
                            //             color: Color(0xff4c505b),
                            //             fontSize: 18,
                            //           ),
                            //         )),
                            //   ],
                            // )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
