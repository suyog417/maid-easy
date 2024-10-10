import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:maid_easy/maid/home_screen_maid.dart';
import 'package:maid_easy/maid/user_registration_maid.dart';
import 'package:maid_easy/on_boarding/add_address.dart';
import 'package:maid_easy/on_boarding/bloc/on_boarding_cubit.dart';
import 'package:maid_easy/on_boarding/bloc/sign_in_bloc.dart';
import 'package:maid_easy/on_boarding/welcome.dart';
import 'package:maid_easy/screens/bloc/categories_bloc.dart';
import 'package:maid_easy/api/database.dart';
import 'package:maid_easy/screens/bloc/create_job_bloc.dart';
import 'package:maid_easy/screens/home_screen.dart';
import 'package:maid_easy/user_type_selection.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  DatabaseBloc().connectDB();
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
        BlocProvider(create: (context) => DatabaseBloc(),),
        BlocProvider(create: (context) => CreateJobBloc(),)
      ],
      child: MaterialApp(
        title: 'MaidEasy',
        builder: DevicePreview.appBuilder,
        locale: DevicePreview.locale(context),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            accentColor: Colors.lightBlueAccent,
            primarySwatch: Colors.blue
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
              return BlocBuilder<OnBoardingCubit,OnBoardingStates>(
                builder: (context, onBoardingState) {
                  context.read<DatabaseBloc>().connectDB();
                  if(onBoardingState is UserTypeNotSelectedState){
                    return const UserTypeSelection();
                  }
                if(onBoardingState is CustomerDataMissingState){
                  return const AddAddress();
                }
                if(onBoardingState is CustomerUserState){
                  return const HomeScreen();
                }
                if(onBoardingState is MaidDataMissingState){
                 return  const UserRegistrationMaid();
                }
                if(onBoardingState is MaidUserState){
                  return const HomeScreenMaid();
                }
                return const Scaffold();
              },);
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

