import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final fullHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        height: fullHeight * 0.75,

        child: Column(
          children: [],
        ),
        // child: Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         'Sign Up',
        //         style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        //       ),
        //       TextField(
        //         decoration: InputDecoration(
        //           labelText: 'Email',
        //         ),
        //       ),
        //       // TextField(
        //       //   decoration: InputDecoration(
        //       //     labelText: 'Password',
        //       //     obscureText: true,
        //       //   ),
        //       // ),
        //       ElevatedButton(
        //         onPressed: () {
        //           // Handle sign up logic here
        //         },
        //         child: Text('Sign Up'),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
