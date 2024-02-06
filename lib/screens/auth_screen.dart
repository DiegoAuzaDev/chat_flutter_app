import 'dart:math';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "dart:io";

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isVisible = false;
  var _enteredEmail = "";
  var _enteredPassword = "";
  File? _selectedImage;
  bool _isAuthenticating = false;

  final _formKey = GlobalKey<FormState>();

  void changeVisibleState() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  var _isLogin = true;

  void _submit() async {
    final isValidFormInput = _formKey.currentState!.validate();

    if (!isValidFormInput) {
      return;
    }
    if (!_isLogin && _selectedImage == null) {
      return;
    }

    _formKey.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        final firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child("user_images")
            .child("${userCredentials.user!.uid}.jpg");
        await firebaseStorageRef.putFile(_selectedImage!);
        final imgURl = await firebaseStorageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection("users")
            .doc("${userCredentials.user!.uid}")
            .set(
          {
            "username": "to be done...",
            "email": _enteredEmail,
            "image_url": imgURl,
          },
        );
      }
    } on FirebaseAuthException catch (userCredentialsError) {
      setState(() {
        _isAuthenticating = false;
      });
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            userCredentialsError.message ?? "Authentication Failed.",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Flutter Chat Application",
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Developed by Diego Auza",
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 5,
                    ),
                    color: Theme.of(context).colorScheme.outlineVariant),
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset("assets/chat.png"),
              ),
              Card(
                color: Theme.of(context).colorScheme.outlineVariant,
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _isAuthenticating
                        ? Center(
                            child: SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Authenticating user...",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!_isLogin)
                                  UserImagePicker(
                                    onPickedImage: (pickedImage) {
                                      _selectedImage = pickedImage;
                                    },
                                  ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty ||
                                        !value.contains("@")) {
                                      return "Please enter a valid email address";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredEmail = value!;
                                  },
                                  textCapitalization: TextCapitalization.none,
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                      labelText: "Email Address"),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty ||
                                        value.trim().length < 6) {
                                      return "Password must be at least 6 character long";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredPassword = value!;
                                  },
                                  obscureText: !isVisible,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        changeVisibleState();
                                      },
                                      icon: isVisible
                                          ? const Icon(Icons.visibility)
                                          : const Icon(Icons.visibility_off),
                                    ),
                                    labelText: "Password",
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .brightness ==
                                              Brightness.light
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                    ),
                                    onPressed: () {
                                      _submit();
                                    },
                                    child: Text(
                                      _isLogin ? "Login" : "Signup",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onInverseSurface,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isLogin = !_isLogin;
                                      });
                                    },
                                    child: Text(
                                      _isLogin
                                          ? "Create an account"
                                          : "I already have an account",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
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
