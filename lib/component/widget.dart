// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetScreen {
  button(String text, double w, Function()? onPressed) {
    return Container(
      height: 45,
      width: w,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          backgroundColor: MaterialStatePropertyAll(Colors.indigo.shade800),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.didactGothic(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Container userInput(TextEditingController userInput, String hintTitle, TextInputType keyboardType, bool pw, bool hide, String type, Function()? onPressed) {
    return Container(
      height: 45,
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 25, top: 5, right: 15),
        child: TextField(
            style: GoogleFonts.didactGothic(color: Colors.black, fontWeight: FontWeight.w600),
            obscureText: hide,
            controller: userInput,
            autocorrect: false,
            enableSuggestions: false,
            autofocus: false,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintTitle,
              hintStyle: GoogleFonts.didactGothic(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w600),
              suffixIcon: pw
                  ? IconButton(
                      icon: Icon(
                        hide ? Icons.visibility_off : Icons.visibility,
                        color: Colors.green,
                      ),
                      onPressed: onPressed)
                  : null,
            ),
            keyboardType: type == "Text" ? keyboardType : TextInputType.number,
            inputFormatters: type == "Text" ? [] : [FilteringTextInputFormatter.digitsOnly]),
      ),
    );
  }

  Widget supplierText(Icon icon, String text) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 5),
      child: Row(
        children: [
          icon,
          SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.didactGothic(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
