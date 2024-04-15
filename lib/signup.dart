
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'color.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final Form_key = GlobalKey<FormState>();
  var password = false, con_password = true;
  bool passwordVisible = false;
  bool con_passwordVisible = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController cpass = TextEditingController();
  bool isLoading = false;
  String uniquefilename = DateTime.now().millisecondsSinceEpoch.toString();
  XFile? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/p.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            colors: [
              Colors.red,
              Colors.white30,
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              'Create Account',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.orange,
                fontSize: 28,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: Form_key,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _selectedImage != null
                                ? FileImage(File(_selectedImage!.path))
                                : null,
                            child: _selectedImage == null
                                ? IconButton(
                              onPressed: () async {
                                final ImagePicker _picker = ImagePicker();
                                _selectedImage = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {});
                              },
                              icon: const Icon(Icons.add_a_photo),
                            )
                                : null,
                          ),
                        ),
                        _selectedImage != null
                            ? IconButton(
                          onPressed: () {
                            _selectedImage = null;
                            setState(() {});
                          },
                          icon: const Icon(Icons.cancel),
                        )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your name";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Name',
                              labelStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                              hintText: 'Enter your Name',
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              } else if (!value.contains("@") ||
                                  !value.contains(".")) {
                                return "Please enter valid email";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Email',
                              labelStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                              hintText: 'Enter Email',
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter Password";
                              }
                              return null;
                            },
                            obscureText: !passwordVisible,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                              hintText: 'Set Password',
                              prefixIcon:
                              const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: cpass,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter Password";
                              }
                              return null;
                            },
                            obscureText: !con_passwordVisible,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Confirm Password',
                              labelStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                              hintText: 'Re-enter Password',
                              prefixIcon:
                              const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (con_password == true) {
                                      con_password = false;
                                    } else {
                                      con_password = true;
                                    }

                                    con_passwordVisible = !con_passwordVisible;
                                  });
                                },
                                icon: Icon(
                                  con_passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                          Container(
                            height: 50,
                            width: 310,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 5, color: Colors.transparent),
                              color: lb,
                            ),
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                shadowColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
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
  void _submitForm() async {
    if (Form_key.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        if (_selectedImage != null) {
          final File imageFile = File(_selectedImage!.path);

          Reference referenceRoot = FirebaseStorage.instance.ref();
          Reference referenceDirImage = referenceRoot.child('User_images');
          Reference referenceImageToUpload =
          referenceDirImage.child(uniquefilename);
          await referenceImageToUpload.putFile(imageFile);
          String imageUrl = await referenceImageToUpload.getDownloadURL();

          UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

          await FirebaseFirestore.instance
              .collection("User")
              .doc(userCredential.user!.uid)
              .set({
            "Name": _usernameController.text,
            "Email": _emailController.text,
            "Password": _passwordController.text,
            "UID": FirebaseAuth.instance.currentUser!.uid,
            "DocumentID": userCredential.user!.uid,
            "ProfileImage": imageUrl,
          });

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registered Successfully")));

          // Clear text fields and reset selected image
          _usernameController.clear();
          _emailController.clear();
          _passwordController.clear();
          cpass.clear();
          _selectedImage = null;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select an image")));
        }
      } catch (e) {
        print("Error registering user: $e");
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to register user")));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

}
