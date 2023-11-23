import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:campusepsilon/notes/Bloc/Notes/notes_bloc.dart';
import 'package:campusepsilon/notes/Bloc/general/general_bloc.dart';
import 'package:campusepsilon/notes/Screens/HomePage.dart';

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NotesBloc()),
        BlocProvider(create: (context) => GeneralBloc()),
      ],
      child: MaterialApp(
        title: 'Keep Note',
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
          // This widget intercepts the back button press
          onWillPop: () async {
            // Show an exit confirmation dialog
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Exit App?'),
                content: Text('Do you want to exit the app?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      // Close the dialog and allow the app to exit
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Close the dialog and prevent the app from exiting
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No'),
                  ),
                ],
              ),
            );
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xff216106),
              title: const Text('Campus Epsilon', style: TextStyle(fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            body: HomePageNote(),
          ),
        ),
      ),
    );
  }
}
