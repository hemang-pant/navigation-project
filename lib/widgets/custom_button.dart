import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.customColor,
  }) : super(key: key);
  final String text;
  final VoidCallback onTap;
  final Color? customColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: customColor ?? Theme.of(context).primaryColor,
      child: MaterialButton(
        elevation: 5,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: onTap,
        child: Text(text,
        style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                  ),
                  ),
      ),
    );
  }
}
