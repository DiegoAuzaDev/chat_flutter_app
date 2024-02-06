import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isVisible = false;

  void changeVisibleState() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Flutter Chat Application",
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Developed by Diego Auza",
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 5,
                    ),
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
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
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            textCapitalization: TextCapitalization.none,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                labelText: "Email Address"),
                          ),
                          Container(
                            height: 20,
                          ),
                          TextFormField(
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
