import 'package:flutter/material.dart';
import 'package:gopharma/viewmodel/register_viewmodel.dart';
import 'package:provider/provider.dart';

class RegisterEmail extends StatefulWidget {
  const RegisterEmail({Key? key}) : super(key: key);

  @override
  State<RegisterEmail> createState() => _RegisterEmailState();

}

class _RegisterEmailState extends State<RegisterEmail> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _confirmKey = GlobalKey<FormFieldState>();

  @override
  @mustCallSuper
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration Page"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email"
              ),
              validator: (_) {
                return context.read<RegisterViewModel>().isEmailValid ? null : "Email is not valid";
              },
              onChanged: (value) {
                context.read<RegisterViewModel>().setEmail(value);
                print(_emailController.text);
              },
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Password"
              ),
              obscureText: true,
              validator: (_) {
                return context.read<RegisterViewModel>().isPasswordValid ? null : "Password must be at least 8 characters";
              },
              onChanged: (value) {
                context.read<RegisterViewModel>().setPassword(value);
                _confirmKey.currentState!.validate();
              },
            ),
            TextFormField(
              key: _confirmKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: "Confirm Password"
              ),
              obscureText: true,
              validator: (_) {
                return context.read<RegisterViewModel>().isConfirmPasswordValid ? null : "Confirm password must be same";
              },
              onChanged: (value) {
                context.read<RegisterViewModel>().setConfirmPassword(value);
              },
            ),
            Consumer<RegisterViewModel>(
                builder: (context, viewModel, child) {
                  final bool isButtonEnabled =
                      viewModel.isEmailValid &&
                      viewModel.isPasswordValid &&
                      viewModel.isConfirmPasswordValid;

                  return ElevatedButton(
                    child: const Text("Next"),
                    onPressed: isButtonEnabled ? () {

                    } : null,
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}