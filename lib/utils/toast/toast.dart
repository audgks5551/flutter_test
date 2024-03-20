import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../router.dart';

class Toaster {
  static void success(String message) {
    Flushbar(
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 2),
      icon: SvgPicture.asset(
        'assets/images/toast-success-icon.svg',
        width: 30.0,
        height: 30.0,
        colorFilter: const ColorFilter.mode(
            Colors.white, BlendMode.srcIn),
      ),
      backgroundColor: const Color(0xff77b574),
    ).show(RootRouter.navigatorKey.currentContext!);
  }

  static void error(String message) {
    Flushbar(
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 2),
      icon: SvgPicture.asset(
        'assets/images/toast-error-icon.svg',
        width: 30.0,
        height: 30.0,
        colorFilter: const ColorFilter.mode(
            Colors.white, BlendMode.srcIn),
      ),
      backgroundColor: const Color(0xffCB645F),
    ).show(RootRouter.navigatorKey.currentContext!);
  }

  static void warning(String message) {
    Flushbar(
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 2),
      icon: SvgPicture.asset(
        'assets/images/toast-warning-icon.svg',
        width: 30.0,
        height: 30.0,
        colorFilter: const ColorFilter.mode(
            Colors.white, BlendMode.srcIn),
      ),
      backgroundColor: const Color(0xffF9AB43),
    ).show(RootRouter.navigatorKey.currentContext!);
  }
}