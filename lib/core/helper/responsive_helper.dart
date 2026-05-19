import 'package:bnan_app/core/helper/size_config.dart';
import 'package:flutter/widgets.dart';

abstract class ResponsiveHelper {
  // static double height(context, value) =>
  //     MediaQuery.of(context).size.height * (value / 982);
  // static double width(context, value) =>
  //     MediaQuery.of(context).size.width * (value / 1440);

  static double getFontResponsive(BuildContext context, double fontSize) {
    double scaleFactor = getScaleFactor(context);
    double getFontResponsive = scaleFactor * fontSize;
    double lowerLimit = fontSize * .8;
    double upperLimit = fontSize * 1.2;

    return getFontResponsive.clamp(lowerLimit, upperLimit);
  }
}

double getScaleFactor(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width < SizeConfig.tabletSize) {
    //800
    return width / 550;
  } else if (width < SizeConfig.desktopSize) {
    //1200
    return width / 1000;
  } else {
    return width / 1500;
  }
}
