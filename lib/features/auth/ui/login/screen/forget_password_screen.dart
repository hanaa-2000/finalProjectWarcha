import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warcha_final_progect/core/routing/routes.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  String message = '';
  bool isSuccess = false;

  Future<void> resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        message = 'Please enter your email';
        isSuccess = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      await _auth.sendPasswordResetEmail(email: email);
      setState(() {
        message = '✅ A password reset link has been sent to your email.';
        isSuccess = true;
      });

      // الرجوع بعد ثوانٍ لصفحة تسجيل الدخول
      Future.delayed(Duration(seconds: 3), () {
        //Navigator.pop(context); // ارجع لصفحة تسجيل الدخول
        Navigator.pushReplacementNamed(context,Routes.login);

      });
    } catch (e) {
      setState(() {
        message = '❌ حدث خطأ: ${e.toString()}';
        isSuccess = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text("Forgot your password?")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              "Enter your email to send a password reset link.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator(color: Colors.blue,)
                : ElevatedButton(
              onPressed: resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text("Send link", style: TextStyle(fontSize: 16 , color: Colors.white)),
            ),
            SizedBox(height: 20),
            if (message.isNotEmpty)
              Text(
                message,
                style: TextStyle(
                  color: isSuccess ? Colors.white : Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
