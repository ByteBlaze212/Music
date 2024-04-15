
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_melo/navigationbar.dart';
import 'package:user_melo/signup.dart';

import 'color.dart';

class logintry extends StatefulWidget {
  const logintry({super.key});

  @override
  State<logintry> createState() => _logintryState();
}

class _logintryState extends State<logintry> {
  final GlobalKey<FormState> FormKey = GlobalKey <FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  var password = true;
  @override
  Widget build(BuildContext context) => Container(
    alignment: Alignment.center,
    //  padding: EdgeInsets.all(32),
    decoration: const BoxDecoration(
      image: DecorationImage(
          image: AssetImage('assets/images/ghlogin.jpg'),
          fit: BoxFit.cover),
    ),
    child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Bgr,
              Colors.white12,
            ]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: FormKey,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text('Login',style:TextStyle(
                      //   fontStyle:FontStyle.italic,color:Colors.white70,fontSize: 35,
                      // )),
                      const SizedBox(
                        height: 300,
                        child: Center(
                          child: Text('Login',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.white70,
                                fontSize: 35,
                              )),
                        ),
                      ),

                      Center(
                        child: Container(
                          height: 400,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter email";
                                  } else if (!value.contains("@") ||
                                      !value.contains(".")) {
                                    return "Please enter your Email";
                                  }
                                  return null;
                                },
                                controller: _emailController,
                                //fillColor: Colors.white.withOpacity(0.6),
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter Password";
                                  }
                                  return null;
                                },
                                controller: _passwordController,
                                obscureText: password,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic),
                                  prefixIcon:
                                  const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        password = !password;
                                      });
                                    },
                                    icon: password
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 50),
                              Container(
                                height: 50,
                                width: 310,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 5, color: Colors.transparent),
                                    color: Bgr),
                                child: ElevatedButton(
                                    onPressed: () async {
                                      if (FormKey.currentState!.validate()) {
                                        try {
                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                          );
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                BottomNavigationHome(selectedIndex: 0)),
                                          );
                                          setState(() {
                                            _emailController.clear();
                                            _passwordController.clear();
                                          });
                                        } on FirebaseAuthException catch (e) {
                                          if (e.code == "user-not-found" ||
                                              e.code == "wrong-password") {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Invalid email or password"),
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.transparent),
                                      shadowColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.transparent),
                                    ),
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 20),
                                    )),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account?",
                                      style: TextStyle(color: Colors.white)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                               Signup()));
                                    },
                                    child: const Text('Sign Up',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.yellow)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
