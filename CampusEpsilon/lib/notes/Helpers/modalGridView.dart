

import 'package:flutter/material.dart';
import 'package:campusepsilon/notes/Widgets/TextFrave.dart';


void showModalGridView( BuildContext ctx ){

  showDialog(
    context: ctx,
    barrierColor: Colors.white60,
    useSafeArea: true,
    builder: (context) 
      => AlertDialog(
        content: Container(
          height: 200,
          child: Column(
            children: [
              TextFrave(text: 'Options')
            ],
          ),
        ),
      ),
  );

}