import 'dart:math';

import 'package:flutter/cupertino.dart';

class Resizable {
  static double font(BuildContext context, double size,
      {bool isAdded = false}) {
    return fontScaleRatioForTablet(context) *
        width(context) *
        size /
        standard(context);
  }

  static double padding(BuildContext context, double size) {
    // return paddingScaleRatioForTablet(context) *
    //     ((MediaQuery.of(context).devicePixelRatio - 1) / 2 + size);

    return paddingScaleRatioForTablet(context) *
        size *
        ((width(context) + standard(context)) / (2 * standard(context)));
  }

  static double borderPadding(BuildContext context, double size) {
    return borderPaddingScaleRatioForTablet(context) *
        size *
        pow(width(context), 3) /
        pow(standard(context), 3);
  }

  static double size(BuildContext context, double size) {
    return sizeScaleRatioForTablet(context) *
        size *
        ((width(context) + standard(context)) / (2 * standard(context)));

    // return sizeScaleRatioForTablet(context) *
    //     ((MediaQuery.of(context).devicePixelRatio - 1) / 2 + size);
  }

  static double size3(BuildContext context, double size) {
    return sizeScaleRatioForTablet(context) *
        size *
        ((width(context) * 2 + standard(context)) / (3 * standard(context)));

    // return sizeScaleRatioForTablet(context) *
    //     ((MediaQuery.of(context).devicePixelRatio - 1) / 2 + size);
  }

  static double size2(BuildContext context, double size) {
    return sizeScaleRatioForTabletLarge(context) *
        size *
        ((width(context) + standard(context)) / (2 * standard(context)));

    // return sizeScaleRatioForTablet(context) *
    //     ((MediaQuery.of(context).devicePixelRatio - 1) / 2 + size);
  }

  static double barSize(BuildContext context, double size) {
    return barSizeScaleRatioForTablet(context) *
        size *
        width(context) /
        standard(context);
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double standard(BuildContext context) {
    return isTablet(context) ? 1024 : 375;
  }

  static double fontScaleRatioForTablet(BuildContext context) {
    return (Resizable.isLandscape(context) ? 0.7 : 1) *
        (isTablet(context) ? 1.5 : 1);
  }

  static double sizeScaleRatioForTablet(BuildContext context) {
    return (Resizable.isLandscape(context) ? 0.7 : 1) *
        (isTablet(context) ? 1.7 : 1);
  }

  static double sizeScaleRatioForTabletLarge(BuildContext context) {
    return (Resizable.isLandscape(context) ? 0.7 : 1) *
        (isTablet(context) ? 2.5 : 1);
  }

  static double barSizeScaleRatioForTablet(BuildContext context) {
    return (Resizable.isLandscape(context) ? 0.7 : 1) *
        (isTablet(context) ? 2 : 1);
  }

  static double borderPaddingScaleRatioForTablet(BuildContext context) {
    return (Resizable.isLandscape(context) ? 0.7 : 1) *
        (isTablet(context) ? 3 : 1);
  }

  static double paddingScaleRatioForTablet(BuildContext context) {
    return (Resizable.isLandscape(context) ? 0.7 : 1) *
        (isTablet(context) ? 2 : 1);
  }

  static bool isLandscape(BuildContext context) {
    return (MediaQuery.of(context).orientation == Orientation.landscape &&
        Resizable.isTablet(context));
  }

  static bool isTablet(BuildContext context) {
    // final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    // return data.size.shortestSide >= 600;

    var size = MediaQuery.of(context).size;
    var diagonal =
        sqrt((size.width * size.width) + (size.height * size.height));
    var isTablet = diagonal > 1100.0;
    return isTablet;
  }
}
