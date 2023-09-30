// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:krishishop_admin/components/my_button.dart';
import 'package:krishishop_admin/components/my_snackbar.dart';
import 'package:krishishop_admin/components/my_textfield.dart';
import 'package:krishishop_admin/login_screen.dart';
import 'firebase_services/firebase_auth_methods.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassword = TextEditingController();
  bool user = false;
  final bool isEditable = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  Future signUpUser() async {
    await EasyLoading.show(status: 'Creating your Account!');
    if (emailController.text.trim() == "") {
      showErrorSnackBar(context, 'Email is required!');
    } else if (passwordController.text.trim() == "") {
      showErrorSnackBar(context, 'Password is required!');
    } else if (confirmPassword.text.trim() == "") {
      showErrorSnackBar(context, 'Confirm Password is Empty!');
    } else if (passwordController.text.trim() != confirmPassword.text.trim()) {
      showErrorSnackBar(context, 'Password not Matched!');
    } else {
      await FirebaseAuthMethods(FirebaseAuth.instance).signUpWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          context: context);
    }
    await EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Icon(
                  Icons.lock,
                  size: 120,
                  color: Colors.blue,
                ),
                const SizedBox(height: 50),
                Text(
                  'Let\'s create your Account!',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 30),
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                  inputType: TextInputType.emailAddress,
                  isEditable: isEditable,
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                  inputType: TextInputType.text,
                  isEditable: isEditable,
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: confirmPassword,
                  hintText: "Confirm Password",
                  obscureText: false,
                  inputType: TextInputType.text,
                  isEditable: isEditable,
                ),
                const SizedBox(height: 30),
                MyButton(
                  onTap: signUpUser,
                  title: 'Sign up',
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have and Account?',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
