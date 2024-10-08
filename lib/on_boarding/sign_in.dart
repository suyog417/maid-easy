import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maid_easy/on_boarding/bloc/sign_in_bloc.dart';
import 'package:pinput/pinput.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final signUpKey = GlobalKey<FormState>();
  final TextEditingController _otp = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Opacity(
        opacity: 0.4,
        child: Image.network(
            "https://plus.unsplash.com/premium_photo-1681483534373-2d9250d3e1e9?q=80&w=2016&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
      ),
      bottomSheet: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is AuthCodeSentState){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP sent successfully.")));
          }
          if (state is AuthLoggedInState){

          }
        },
        builder: (context, state) {
          return Form(
            key: signUpKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AutoSizeText(
                    "Login",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(),
                      label: Text("Name"),
                      hintText: "Ex John Doe",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty){
                        return "Name cannot be empty";
                      }
                      return null;
                    },
                    controller: _name,
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  TextFormField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      print(MediaQuery.of(context).padding.bottom);
                      if(value.length == 10){
                        setState(() {

                        });
                      }
                    },
                    decoration: InputDecoration(
                        prefixText: "+91 ",
                        border: const UnderlineInputBorder(),
                        enabledBorder: const UnderlineInputBorder(),
                        label: const Text("Phone Number"),
                        hintText: "1212121212",
                        suffixIcon: TextButton(
                            onPressed: _phone.text.trim().length == 10
                                ? () {
                              // print("+91 ${_phone.text.trim()}");
                              context.read<SignInCubit>().sendOTP("+91 ${_phone.text.trim()}");
                            }
                                : null,
                            child: const AutoSizeText("Verify"))),
                    controller: _phone,
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Phone number is mandatory to use services of this application.";
                      }
                      RegExp regex = RegExp(r"/\+91[0-9]+/gm");
                      if(!regex.hasMatch(value)){
                        return "Enter valid phone number";
                      }
                      return null;
                    },
                    maxLength: 10,
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  const AutoSizeText("OTP"),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  Pinput(
                    enabled: state is AuthCodeSentState,
                    controller: _otp,
                    onCompleted: (value) {
                      context.read<SignInCubit>().verifyOTP(_otp.text.trim());
                    },
                    mainAxisAlignment: MainAxisAlignment.start,
                    defaultPinTheme: PinTheme(
                        textStyle: const TextStyle(fontSize: 22),
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  const AutoSizeText("Resend code in 00:23"),
                  const SizedBox(
                    height: kToolbarHeight,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).viewPadding.bottom,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
