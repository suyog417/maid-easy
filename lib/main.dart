import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:maid_easy/maid/home_screen_maid.dart';
import 'package:maid_easy/on_boarding/bloc/on_boarding_cubit.dart';
import 'package:maid_easy/on_boarding/bloc/sign_in_bloc.dart';
import 'package:maid_easy/on_boarding/welcome.dart';
import 'package:maid_easy/screens/bloc/categories_bloc.dart';
import 'package:maid_easy/screens/bloc/database.dart';
import 'package:maid_easy/screens/home_screen.dart';
import 'package:maid_easy/user_type_selection.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  await Hive.initFlutter();
  await Hive.openBox("UserData");
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OnBoardingCubit(),),
        BlocProvider(create: (context) => SignInCubit(),),
        BlocProvider(create: (context) => CategoriesCubit(),),
        BlocProvider(create: (context) => DatabaseBloc(),)
      ],
      child: MaterialApp(
        title: 'MaidEasy',
        builder: DevicePreview.appBuilder,
        locale: DevicePreview.locale(context),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            accentColor: Colors.lightBlueAccent,
            primarySwatch: Colors.lightBlue
          ),
          filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
          )),
          textTheme: GoogleFonts.nunitoSansTextTheme(),
          useMaterial3: true,
        ),
        home: BlocBuilder<SignInCubit,SignInState>(
          builder: (context, state) {

            if(state is AuthLoggedOutState){
              return const Welcome();
            }
            if(state is AuthLoggedInState){
              if(Hive.box("UserData").get('address') == null){
                return const HomeScreen();
                // return const UserTypeSelection();
              }
              // if(Hive.box("UserData").get('isMaid',defaultValue: false)){
              //
              // } else {
              //   return const HomeScreenMaid();
              // }
            }
            if(state is AuthErrorState){
              return Scaffold(
                body: Center(child: Text(state.error),),
              );
            }
            return const Scaffold(
              body: Center(child: Text("Something went wrong."),),
            );
        },),
      ),
    );
  }
}

