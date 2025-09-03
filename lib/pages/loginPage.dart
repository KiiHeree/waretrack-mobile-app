import 'package:flutter/material.dart';
import 'package:waretrack/api/apiService.dart';
import 'package:waretrack/pages/homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiService _authService = ApiService();

  void login() async {
    bool success = await _authService.login(
      emailController.text,
      passwordController.text,
    );

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login sukses!")));
      // pindah ke home
      Navigator.pushReplacementNamed(context,'/homePage');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login gagal")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorScheme.of(context).primaryContainer,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: Color(0xFFEFEFEF),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // vertical center
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // horizontal center
                  children: [
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Text(
                        "WELCOME BACK",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: ColorScheme.of(context).primary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Image.asset(
                        "images/logo.png",
                        width: 200,
                        height: 200,
                      ),
                    ),

                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 55,
                      decoration: BoxDecoration(
                        color: Color(0XFFF5F9FD),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: ColorScheme.of(
                              context,
                            ).primary.withOpacity(0.3),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 27,
                            color: ColorScheme.of(context).primary,
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            // margin: EdgeInsets.symmetric(),
                            // width: 250,
                            child: TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter Email",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // password input
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 55,
                      decoration: BoxDecoration(
                        color: Color(0XFFF5F9FD),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: ColorScheme.of(
                              context,
                            ).primary.withOpacity(0.3),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock,
                            size: 27,
                            color: ColorScheme.of(context).primary,
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            // margin: EdgeInsets.symmetric(),
                            // width: 250,
                            child: TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter Password",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40),
                    InkWell(
                      onTap: () {
                         login();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: ColorScheme.of(context).primary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF475269).withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
