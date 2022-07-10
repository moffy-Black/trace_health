import 'package:provider/provider.dart';
import 'package:trace_health/home/view/home_view.dart';
import 'package:auth_service/auth_service.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatelessWidget {
  SignUpView({Key? key}) : super(key: key);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CreateAccountEmail(emailController: _emailController),
            const SizedBox(height: 30.0),
            _CreateAccountPassword(passwordController: _passwordController),
            const SizedBox(height: 30.0),
            _SubmitButton(
              email: _emailController,
              password: _passwordController,
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateAccountEmail extends StatelessWidget {
  const _CreateAccountEmail({
    Key? key,
    required this.emailController,
  }) : super(key: key);
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: TextField(
        controller: emailController,
        decoration: const InputDecoration(hintText: 'Email'),
      ),
    );
  }
}

class _CreateAccountPassword extends StatelessWidget {
  const _CreateAccountPassword({
    Key? key,
    required this.passwordController,
  }) : super(key: key);
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Password',
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);
  final TextEditingController email, password;
  // final AuthService _authService = FirebaseAuthService().firebaseAuth;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          await context
              .read<FirebaseAuthService>()
              .createUserWithEmailAndPassword(
                email: email.text,
                password: password.text,
              );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeView(),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
      },
      child: const Text('Create Account'),
    );
  }
}
