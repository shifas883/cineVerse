import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../common_widgets/button.dart';
import '../common_widgets/svgs.dart';
import '../services/authentication/audentication_bloc.dart';
import 'dashboard.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AudenticationBloc, AudenticationState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      Fluttertoast.showToast(
        msg: "Login Successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Dashboard()),
      );

    } else if (state is AuthFailure) {

      Fluttertoast.showToast(
        msg: "Login Failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    // TODO: implement listener
  },
  child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 150),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Log in with your email and password to\naccess your account.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF757575)),
                  ),
                  // const SizedBox(height: 16),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  TextFormField(
                    onSaved: (email) {},
                    onChanged: (email) {},
                    textInputAction: TextInputAction.next,
                    controller: usernameController,
                    decoration: InputDecoration(
                        hintText: "Enter your email",
                        labelText: "Email",

                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: const TextStyle(color: Color(0xFF757575)),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        suffix: SvgPicture.string(
                          MovieSvgs().mailIcon,
                        ),
                        border: authOutlineInputBorder,
                        enabledBorder: authOutlineInputBorder,
                        focusedBorder: authOutlineInputBorder.copyWith(
                            borderSide: const BorderSide(color: Color(0xFFFF7643)))),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: TextFormField(
                      controller: passwordController,
                      onSaved: (password) {},
                      onChanged: (password) {},
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Enter your password",
                          labelText: "Password",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: const TextStyle(color: Color(0xFF757575)),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          suffix: SvgPicture.string(
                            MovieSvgs().lockIcon,
                          ),
                          border: authOutlineInputBorder,
                          enabledBorder: authOutlineInputBorder,
                          focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide: const BorderSide(color: Color(0xFFFF7643)))),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ConfirmButton(
                    text: 'Continue',
                    onTap: (){
                      context.read<AudenticationBloc>().add(
                        LoginRequested(
                          usernameController.text,
                          passwordController.text,
                        ),
                      );
                      setState(() {

                      });

                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  const SizedBox(height: 16),

                ],
              ),
            ),
          ),
        ),
      ),
    ),
);
  }
}

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);


