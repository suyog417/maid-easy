import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maid_easy/on_boarding/bloc/sign_in_bloc.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
        image: const DecorationImage(image: NetworkImage("https://plus.unsplash.com/premium_photo-1681483534373-2d9250d3e1e9?q=80&w=2016&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),fit: BoxFit.cover,opacity: 0.2),
                gradient: LinearGradient(colors: [
                Colors.black.withOpacity(0.7),
                Colors.black
              ],
                  stops: const [
                    0.1,
                    1
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              ),),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  RichText(text: TextSpan(
                      text: "Welcome to",
                      style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.sizeOf(context).width * 0.15,
                          color: Theme.of(context).colorScheme.surface
                      ),
                      children: [
                        TextSpan(
                            text: "\nMaidEasy",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary
                            )
                        ),
                        const TextSpan(
                            text: "\nConnecting homes with helping hands.",
                            style: TextStyle(
                                fontSize: 22
                            ),
                        ),
                      ]
                  ),
                    textAlign: TextAlign.start,
                  ),
                  const Spacer(),
                  const Spacer(),
                  OutlinedButton.icon(
                    icon: const Icon(FontAwesomeIcons.google),
                    onPressed: () {
                      context.read<SignInCubit>().signInWithGoogle();
                    },
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.all(22)
                    ),
                    label: Text("Sign in with Google",style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.surface
                    )),
                  ),
                  const Divider(color: Colors.transparent,),
                  const AutoSizeText.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                          text: "Already have an account?",
                          children: [
                            TextSpan(
                                text: " Sign In",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline
                                )
                            )
                          ]
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
