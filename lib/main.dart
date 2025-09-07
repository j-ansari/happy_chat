import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:happy_chat_app/src/core/helper/starter.dart';
import 'package:happy_chat_app/src/core/sl.dart';
import 'package:happy_chat_app/src/data/repo/auth_repo.dart';
import 'package:happy_chat_app/src/data/repo/cantact_repo.dart';
import 'package:happy_chat_app/src/view_model/auth/auth_cubit.dart';
import 'package:happy_chat_app/src/view_model/contacts/contacts_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await setupDependencies();
  final startWidget = await Starter.decideStartWidget();
  runApp(HappyChatApp(startWidget));
}

class HappyChatApp extends StatelessWidget {
  final Widget start;

  const HappyChatApp(this.start, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(getIt<AuthRepo>())),
        BlocProvider(create: (_) => ContactsCubit(getIt<ContactRepo>())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        locale: const Locale('fa', 'IR'),
        supportedLocales: const [Locale('fa', 'IR'), Locale('en', 'US')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: start,
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
