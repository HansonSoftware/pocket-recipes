import 'package:flutter/material.dart';
import 'package:pocket_recipes/pages/signup_page.dart';
import 'package:pocket_recipes/pages/user_profile_page.dart';
import 'package:pocket_recipes/utilities/submit_login_info.dart';

class LoginForm extends StatefulWidget {
  static const String id = 'Login Form';

  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String username = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login to Pocket Recipes!'),
        foregroundColor: Colors.green,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/img/Logo2.png',
                          width: 224,
                          height: 224,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Text Field Box With Shadow Container
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(171, 171, 171, .7),
                                  blurRadius: 25,
                                  offset: Offset(0, 10)),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200)),
                                ),
                                // This is the username box to integrate.
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Username",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (String? value) {
                                    setState(() {
                                      username = value as String;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200)),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (String? value) {
                                    setState(() {
                                      password = value as String;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 75),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                minimumSize:
                                    MaterialStateProperty.all(Size(180, 50)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ))),
                            onPressed: () {
                              if (username != "" && password != "") {
                                SubmitLogin loginForm =
                                    SubmitLogin.fromFields(username, password);
                                loginForm.login(context, UserProfilePage());
                              }
                              ;
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 30),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.orange.shade700),
                                minimumSize:
                                    MaterialStateProperty.all(Size(180, 50)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ))),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => SignUpPage()));
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
