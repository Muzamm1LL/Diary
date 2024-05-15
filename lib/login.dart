import 'package:diaryapp/create_acc.dart';
import 'package:diaryapp/extentions.dart';
import 'package:diaryapp/forgot_pass.dart';
import 'package:diaryapp/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class LoginDemo extends StatefulWidget {
  const LoginDemo({Key? key}) : super(key: key);

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  bool _isObscure = true;
  final LocalAuthentication _localAuth = LocalAuthentication();
  // Google Sign-In
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );
  Future<void> _authenticateWithBiometrics() async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
          localizedReason: 'Please authenticate to show account balance',
          options: const AuthenticationOptions(biometricOnly: true));

      if (didAuthenticate) {
        // Successfully authenticated
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Authentication failed
      }
    } on PlatformException catch (e) {
      print('Error during biometric authentication: $e');
    }
  }

  void _googleSignInPressed() async {
    try {
      await _googleSignIn.signIn();
      // Perform additional login logic with the Google user data
      // Redirect to the desired page after successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (error) {
      print('Google Sign-In Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: 'FBF7F7'.toColor(),
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Example: deokdam123',
                  suffixIcon: Icon(Icons.person),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              child: TextFormField(
                obscureText: _isObscure,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              width: 200,
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Login button pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                icon: const Icon(Icons.login),
                label: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            Container(
              width: 100,
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Login button pressed
                  _authenticateWithBiometrics(); // Call biometric authentication
                },
                icon: const Icon(Icons.login),
                label: const Text(
                  'Fingerprint',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 33, 150, 243),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: _googleSignInPressed,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.g_mobiledata_rounded),
                    SizedBox(width: 5),
                    Text(
                      'Sign in with Google',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage()),
                );
              },
              child: const Text('Forgot Password  ?'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateAccountPage()),
                );
              },
              child: const Text('New User? Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
