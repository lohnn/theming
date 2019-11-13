import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Theme, ThemeData;
import 'package:flutter/material.dart' as Material;

class _InheritedJsonTheme extends InheritedWidget {
  const _InheritedJsonTheme({
    Key key,
    @required this.theme,
    @required Widget child,
  })  : assert(theme != null),
        super(key: key, child: child);

  final Theming theme;

  @override
  bool updateShouldNotify(_InheritedJsonTheme old) => theme != old.theme;
}

class JsonTheme extends StatelessWidget {
  final Theming _theming;
  final bool isMaterialAppTheme;
  final Widget child;

  JsonTheme({
    Key key,
    @required this.child,
    Theming theming,
    String json,
    this.isMaterialAppTheme = false,
  })  : assert(child != null),
        assert(json != null || theming != null),
        _theming = theming ?? Theming.fromJson(json),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final oldTheme = of(context);
    final overlaidTheme = oldTheme + _theming;

    return _InheritedJsonTheme(
      key: key,
      child: Material.Theme(
        child: child,
        data: overlaidTheme.themeData,
        isMaterialAppTheme: isMaterialAppTheme,
      ),
      theme: overlaidTheme,
    );
  }

  static final Theming _kFallbackTheme = Theming.fallback();

  static Theming of(BuildContext context) {
    final _InheritedJsonTheme inheritedTheme =
        context.inheritFromWidgetOfExactType(_InheritedJsonTheme);
    return inheritedTheme?.theme ?? _kFallbackTheme;
  }
}

class JsonThemeData {}

///Theme class
class Theming {
  Map<String, dynamic> _colors = {};
  Map<String, Color> _colorCache = {};

  get colors => _colors;

  Theming._new();

  Theming._internal(String input) {
    _colors = jsonDecode(input)['colors'] ?? {};
  }

  ///Creates a theme from json where theme data is parsed and places in the
  ///correct place
  factory Theming.fromJson(String theme) => Theming._internal(theme);

  ///Creates a new theme based upon this one with the new theme data overlaid
  Theming overlayJson(String input) {
    final theming = Theming.fromJson(input);
    return this + theming;
  }

  operator +(Theming overlay) {
    Theming theming = Theming._new();
    theming._colors = this._colors..addAll(overlay.colors);
    return theming;
  }

  ///Gets the [Color] from the theme
  ///If color is not found or a circular dependency is found [NULL] is returned
  Color getColor(String key) {
    return _getColorInternal(key, []);
  }

  Color _getColorInternal(String key, List<String> hasTried) {
    return _colorCache.putIfAbsent(key, () {
      if (hasTried.contains(key)) {
        return null;
      }
      String color = _colors[key];
      if (color == null) {
        return null;
      }
      if (color.contains("#")) {
        return _fromHex(color);
      } else {
        return _getColorInternal(color, hasTried..add(key));
      }
    });
  }

  Material.ThemeData get themeData => Material.ThemeData(
        primarySwatch: getColor("primarySwatch"),
        primaryColor: getColor("primaryColor"),
        primaryColorLight: getColor("primaryColorLight"),
        primaryColorDark: getColor("primaryColorDark"),
        accentColor: getColor("accentColor"),
        canvasColor: getColor("canvasColor"),
        scaffoldBackgroundColor: getColor("scaffoldBackgroundColor"),
        bottomAppBarColor: getColor("bottomAppBarColor"),
        cardColor: getColor("cardColor"),
        dividerColor: getColor("dividerColor"),
        focusColor: getColor("focusColor"),
        hoverColor: getColor("hoverColor"),
        highlightColor: getColor("highlightColor"),
        splashColor: getColor("splashColor"),
        selectedRowColor: getColor("selectedRowColor"),
        unselectedWidgetColor: getColor("unselectedWidgetColor"),
        disabledColor: getColor("disabledColor"),
        buttonColor: getColor("buttonColor"),
        secondaryHeaderColor: getColor("secondaryHeaderColor"),
        textSelectionColor: getColor("textSelectionColor"),
        cursorColor: getColor("cursorColor"),
        textSelectionHandleColor: getColor("textSelectionHandleColor"),
        backgroundColor: getColor("backgroundColor"),
        dialogBackgroundColor: getColor("dialogBackgroundColor"),
        indicatorColor: getColor("indicatorColor"),
        hintColor: getColor("hintColor"),
        errorColor: getColor("errorColor"),
        toggleableActiveColor: getColor("toggleableActiveColor"),
//      brightness: getColor("brightness"),
//      primaryColorBrightness: getColor("primaryColorBrightness"),
//      accentColorBrightness: getColor("accentColorBrightness"),
//      splashFactory: getColor("splashFactory"),
//      buttonTheme: getColor("buttonTheme"),
//      toggleButtonsTheme: getColor("toggleButtonsTheme"),
//      fontFamily: getColor("fontFamily"),
//      textTheme: getColor("textTheme"),
//      primaryTextTheme: getColor("primaryTextTheme"),
//      accentTextTheme: getColor("accentTextTheme"),
//      inputDecorationTheme: getColor("inputDecorationTheme"),
//      iconTheme: getColor("iconTheme"),
//      primaryIconTheme: getColor("primaryIconTheme"),
//      accentIconTheme: getColor("accentIconTheme"),
//      sliderTheme: getColor("sliderTheme"),
//      tabBarTheme: getColor("tabBarTheme"),
//      tooltipTheme: getColor("tooltipTheme"),
//      cardTheme: getColor("cardTheme"),
//      chipTheme: getColor("chipTheme"),
//      platform: getColor("platform"),
//      materialTapTargetSize: getColor("materialTapTargetSize"),
//      applyElevationOverlayColor: getColor("applyElevationOverlayColor"),
//      pageTransitionsTheme: getColor("pageTransitionsTheme"),
//      appBarTheme: getColor("appBarTheme"),
//      bottomAppBarTheme: getColor("bottomAppBarTheme"),
//      colorScheme: getColor("colorScheme"),
//      dialogTheme: getColor("dialogTheme"),
//      floatingActionButtonTheme: getColor("floatingActionButtonTheme"),
//      typography: getColor("typography"),
//      cupertinoOverrideTheme: getColor("cupertinoOverrideTheme"),
//      snackBarTheme: getColor("snackBarTheme"),
//      bottomSheetTheme: getColor("bottomSheetTheme"),
//      popupMenuTheme: getColor("popupMenuTheme"),
//      bannerTheme: getColor("bannerTheme"),
//      dividerTheme: getColor("dividerTheme"),
//      buttonBarTheme: getColor("buttonBarTheme"),
      );

  static Theming fallback() => Theming._new();
}

///Input a string formatted #AARRGGBB or #RRGGBB
Color _fromHex(String hexCode) {
  if (hexCode.startsWith('#')) {
    hexCode = hexCode.substring(1);
  }
  if (hexCode.length == 6) {
    hexCode = "FF" + hexCode;
  }

  List<String> hexDigits = hexCode.split('');
  int a = int.parse(hexDigits.sublist(0, 2).join(), radix: 16);
  int r = int.parse(hexDigits.sublist(2, 4).join(), radix: 16);
  int g = int.parse(hexDigits.sublist(4, 6).join(), radix: 16);
  int b = int.parse(hexDigits.sublist(6).join(), radix: 16);
  return Color.fromARGB(a, r, g, b);
}
