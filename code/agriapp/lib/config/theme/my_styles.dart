import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agri_ai/config/theme/theme_extensions/header_container_theme_data.dart';

import 'dark_theme_colors.dart';
import 'my_fonts.dart';
import 'light_theme_colors.dart';
import 'theme_extensions/employee_list_item_theme_data.dart';

class MyStyles {
  // Custom employee list item theme
  static EmployeeListItemThemeData getEmployeeListItemTheme({required bool isLightTheme}) {
    return EmployeeListItemThemeData(
      backgroundColor: isLightTheme ? LightThemeColors.employeeListItemBackgroundColor : DarkThemeColors.employeeListItemBackgroundColor,
      iconTheme: IconThemeData(
        color: isLightTheme ? LightThemeColors.employeeListItemIconsColor : DarkThemeColors.employeeListItemIconsColor,
      ),
      nameTextStyle: MyFonts.bodyTextStyle.copyWith(
        fontSize: MyFonts.employeeListItemNameSize,
        fontWeight: FontWeight.bold,
        color: isLightTheme ? LightThemeColors.employeeListItemNameColor : DarkThemeColors.employeeListItemNameColor,
      ),
      subtitleTextStyle: MyFonts.bodyTextStyle.copyWith(
        fontSize: MyFonts.employeeListItemSubtitleSize,
        fontWeight: FontWeight.normal,
        color: isLightTheme ? LightThemeColors.employeeListItemSubtitleColor : DarkThemeColors.employeeListItemSubtitleColor,
      ),
    );
  }

  // Custom header theme
  static HeaderContainerThemeData getHeaderContainerTheme({required bool isLightTheme}) =>
      HeaderContainerThemeData(
          decoration: BoxDecoration(
        color: isLightTheme
            ? LightThemeColors.headerContainerBackgroundColor
            : DarkThemeColors.headerContainerBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ));

  // Icons theme
  static IconThemeData getIconTheme({required bool isLightTheme}) =>
      IconThemeData(
        color: isLightTheme
            ? LightThemeColors.iconColor
            : DarkThemeColors.iconColor,
      );

  // App bar theme
  static AppBarTheme getAppBarTheme({required bool isLightTheme}) =>
      AppBarTheme(
        elevation: 0,
        titleTextStyle:
            getTextTheme(isLightTheme: isLightTheme).bodyMedium!.copyWith(
                  color: Colors.white,
                  fontSize: MyFonts.appBarTittleSize,
                ),
        iconTheme: IconThemeData(
            color: isLightTheme
                ? LightThemeColors.appBarIconsColor
                : DarkThemeColors.appBarIconsColor),
        backgroundColor: isLightTheme
            ? LightThemeColors.appBarColor
            : DarkThemeColors.appbarColor,
             toolbarHeight: 70,
      );

  // Text theme
  static TextTheme getTextTheme({required bool isLightTheme}) => TextTheme(
        labelLarge: MyFonts.buttonTextStyle.copyWith(
          fontSize: MyFonts.buttonTextSize,
        ),
        bodyLarge: (MyFonts.bodyTextStyle).copyWith(
          fontWeight: FontWeight.bold,
          fontSize: MyFonts.bodyLargeSize,
          color: isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor,
        ),
        bodyMedium: (MyFonts.bodyTextStyle).copyWith(
          fontSize: MyFonts.bodyMediumSize,
          color: isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor,
        ),
        displayLarge: (MyFonts.displayTextStyle).copyWith(
          fontSize: MyFonts.displayLargeSize,
          fontWeight: FontWeight.bold,
          color: isLightTheme
              ? LightThemeColors.displayTextColor
              : DarkThemeColors.displayTextColor,
        ),
        bodySmall: TextStyle(
            color: isLightTheme
                ? LightThemeColors.bodySmallTextColor
                : DarkThemeColors.bodySmallTextColor,
            fontSize: MyFonts.bodySmallTextSize),
        displayMedium: (MyFonts.displayTextStyle).copyWith(
            fontSize: MyFonts.displayMediumSize,
            fontWeight: FontWeight.bold,
            color: isLightTheme
                ? LightThemeColors.displayTextColor
                : DarkThemeColors.displayTextColor),
        displaySmall: (MyFonts.displayTextStyle).copyWith(
          fontSize: MyFonts.displaySmallSize,
          fontWeight: FontWeight.bold,
          color: isLightTheme
              ? LightThemeColors.displayTextColor
              : DarkThemeColors.displayTextColor,
        ),
      );

  static ChipThemeData getChipTheme({required bool isLightTheme}) {
    return ChipThemeData(
      backgroundColor: isLightTheme
          ? LightThemeColors.chipBackground
          : DarkThemeColors.chipBackground,
      brightness: Brightness.light,
      labelStyle: getChipTextStyle(isLightTheme: isLightTheme),
      secondaryLabelStyle: getChipTextStyle(isLightTheme: isLightTheme),
      selectedColor: Colors.black,
      disabledColor: Colors.green,
      padding: const EdgeInsets.all(5),
      secondarySelectedColor: Colors.purple,
    );
  }

  // Chips text style
  static TextStyle getChipTextStyle({required bool isLightTheme}) {
    return MyFonts.chipTextStyle.copyWith(
      fontSize: MyFonts.chipTextSize,
      color: isLightTheme
          ? LightThemeColors.chipTextColor
          : DarkThemeColors.chipTextColor,
    );
  }

  // Elevated button text style
  static WidgetStateProperty<TextStyle?>? getElevatedButtonTextStyle(
      bool isLightTheme,
      {bool isBold = true,
      double? fontSize}) {
    return WidgetStateProperty.resolveWith<TextStyle>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return MyFonts.buttonTextStyle.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize ?? MyFonts.buttonTextSize,
            color: isLightTheme
                ? LightThemeColors.buttonTextColor
                : DarkThemeColors.buttonTextColor,
          );
        } else if (states.contains(WidgetState.disabled)) {
          return MyFonts.buttonTextStyle.copyWith(
            fontSize: fontSize ?? MyFonts.buttonTextSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isLightTheme
                ? LightThemeColors.buttonDisabledTextColor
                : DarkThemeColors.buttonDisabledTextColor,
          );
        }
        return MyFonts.buttonTextStyle.copyWith(
          fontSize: fontSize ?? MyFonts.buttonTextSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: isLightTheme
              ? LightThemeColors.buttonTextColor
              : DarkThemeColors.buttonTextColor,
        ); 
      },
    );
  }

  // Elevated button theme data
  static ElevatedButtonThemeData getElevatedButtonTheme({required bool isLightTheme}) =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
          elevation: WidgetStateProperty.all(0),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 8.h)),
          textStyle: getElevatedButtonTextStyle(isLightTheme),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return isLightTheme
                    ? LightThemeColors.buttonColor.withOpacity(0.5)
                    : DarkThemeColors.buttonColor.withOpacity(0.5);
              } else if (states.contains(WidgetState.disabled)) {
                return isLightTheme
                    ? LightThemeColors.buttonDisabledColor
                    : DarkThemeColors.buttonDisabledColor;
              }
              return isLightTheme
                  ? LightThemeColors.buttonTextColor
                  : DarkThemeColors.buttonTextColor; 
            },
          ),
          minimumSize: WidgetStateProperty.all<Size>(
            const Size(double.infinity, 50),
          ),
        ),
      );

  // List tile theme data
  static ListTileThemeData getListTileThemeData({required bool isLightTheme}) {
    return ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      iconColor: isLightTheme
          ? LightThemeColors.listTileIconColor
          : DarkThemeColors.listTileIconColor,
      tileColor: isLightTheme
          ? LightThemeColors.listTileBackgroundColor
          : DarkThemeColors.listTileBackgroundColor,
      titleTextStyle: TextStyle(
        fontSize: MyFonts.listTileTitleSize,
        color: isLightTheme
            ? LightThemeColors.listTileTitleColor
            : DarkThemeColors.listTileTitleColor,
      ),
      subtitleTextStyle: TextStyle(
        fontSize: MyFonts.listTileSubtitleSize,
        color: isLightTheme
            ? LightThemeColors.listTileSubtitleColor
            : DarkThemeColors.listTileSubtitleColor,
      ),
    );
  }

  // Text field borders
  static InputBorder getTextFieldBorder({required bool isLightTheme}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
       color: isLightTheme ? LightThemeColors.borderColor : DarkThemeColors.borderColor,
        width: 2,
      ),
    );
  }

  // Text field focused border
  static InputBorder getTextFieldFocusedBorder({required bool isLightTheme}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: isLightTheme ? LightThemeColors.borderColor : DarkThemeColors.borderColor,
        width: 2,
      ),
    );
  }

static InputDecorationTheme getInputDecorationTheme({required bool isLightTheme}) {
  return InputDecorationTheme(
    border: getTextFieldBorder(isLightTheme: isLightTheme),
    focusedBorder: getTextFieldFocusedBorder(isLightTheme: isLightTheme),
    hintStyle: TextStyle(
      fontWeight: FontWeight.normal, // Ensures hint text is not bold
      color: isLightTheme ? LightThemeColors.hintColor : DarkThemeColors.hintColor,
    ),
    labelStyle: TextStyle(
      fontWeight: FontWeight.normal, // Ensures label text is not bold
      color: isLightTheme ? LightThemeColors.labelColor : DarkThemeColors.labelColor,
    ),
    errorStyle: const TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.red,
    ),
    filled: true, // Enables background color
       fillColor: isLightTheme ? LightThemeColors.textFieldBackground : DarkThemeColors.textFieldBackground,
    // Add more styles if needed
  );
}

}
