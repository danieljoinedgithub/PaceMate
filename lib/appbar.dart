import 'package:flutter/material.dart';

AppBar buildAppBar() {
  return AppBar(
    title: Text(
      'Pacemate',
      style: TextStyle(
        fontFamily: 'Roboto', // Optional: You can choose a custom font if you have one.
        fontWeight: FontWeight.w500,  // Slightly bolder for better visibility.
        fontSize: 24,  // Adjust the size to your liking.
        letterSpacing: 1.5,  // Adds spacing between letters for a clean look.
      ),
    ),
    centerTitle: true,  // Centers the title for a balanced look.
    backgroundColor: Colors.transparent,  // Make the background transparent for a more minimalist feel.
    elevation: 0,  // Removes the shadow for a cleaner design.
  );
}
