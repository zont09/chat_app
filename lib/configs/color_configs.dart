import 'package:flutter/material.dart';

class ColorConfig {
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF000000);
  static const Color textTertiary = Color(0xFF757575);
  static const Color textQuaternary = Color(0xFF646464);
  static const Color textColor5 = Color(0xFF525252);
  static const Color textColor6 = Color(0xFF332233);
  static const Color textColor7 = Color(0xFFA6A6A6);

  static const Color textColor = Color(0xFF323232);
  static const Color hintText = Color(0xFF7B7C7D);
  static Color shadow = const Color(0xFF000000).withOpacity(0.25);
  static const Color error = Color(0xFFE41E26);
  static const Color border = Color(0xFFD9D9D9);
  static const Color border2 = Color(0xFFACACAC);
  static const Color border4 = Color(0xFFD7D7D7);
  static const Color border3 = Color(0xFF630404);
  static const Color border5 = Color(0xFFB71C1C);
  static const Color border6 = Color(0xFFEDEDED);
  static const Color border7 = Color(0xFFE7E7E7);
  static const Color border8 = Color(0xFFE8E8E8);
  static const Color border9 = Color(0xFFEBEBEB);
  static const Color border10 = Color(0xFFBEBEBE);

  static const Color redState = Color(0xFFFF474E);
  static const Color greenState = Color(0xFF65C728);
  static const Color yellowState = Color(0xFFFFC800);

  static const Color primary1 = Color(0xFF092a51);
  static const Color primary2 = Color(0xFF0c386a);
  static const Color primary3 = Color(0xFF0f4888);
  static const Color primary4 = Color(0xFF135caf);
  static const Color primary5 = Color(0xFF1565c0);
  static const Color primary6 = Color(0xFF4484cd);
  static const Color primary7 = Color(0xFF6298d5);

  static const LinearGradient gradientPrimary1 = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFE41E26),
      Color(0xFFC41D1F),
      Color(0xFFB71C1C),
    ],
    stops: [0.0, 0.7094, 1.0],
  );
  static const LinearGradient gradientPrimary2 = LinearGradient(
    colors: [
      Color(0xFF530303),
      Color(0xFF630404),
      Color(0xFF980606),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 0.525, 1.0],
  );

  static const LinearGradient gradientPrimary3 = LinearGradient(
    colors: [
      Color(0xFFE41E26),
      Color(0xFFC41D1F),
      Color(0xFFB71C1C),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 0.7094, 1.0],
  );

  static const LinearGradient gradientPrimary4 = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color.fromRGBO(255, 255, 255, 0.25),
      Color.fromRGBO(255, 255, 255, 0),
    ],
    stops: [0.0, 1.0],
  );

  static const Color mainText = Color(0xFF343C6A);
  static const Shadow textShadow = Shadow(
    offset: Offset(0, 4),
    blurRadius: 4,
    color: Color(0x1A000000),
  );

  static const BoxShadow boxShadow = BoxShadow(
    color: Color(0x26000000),
    offset: Offset(0, 2),
    blurRadius: 4,
    spreadRadius: 0,
  );

  static const BoxShadow boxShadow2 = BoxShadow(
    color: Color(0x26000000),
    offset: Offset(1, 1),
    blurRadius: 5.9,
    spreadRadius: 0,
  );
}
