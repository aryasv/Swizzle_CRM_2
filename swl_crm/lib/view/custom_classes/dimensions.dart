import 'package:flutter/material.dart';
import 'custom_dimensions_app.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class Dimensions {
  //HOW TO USE - Eg:

  //padding: EdgeInsets.all(Dimensions.pagePadding(context)),
  //width: Dimensions.dimen20_25_25(context)

  static double pagePadding(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 24.0, 32.0, 32.0);
  }

  static double pagePaddingLeft(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 24.0, 32.0, 32.0);
  }

  static double pagePaddingRight(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 24.0, 32.0, 32.0);
  }

  static double pagePaddingHorizontal(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 24.0, 32.0, 32.0);
  }

  static double pagePaddingVertical(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 12.0, 20.0, 20.0);
  }

  static double pageHorizontalPaddingLogin(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 24.0, 120, 120);
  }

  static double pageTopPaddingLogin(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 48.0, 120, 120);
  }

  static double pageBottomPaddingLogin(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 24.0, 34, 34);
  }

  static double pageVerticalPaddingLogin(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 48.0, 72, 72);
  }

  static double paddingInsideCards(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 10.0, 14.0, 14.0);
  }

  static double borderRadiusCards(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 8.0, 8.0, 8.0);
  }

  static double borderRadiusPopup(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 24.0, 24.0, 24.0);
  }

  static double dimenPopupIcon(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 24.0, 32.0, 32.0);
  }

  static double dimenVerticalCardSpacing(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 12.0, 16.0, 16.0);
  }

  static double bottomButtonPadding(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 18.0, 56.0, 56.0);
  }

  //All dimensions
  static double dimen03_06_09(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 3.0, 6.0, 9.0);
  }

  static double dimen03_08_13(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 3.0, 8.0, 13.0);
  }

  static double dimen03_13_23(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 3.0, 13.0, 23.0);
  }

  static double dimen02_04_04(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 2.0, 4.0, 4.0);
  }

  static double dimen03_06_06(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 3.0, 6.0, 6.0);
  }

  static double dimen03_08_08(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 3.0, 8.0, 8.0);
  }

  static double dimen03_09_09(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 3.0, 9.0, 9.0);
  }

  static double dimen03_13_13(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 3.0, 13.0, 13.0);
  }

  static double dimen03_23_23(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 3.0, 23.0, 23.0);
  }

  //
  static double dimen04_08_08(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 4.0, 8.0, 8.0);
  }

  static double dimen04_08_12(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 4.0, 8.0, 12.0);
  }

  //
  static double dimen05_10_15(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 5.0, 10.0, 15.0);
  }

  static double dimen05_15_25(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 5.0, 15.0, 25.0);
  }

  static double dimen05_20_35(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 5.0, 20.0, 35.0);
  }

  static double dimen05_30_40(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 5.0, 30.0, 40.0);
  }

  static double dimen05_08_08(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 5.0, 8.0, 8.0);
  }

  static double dimen05_10_10(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 5.0, 10.0, 10.0);
  }

  static double dimen05_15_15(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 5.0, 15.0, 15.0);
  }

  static double dimen05_20_20(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 5.0, 20.0, 20.0);
  }

  static double dimen05_30_30(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 5.0, 30.0, 30.0);
  }

  static double dimen05_35_35(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 5.0, 35.0, 35.0);
  }

  //
  static double dimen08_13_18(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 8.0, 13.0, 18.0);
  }

  static double dimen08_16_24(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 8.0, 16.0, 24.0);
  }

  static double dimen08_18_28(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 8.0, 18.0, 28.0);
  }

  //
  static double dimen08_12_12(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 8.0, 12.0, 12.0);
  }

  static double dimen08_13_13(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 8.0, 13.0, 13.0);
  }

  static double dimen08_16_16(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 8.0, 16.0, 16.0);
  }

  static double dimen08_20_20(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 8.0, 20.0, 20.0);
  }

  static double dimen08_18_18(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 8.0, 18.0, 18.0);
  }

  static double dimen08_28_28(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 8.0, 28.0, 28.0);
  }

  //
  static double dimen10_13_16(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 10.0, 13.0, 16.0);
  }

  static double dimen10_15_20(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 10.0, 15.0, 20.0);
  }

  static double dimen10_20_30(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 10.0, 20.0, 30.0);
  }

  static double dimen10_25_40(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 10.0, 25.0, 40.0);
  }

  static double dimen10_30_50(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 10.0, 30.0, 50.0);
  }

  static double dimen10_13_13(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 10.0, 13.0, 13.0);
  }

  static double dimen10_15_15(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 10.0, 15.0, 15.0);
  }

  static double dimen10_20_20(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 10.0, 20.0, 20.0);
  }

  static double dimen10_25_25(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 10.0, 25.0, 25.0);
  }

  static double dimen10_30_30(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 10.0, 30.0, 30.0);
  }

  static double dimen10_40_40(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 10.0, 40.0, 40.0);
  }

  static double dimen10_50_50(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 10.0, 50.0, 50.0);
  }

  static double dimen10_80_80(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 10.0, 80.0, 80.0);
  }

  //
  static double dimen12_15_18(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 12.0, 15.0, 18.0);
  }

  static double dimen12_16_16(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 12.0, 16.0, 16.0);
  }

  static double dimen12_17_22(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 12.0, 17.0, 22.0);
  }

  static double dimen12_22_32(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 12.0, 22.0, 32.0);
  }

  static double dimen12_17_17(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 12.0, 17.0, 17.0);
  }

  static double dimen12_22_22(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 12.0, 22.0, 22.0);
  }

  static double dimen12_32_32(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 12.0, 32.0, 32.0);
  }

  //
  static double dimen12_15_15(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 12.0, 15.0, 15.0);
  }

  static double dimen12_20_20(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 12.0, 20.0, 20.0);
  }

  static double dimen13_18_23(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 13.0, 18.0, 23.0);
  }

  static double dimen13_23_33(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 13.0, 23.0, 33.0);
  }

  static double dimen13_18_18(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 13.0, 18.0, 18.0);
  }

  static double dimen13_23_23(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 13.0, 23.0, 23.0);
  }

  static double dimen13_33_33(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 13.0, 33.0, 33.0);
  }

  //
  static double dimen14_17_20(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 14.0, 17.0, 22.0);
  }

  static double dimen14_19_24(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 14.0, 19.0, 24.0);
  }

  static double dimen14_24_34(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 14.0, 24.0, 34.0);
  }

  static double dimen14_17_17(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 14.0, 17.0, 17.0);
  }

  static double dimen14_19_19(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 14.0, 19.0, 19.0);
  }

  static double dimen14_24_24(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 14.0, 24.0, 24.0);
  }

  static double dimen14_34_34(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 14.0, 34.0, 34.0);
  }

  //
  static double dimen15_20_25(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 15.0, 20.0, 25.0);
  }

  static double dimen15_25_35(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 15.0, 25.0, 35.0);
  }

  static double dimen15_30_45(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 15.0, 30.0, 45.0);
  }

  static double dimen15_35_55(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 15.0, 35.0, 55.0);
  }

  static double dimen15_20_20(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 15.0, 20.0, 20.0);
  }

  static double dimen15_25_25(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 15.0, 25.0, 25.0);
  }

  static double dimen15_30_30(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 15.0, 30.0, 30.0);
  }

  static double dimen15_35_35(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 15.0, 35.0, 35.0);
  }

  //
  static double dimen16_20_24(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 16.0, 20.0, 24.0);
  }

  static double dimen16_24_30(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 16.0, 24.0, 30.0);
  }

  static double dimen16_24_32(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 16.0, 24.0, 32.0);
  }

  static double dimen16_26_36(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 16.0, 26.0, 36.0);
  }

  static double dimen16_20_20(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 16.0, 20.0, 20.0);
  }

  static double dimen16_24_24(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 16.0, 24.0, 24.0);
  }

  static double dimen16_26_26(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 16.0, 26.0, 26.0);
  }

  static double dimen16_32_32(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 16.0, 32.0, 32.0);
  }

  static double dimen16_36_36(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 16.0, 36.0, 36.0);
  }

  //
  static double dimen18_23_28(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 18.0, 23.0, 28.0);
  }

  static double dimen18_28_38(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 18.0, 28.0, 38.0);
  }

  static double dimen18_23_23(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 18.0, 23.0, 23.0);
  }

  static double dimen18_28_28(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 18.0, 28.0, 28.0);
  }

  static double dimen18_38_38(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 18.0, 38.0, 38.0);
  }

  //
  static double dimen20_25_30(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 25.0, 30.0);
  }

  static double dimen20_30_40(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 30.0, 40.0);
  }

  static double dimen20_35_50(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 35.0, 50.0);
  }

  static double dimen20_40_60(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 40.0, 60.0);
  }

  static double dimen20_45_70(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 45.0, 70.0);
  }

  static double dimen20_50_80(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 50.0, 80.0);
  }

  static double dimen20_55_90(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 55.0, 90.0);
  }

  static double dimen20_60_100(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 60.0, 100.0);
  }

  static double dimen20_65_110(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 65.0, 110.0);
  }

  static double dimen20_70_120(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 70.0, 120.0);
  }

  static double dimen20_75_130(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 75.0, 130.0);
  }

  static double dimen20_80_140(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 80.0, 140.0);
  }

  static double dimen20_25_25(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 25.0, 25.0);
  }

  static double dimen20_30_30(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 30.0, 30.0);
  }

  static double dimen20_35_35(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 35.0, 35.0);
  }

  static double dimen20_40_40(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 40.0, 40.0);
  }

  static double dimen20_45_45(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 45.0, 45.0);
  }

  static double dimen20_50_50(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 20.0, 50.0, 50.0);
  }

  //
  static double dimen24_25_25(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 24.0, 25.0, 25.0);
  }

  static double bottomNavigationSize(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 24.0, 34.0, 34.0);
  }

  static double dimen24_32_32(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 24.0, 32.0, 32.0);
  }

  //
  static double dimen25_30_35(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 25.0, 30.0, 35.0);
  }

  static double dimen25_35_45(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 25.0, 35.0, 45.0);
  }

  static double dimen25_40_55(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 25.0, 40.0, 55.0);
  }

  static double dimen25_45_65(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 25.0, 45.0, 65.0);
  }

  static double dimen25_50_75(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 25.0, 50.0, 75.0);
  }

  static double dimen25_30_30(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 25.0, 30.0, 30.0);
  }

  static double dimen25_35_35(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 25.0, 35.0, 35.0);
  }

  static double dimen25_40_40(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 25.0, 40.0, 40.0);
  }

  static double dimen25_45_45(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 25.0, 45.0, 45.0);
  }

  static double dimen25_50_50(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 25.0, 50.0, 50.0);
  }

  //
  static double dimen30_35_40(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 30.0, 35.0, 40.0);
  }

  static double dimen30_40_50(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 30.0, 40.0, 50.0);
  }

  static double dimen30_45_60(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 30.0, 45.0, 60.0);
  }

  static double dimen30_50_70(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 30.0, 50.0, 70.0);
  }

  static double dimen30_55_80(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 30.0, 55.0, 80.0);
  }

  static double dimen30_60_90(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 30.0, 60.0, 90.0);
  }

  static double dimen30_35_35(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 30.0, 35.0, 35.0);
  }

  static double dimen30_40_40(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 30.0, 40.0, 40.0);
  }

  static double dimen30_45_45(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 30.0, 45.0, 45.0);
  }

  static double dimen30_50_50(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 30.0, 50.0, 50.0);
  }

  static double dimen30_55_55(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 30.0, 55.0, 55.0);
  }

  static double dimen30_60_60(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 30.0, 60.0, 60.0);
  }

  //
  static double dimen32_40_40(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 32.0, 40.0, 40.0);
  }

  static double dimen32_42_52(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 32.0, 42.0, 52.0);
  }

  static double dimen32_42_42(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 32.0, 42.0, 42.0);
  }

  static double dimen32_52_52(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 32.0, 52.0, 52.0);
  }

  //
  static double dimen36_40_40(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 36.0, 40.0, 40.0);
  }

  static double dimen36_44_44(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 36.0, 44.0, 44.0);
  }

  static double dimen36_60_60(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 36.0, 60.0, 60.0);
  }

  //
  static double dimen35_40_45(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 35.0, 40.0, 45.0);
  }

  static double dimen35_45_55(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 35.0, 45.0, 55.0);
  }

  static double dimen35_50_65(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 35.0, 50.0, 65.0);
  }

  static double dimen35_55_75(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 35.0, 55.0, 75.0);
  }

  static double dimen35_40_40(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 35.0, 40.0, 40.0);
  }

  static double dimen35_45_45(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 35.0, 45.0, 45.0);
  }

  static double dimen35_50_50(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 35.0, 50.0, 50.0);
  }

  static double dimen35_55_55(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 35.0, 55.0, 55.0);
  }

  //
  static double dimen40_50_60(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 40.0, 50.0, 60.0);
  }

  static double dimen40_60_80(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 40.0, 60.0, 80.0);
  }

  static double dimen40_70_100(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 40.0, 70.0, 100.0);
  }

  static double dimen40_80_120(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 40.0, 80.0, 120.0);
  }

  static double dimen40_48_48(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 40.0, 48.0, 48.0);
  }

  static double dimen40_50_50(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 40.0, 50.0, 50.0);
  }

  static double dimen40_60_60(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 40.0, 60.0, 60.0);
  }

  static double dimen40_70_70(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 40.0, 70.0, 70.0);
  }

  static double dimen40_80_80(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 40.0, 80.0, 80.0);
  }

  //
  static double dimen45_50_55(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 45.0, 50.0, 55.0);
  }

  static double dimen45_55_65(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 45.0, 55.0, 65.0);
  }

  static double dimen45_60_75(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 45.0, 60.0, 75.0);
  }

  static double dimen45_65_85(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 45.0, 65.0, 85.0);
  }

  static double dimen45_50_50(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 45.0, 50.0, 50.0);
  }

  static double dimen45_55_55(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 45.0, 55.0, 55.0);
  }

  static double dimen45_60_60(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 45.0, 60.0, 60.0);
  }

  static double dimen45_65_65(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 45.0, 65.0, 65.0);
  }

  static double dimen48_56_56(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 48.0, 56.0, 56.0);
  }

  //
  static double dimen50_60_70(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 50.0, 60.0, 70.0);
  }

  static double dimen50_70_90(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 50.0, 70.0, 90.0);
  }

  static double dimen50_75_100(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 50.0, 75.0, 100.0);
  }

  static double dimen50_100_150(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 50.0, 100.0, 150.0);
  }

  static double dimen50_60_60(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 50.0, 60.0, 60.0);
  }

  static double dimen50_70_70(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 50.0, 70.0, 70.0);
  }

  static double dimen50_75_75(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 50.0, 75.0, 75.0);
  }

  static double dimen50_100_100(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 50.0, 100.0, 100.0);
  }

  //
  static double dimen55_65_75(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 55.0, 65.0, 75.0);
  }

  static double dimen55_65_65(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 55.0, 65.0, 65.0);
  }

  static double dimen55_70_70(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 55.0, 70.0, 70.0);
  }

  //
  static double dimen60_70_80(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 60.0, 70.0, 80.0);
  }

  static double dimen60_80_100(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 60.0, 80.0, 100.0);
  }

  static double dimen60_90_110(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 60.0, 90.0, 110.0);
  }

  static double dimen60_90_120(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 60.0, 90.0, 120.0);
  }

  static double dimen60_100_140(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 60.0, 100.0, 140.0);
  }

  static double dimen60_70_70(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 60.0, 70.0, 70.0);
  }

  static double dimen60_80_80(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 60.0, 80.0, 80.0);
  }

  static double dimen60_90_90(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 60.0, 90.0, 90.0);
  }

  static double dimen60_100_100(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 60.0, 100.0, 100.0);
  }

  //
  static double dimen65_75_85(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 65.0, 75.0, 85.0);
  }

  static double dimen65_85_105(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 65.0, 85.0, 105.0);
  }

  static double dimen65_95_115(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 65.0, 95.0, 115.0);
  }

  static double dimen65_115_125(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 65.0, 115.0, 125.0);
  }

  static double dimen65_75_75(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 65.0, 75.0, 75.0);
  }

  static double dimen65_85_85(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 65.0, 85.0, 85.0);
  }

  static double dimen65_95_95(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 65.0, 95.0, 95.0);
  }

  static double dimen65_115_115(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 65.0, 115.0, 115.0);
  }

  //
  static double dimen70_80_90(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 70.0, 80.0, 90.0);
  }

  static double dimen70_90_100(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 70.0, 90.0, 100.0);
  }

  static double dimen70_100_130(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 70.0, 100.0, 130.0);
  }

  static double dimen70_80_80(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 70.0, 80.0, 80.0);
  }

  static double dimen70_90_90(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 70.0, 90.0, 90.0);
  }

  static double dimen70_100_100(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 70.0, 100.0, 100.0);
  }

  //
  static double dimen75_85_95(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 75.0, 85.0, 95.0);
  }

  static double dimen75_90_105(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 75.0, 90.0, 105.0);
  }

  static double dimen75_95_115(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 75.0, 95.0, 115.0);
  }

  static double dimen75_100_125(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 75.0, 100.0, 125.0);
  }

  static double dimen75_85_85(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 75.0, 85.0, 85.0);
  }

  static double dimen75_90_90(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 75.0, 90.0, 90.0);
  }

  static double dimen75_95_95(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 75.0, 95.0, 95.0);
  }

  static double dimen75_100_100(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 75.0, 100.0, 100.0);
  }

  //
  static double dimen80_85_90(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 80.0, 85.0, 90.0);
  }

  static double dimen80_90_100(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 80.0, 90.0, 100.0);
  }

  static double dimen80_95_110(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 80.0, 95.0, 110.0);
  }

  static double dimen80_100_120(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 80.0, 100.0, 120.0);
  }

  static double dimen80_105_130(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 80.0, 105.0, 130.0);
  }

  static double dimen80_110_140(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 80.0, 110.0, 140.0);
  }

  static double dimen80_115_150(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 80.0, 115.0, 150.0);
  }

  static double dimen80_120_160(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 80.0, 120.0, 160.0);
  }

  static double dimen80_85_85(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 80.0, 85.0, 85.0);
  }

  static double dimen80_90_90(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 80.0, 90.0, 90.0);
  }

  static double dimen80_95_95(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 80.0, 95.0, 95.0);
  }

  static double dimen80_100_100(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 80.0, 100.0, 100.0);
  }

  static double dimen80_105_105(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 80.0, 105.0, 105.0);
  }

  static double dimen80_110_110(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 80.0, 110.0, 110.0);
  }

  static double dimen80_115_115(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 80.0, 115.0, 115.0);
  }

  static double dimen80_120_120(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 80.0, 120.0, 120.0);
  }

  //
  static double dimen100_110_120(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 100.0, 110.0, 120.0);
  }

  static double dimen100_120_140(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 100.0, 120.0, 140.0);
  }

  static double dimen100_125_150(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 100.0, 125.0, 150.0);
  }

  static double dimen100_150_200(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 100.0, 150.0, 200.0);
  }

  static double dimen100_200_300(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 100.0, 200.0, 300.0);
  }

  static double dimen100_110_110(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 100.0, 110.0, 110.0);
  }

  static double dimen100_120_120(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 100.0, 120.0, 120.0);
  }

  static double dimen100_125_125(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 100.0, 125.0, 125.0);
  }

  static double dimen100_150_150(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 100.0, 150.0, 150.0);
  }

  static double dimen100_200_200(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 100.0, 200.0, 200.0);
  }

  //

  static double dimen125_135_145(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 125.0, 135.0, 145.0);
  }

  static double dimen125_150_175(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 125.0, 150.0, 175.0);
  }

  static double dimen125_175_225(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 125.0, 175.0, 225.0);
  }

  static double dimen125_135_135(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 125.0, 135.0, 135.0);
  }

  static double dimen125_150_150(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 125.0, 150.0, 150.0);
  }

  static double dimen125_175_175(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 125.0, 175.0, 175.0);
  }

  //
  static double dimen130_140_140(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 130.0, 140.0, 140.0);
  }

  static double dimen130_160_160(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 130.0, 160.0, 160.0);
  }

  static double dimen130_180_180(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 130.0, 180.0, 180.0);
  }

  //
  static double dimen150_175_200(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 150.0, 175.0, 200.0);
  }

  static double dimen150_200_250(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 150.0, 200.0, 250.0);
  }

  static double dimen150_250_400(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 150.0, 250.0, 400.0);
  }

  static double dimen150_300_450(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 150.0, 300.0, 450.0);
  }

  static double dimen150_175_175(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 150.0, 175.0, 175.0);
  }

  static double dimen150_200_200(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 150.0, 200.0, 200.0);
  }

  static double dimen150_250_250(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 150.0, 250.0, 250.0);
  }

  static double dimen150_300_300(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 150.0, 300.0, 300.0);
  }

  //
  static double dimen200_250_250(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 200.0, 250.0, 250.0);
  }

  static double dimen200_300_300(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 200.0, 300.0, 300.0);
  }

  static double dimen250_350_350(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 250.0, 350.0, 350.0);
  }

  //
  static double dimen280_380_380(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 280.0, 380.0, 380.0);
  }

  //
  static double dimen300_400_500(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 300.0, 400.0, 500.0);
  }

  static double dimen300_350_350(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 300.0, 350.0, 350.0);
  }

  static double dimen350_400_400(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 350.0, 400.0, 400.0);
  }

  static double dimen300_400_400(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 300.0, 400.0, 400.0);
  }

  static double dimen400_500_500(BuildContext context) {
    return CustomDimensionsApp.getDimension(context, 400.0, 500.0, 500.0);
  }
}
