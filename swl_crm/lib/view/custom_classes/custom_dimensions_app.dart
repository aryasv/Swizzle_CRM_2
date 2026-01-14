import 'dart:io';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

class CustomDimensionsApp {
  static double getDimension(
    BuildContext context,
    double mobileSize,
    double tabletSize,
    double desktopSize,
  ) {
    final screenType = getDeviceType(MediaQuery.of(context).size);

    switch (screenType) {
      case DeviceScreenType.mobile:
        return mobileSize;
      case DeviceScreenType.tablet:
        return tabletSize;
      case DeviceScreenType.desktop:
        return desktopSize;
      default:
        return mobileSize;
    }
  }

  static double getFontDimension(
    BuildContext context,
    double mobileSize,
    double tabletSize,
    double desktopSize,
  ) {
    final screenType = getDeviceType(MediaQuery.of(context).size);

    double size = getDimension(context, mobileSize, tabletSize, desktopSize);

    if (Platform.isIOS && screenType == DeviceScreenType.mobile) {
      size *= 1.0;
    }

    return size;
  }

  // Image scaling (minimal adjustments, mainly for tablets)
  static double getImageDimension(
    BuildContext context,
    double mobileSize,
    double tabletSize,
    double desktopSize,
  ) {
    final screenType = getDeviceType(MediaQuery.of(context).size);
    double size = getDimension(context, mobileSize, tabletSize, desktopSize);

    // Only small bump for iPads (images look smaller due to higher DPI)
    if (Platform.isIOS && screenType == DeviceScreenType.tablet) {
      size *= 1.03; // only 3% increase
    }

    return size;
  }
}
